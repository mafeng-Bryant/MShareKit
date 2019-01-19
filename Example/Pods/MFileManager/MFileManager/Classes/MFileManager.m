//
//  MFileManager.m
//  MFileManager_Example
//
//  Created by patpat on 2018/10/19.
//  Copyright © 2018年 1499603656@qq.com. All rights reserved.
//

#import "MFileManager.h"

@implementation MFileManager

static NSMutableArray *_absoluteDirectories = nil;

static NSString *_pathForApplicationSupportDirectory = nil;
static NSString *_pathForCachesDirectory = nil;
static NSString *_pathForDocumentsDirectory = nil;
static NSString *_pathForMainBundleDirectory = nil;
static NSString *_pathForTemporaryDirectory = nil;
static NSString *_logPath = nil;

static NSString * const kLogsFolder   = @".logs";

//System log

+ (NSString *)formatDate:(NSDate *)date style:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)logPath
{
    if (!_logPath) {
        NSString *logName = [[self formatDate:[NSDate date] style:@"yyyy-MM-dd"]  stringByAppendingPathExtension:@"txt"];
        NSString *logPath = [self pathForDocumentsDirectoryWithPath:kLogsFolder];
        _logPath = [logPath stringByAppendingPathComponent:logName];
    }
    return _logPath;
}

+ (void)initLogSystem
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *logPathDir = [self pathForDocumentsDirectoryWithPath:kLogsFolder];
    if (![fileManager fileExistsAtPath:logPathDir isDirectory:nil]) {
        BOOL createDirSucceed = [fileManager createDirectoryAtPath:logPathDir
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error];
        if (!createDirSucceed){
            NSLog(@"Create file directory:%@ failed.", logPathDir);
        }
    }
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:[self logPath]]) {
        NSString *content = [NSString stringWithFormat:@"Today first Open App and Create log file"];
        BOOL isOK = [fileMgr createFileAtPath:[self logPath]
                                     contents:[content dataUsingEncoding:NSUTF8StringEncoding]
                                   attributes:nil];
        if (!isOK) {
            NSLog(@"Bad to create document of Log");
        }
    }else {
        NSString *content = [NSString stringWithFormat:@"\n\n--------------------- START -- %@\nOpen App",[self formatDate:[NSDate date] style:@"yyyy-MM-dd HH:mm:ss"]];
        [self addLog:content];
    }
}

+ (void) addLog:(NSString *)strLog
{
#ifdef DEBUG
    // 取得正常操作修改的文件句柄
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:[self logPath]];
    if (fileHandler) {
        // 移动指针到文件末尾
        [fileHandler seekToEndOfFile];
        // 追加内容
        NSString* newStr = [NSString stringWithFormat:@"\n%@\t\t%@", strLog, [self formatDate:[NSDate date] style:@"yyyy-MM-dd HH:mm:ss"]];
        NSData *data = [newStr dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandler writeData:data];
    }else{
        NSLog(@"write log error");
    }
    [fileHandler closeFile];
#endif
}


+(NSMutableArray *)absoluteDirectories
{
    if(!_absoluteDirectories){
        _absoluteDirectories = [NSMutableArray arrayWithObjects:
                                [self pathForApplicationSupportDirectory],
                                [self pathForCachesDirectory],
                                [self pathForDocumentsDirectory],
                                [self pathForMainBundleDirectory],
                                [self pathForTemporaryDirectory],
                                nil];
        
        [_absoluteDirectories sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return (((NSString *)obj1).length > ((NSString *)obj2).length) ? 0 : 1;
            
        }];
        
        //directories ordered by -length because a directory could be a subpath of another one...
    }
    
    return _absoluteDirectories;
}


+(NSString *)absoluteDirectoryForPath:(NSString *)path
{
    if(!path || [path isEqualToString:@""] || [path isEqualToString:@"/"])
    {
        return nil;
    }
    
    NSMutableArray *directories = [self absoluteDirectories];
    
    for(NSString *directory in directories)
    {
        NSRange indexOfDirectoryInPath = [path rangeOfString:directory];
        
        if(indexOfDirectoryInPath.location == 0)
        {
            return directory;
        }
    }
    
    return nil;
}


+(NSString *)absolutePath:(NSString *)path
{
    NSString *defaultDirectory = [self absoluteDirectoryForPath:path];
    
    if(defaultDirectory != nil)
    {
        return path;
    }
    else {
        return [self pathForDocumentsDirectoryWithPath:path];
    }
}


+(id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key
{
    return [[self attributesOfItemAtPath:path] objectForKey:key];
}


+(id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError **)error
{
    return [[self attributesOfItemAtPath:path error:error] objectForKey:key];
}


+(NSDictionary *)attributesOfItemAtPath:(NSString *)path
{
    return [self attributesOfItemAtPath:path error:nil];
}


+(NSDictionary *)attributesOfItemAtPath:(NSString *)path error:(NSError **)error
{
    return [[NSFileManager defaultManager] attributesOfItemAtPath:[self absolutePath:path] error:error];
}


+(BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath
{
    return [self copyItemAtPath:path toPath:toPath error:nil];
}


+(BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error
{
    return ([self createDirectoriesForFileAtPath:toPath error:error] && [[NSFileManager defaultManager] copyItemAtPath:[self absolutePath:path] toPath:[self absolutePath:toPath] error:error]);
}


+(BOOL)createDirectoriesForFileAtPath:(NSString *)path error:(NSError **)error
{
    NSString *pathLastChar = [path substringFromIndex:(path.length - 1)];
    
    if([pathLastChar isEqualToString:@"/"])
    {
        [NSException raise:@"Invalid path" format:@"file path can't have a trailing '/'."];
        
        return NO;
    }
    
    return [[NSFileManager defaultManager] createDirectoryAtPath:[[self absolutePath:path] stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:error];
}


+(BOOL)createFileAtPath:(NSString *)path
{
    return [self createFileAtPath:path withContent:nil error:nil];
}


+(BOOL)createFileAtPath:(NSString *)path error:(NSError **)error
{
    return [self createFileAtPath:path withContent:nil error:error];
}


+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content
{
    return [self createFileAtPath:path withContent:content error:nil];
}


+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content error:(NSError **)error
{
    if(![self existsItemAtPath:path] && [self createDirectoriesForFileAtPath:path error:error])
    {
        [[NSFileManager defaultManager] createFileAtPath:[self absolutePath:path] contents:nil attributes:nil];
        
        if(content != nil)
        {
            [self writeFileAtPath:path content:content error:error];
        }
        
        return (error == nil);
    }
    
    return NO;
}


+(NSDate *)creationDateOfItemAtPath:(NSString *)path
{
    return [self creationDateOfItemAtPath:path error:nil];
}


+(NSDate *)creationDateOfItemAtPath:(NSString *)path error:(NSError **)error
{
    return (NSDate *)[self attributeOfItemAtPath:path forKey:NSFileCreationDate error:error];
}


+(BOOL)existsItemAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self absolutePath:path]];
}

+(void)createFileDirIfNotExists:(NSString *)fileDir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if (![fileManager fileExistsAtPath:fileDir isDirectory:nil]) {
        BOOL createDirSucceed = [fileManager createDirectoryAtPath:fileDir
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error];
        if (!createDirSucceed)
        {
            NSLog(@"Create file directory:%@ failed.", fileDir);
        }
    }
}


+(BOOL)isDirectoryItemAtPath:(NSString *)path
{
    return [self isDirectoryItemAtPath:path error:nil];
}


+(BOOL)isDirectoryItemAtPath:(NSString *)path error:(NSError **)error
{
    return ([self attributeOfItemAtPath:path forKey:NSFileType error:error] == NSFileTypeDirectory);
}


+(BOOL)isEmptyItemAtPath:(NSString *)path
{
    return [self isEmptyItemAtPath:path error:nil];
}


+(BOOL)isEmptyItemAtPath:(NSString *)path error:(NSError **)error
{
    return ([self isFileItemAtPath:path error:error] && ([[self sizeOfItemAtPath:path error:error] intValue] == 0)) || ([self isDirectoryItemAtPath:path error:error] && ([[self listItemsInDirectoryAtPath:path deep:NO] count] == 0));
}


+(BOOL)isFileItemAtPath:(NSString *)path
{
    return [self isFileItemAtPath:path error:nil];
}


+(BOOL)isFileItemAtPath:(NSString *)path error:(NSError **)error
{
    return ([self attributeOfItemAtPath:path forKey:NSFileType error:error] == NSFileTypeRegular);
}


+(BOOL)isExecutableItemAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] isExecutableFileAtPath:[self absolutePath:path]];
}


+(BOOL)isReadableItemAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] isReadableFileAtPath:[self absolutePath:path]];
}


+(BOOL)isWritableItemAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] isWritableFileAtPath:[self absolutePath:path]];
}


+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path
{
    NSArray *subpaths = [self listItemsInDirectoryAtPath:path deep:NO];
    
    return [subpaths filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        NSString *subpath = (NSString *)evaluatedObject;
        
        return [self isFileItemAtPath:subpath];
    }]];
}


+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension
{
    NSArray *subpaths = [self listFilesInDirectoryAtPath:path];
    
    return [subpaths filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        NSString *subpath = (NSString *)evaluatedObject;
        NSString *subpathExtension = [[subpath pathExtension] lowercaseString];
        NSString *filterExtension = [[extension lowercaseString] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        return [subpathExtension isEqualToString:filterExtension];
    }]];
}


+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix
{
    NSArray *subpaths = [self listFilesInDirectoryAtPath:path];
    
    return [subpaths filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        NSString *subpathLastPathComponent = [(NSString *)evaluatedObject lastPathComponent];
        
        return ([subpathLastPathComponent hasPrefix:prefix] || [subpathLastPathComponent isEqualToString:prefix]);
    }]];
}


+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix
{
    NSArray *subpaths = [self listFilesInDirectoryAtPath:path];
    
    return [subpaths filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        NSString *subpath = (NSString *)evaluatedObject;
        NSString *subpathName = [subpath stringByDeletingPathExtension];
        
        return ([subpath hasSuffix:suffix] || [subpath isEqualToString:suffix] || [subpathName hasSuffix:suffix] || [subpathName isEqualToString:suffix]);
    }]];
}


+(NSArray *)listItemsInDirectoryAtPath:(NSString *)path deep:(BOOL)deep
{
    NSString *absolutePath = [self absolutePath:path];
    NSArray *relativeSubpaths = (deep ? [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:absolutePath error:nil] : [[NSFileManager defaultManager] contentsOfDirectoryAtPath:absolutePath error:nil]);
    
    NSMutableArray *absoluteSubpaths = [[NSMutableArray alloc] init];
    
    for(NSString *relativeSubpath in relativeSubpaths)
    {
        NSString *absoluteSubpath = [absolutePath stringByAppendingPathComponent:relativeSubpath];
        [absoluteSubpaths addObject:absoluteSubpath];
    }
    
    return [NSArray arrayWithArray:absoluteSubpaths];
}


+(BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath
{
    return [self moveItemAtPath:path toPath:toPath error:nil];
}


+(BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error
{
    return ([self createDirectoriesForFileAtPath:toPath error:error] && [[NSFileManager defaultManager] moveItemAtPath:[self absolutePath:path] toPath:[self absolutePath:toPath] error:error]);
}


+(NSString *)pathForApplicationSupportDirectory
{
    if(!_pathForApplicationSupportDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        
        _pathForApplicationSupportDirectory = [paths lastObject];
    }
    
    return _pathForApplicationSupportDirectory;
}


+(NSString *)pathForApplicationSupportDirectoryWithPath:(NSString *)path
{
    return [[self pathForApplicationSupportDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)pathForCachesDirectory
{
    if(!_pathForCachesDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        _pathForCachesDirectory = [paths lastObject];
    }
    
    return _pathForCachesDirectory;
}


+(NSString *)pathForCachesDirectoryWithPath:(NSString *)path
{
    return [[self pathForCachesDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)pathForDocumentsDirectory
{
    if(!_pathForDocumentsDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        _pathForDocumentsDirectory = [paths lastObject];
    }
    
    return _pathForDocumentsDirectory;
}


+(NSString *)pathForDocumentsDirectoryWithPath:(NSString *)path
{
    return [[self pathForDocumentsDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)pathForMainBundleDirectory
{
    if(!_pathForMainBundleDirectory){
        _pathForMainBundleDirectory = [NSBundle mainBundle].resourcePath;
    }
    
    return _pathForMainBundleDirectory;
}


+(NSString *)pathForMainBundleDirectoryWithPath:(NSString *)path
{
    return [[self pathForMainBundleDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)pathForTemporaryDirectory
{
    if(!_pathForTemporaryDirectory){
        _pathForTemporaryDirectory = NSTemporaryDirectory();
    }
    
    return _pathForTemporaryDirectory;
}


+(NSString *)pathForTemporaryDirectoryWithPath:(NSString *)path
{
    return [[self pathForTemporaryDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)readFileAtPath:(NSString *)path
{
    return [self readFileAtPathAsString:path error:nil];
}


+(NSString *)readFileAtPath:(NSString *)path error:(NSError **)error
{
    return [self readFileAtPathAsString:path error:error];
}


+(NSArray *)readFileAtPathAsArray:(NSString *)path
{
    return [NSArray arrayWithContentsOfFile:[self absolutePath:path]];
}


+(NSObject *)readFileAtPathAsCustomModel:(NSString *)path
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self absolutePath:path]];
}


+(NSData *)readFileAtPathAsData:(NSString *)path
{
    return [self readFileAtPathAsData:path error:nil];
}


+(NSData *)readFileAtPathAsData:(NSString *)path error:(NSError **)error
{
    return [NSData dataWithContentsOfFile:[self absolutePath:path] options:NSDataReadingMapped error:error];
}


+(NSDictionary *)readFileAtPathAsDictionary:(NSString *)path
{
    return [NSDictionary dictionaryWithContentsOfFile:[self absolutePath:path]];
}


+(UIImage *)readFileAtPathAsImage:(NSString *)path
{
    return [self readFileAtPathAsImage:path error:nil];
}


+(UIImage *)readFileAtPathAsImage:(NSString *)path error:(NSError **)error
{
    NSData *data = [self readFileAtPathAsData:path error:error];
    
    if(error == nil)
    {
        return [UIImage imageWithData:data];
    }
    
    return nil;
}


+(UIImageView *)readFileAtPathAsImageView:(NSString *)path
{
    return [self readFileAtPathAsImageView:path error:nil];
}


+(UIImageView *)readFileAtPathAsImageView:(NSString *)path error:(NSError **)error
{
    UIImage *image = [self readFileAtPathAsImage:path error:error];
    
    if(error == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView sizeToFit];
        return imageView;
    }
    
    return nil;
}


+(NSDictionary *)readFileAtPathAsJSON:(NSString *)path
{
    return [self readFileAtPathAsJSON:path error:nil];
}


+(NSDictionary *)readFileAtPathAsJSON:(NSString *)path error:(NSError **)error
{
    NSData *data = [self readFileAtPathAsData:path error:error];
    
    if(error == nil)
    {
        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
        
        if([NSJSONSerialization isValidJSONObject:json])
        {
            return (NSDictionary *)json;
        }
    }
    
    return nil;
}


+(NSMutableArray *)readFileAtPathAsMutableArray:(NSString *)path
{
    return [NSMutableArray arrayWithContentsOfFile:[self absolutePath:path]];
}


+(NSMutableData *)readFileAtPathAsMutableData:(NSString *)path
{
    return [self readFileAtPathAsMutableData:path error:nil];
}


+(NSMutableData *)readFileAtPathAsMutableData:(NSString *)path error:(NSError **)error
{
    return [NSMutableData dataWithContentsOfFile:[self absolutePath:path] options:NSDataReadingMapped error:error];
}


+(NSMutableDictionary *)readFileAtPathAsMutableDictionary:(NSString *)path
{
    return [NSMutableDictionary dictionaryWithContentsOfFile:[self absolutePath:path]];
}


+(NSString *)readFileAtPathAsString:(NSString *)path
{
    return [self readFileAtPath:path error:nil];
}


+(NSString *)readFileAtPathAsString:(NSString *)path error:(NSError **)error
{
    return [NSString stringWithContentsOfFile:[self absolutePath:path] encoding:NSUTF8StringEncoding error:error];
}


+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path
{
    return [self removeItemsAtPaths:[self listFilesInDirectoryAtPath:path] error:nil];
}


+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path error:(NSError **)error
{
    return [self removeItemsAtPaths:[self listFilesInDirectoryAtPath:path] error:error];
}


+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension
{
    return [self removeItemsAtPaths:[self listFilesInDirectoryAtPath:path withExtension:extension] error:nil];
}


+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension error:(NSError **)error
{
    return [self removeItemsAtPaths:[self listFilesInDirectoryAtPath:path withExtension:extension] error:error];
}


+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix
{
    return [self removeItemsAtPaths:[self listFilesInDirectoryAtPath:path withPrefix:prefix] error:nil];
}


+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix error:(NSError **)error
{
    return [self removeItemsAtPaths:[self listFilesInDirectoryAtPath:path withPrefix:prefix] error:error];
}


+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix
{
    return [self removeItemsAtPaths:[self listFilesInDirectoryAtPath:path withSuffix:suffix] error:nil];
}


+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix error:(NSError **)error
{
    return [self removeItemsAtPaths:[self listFilesInDirectoryAtPath:path withSuffix:suffix] error:error];
}


+(BOOL)removeItemsInDirectoryAtPath:(NSString *)path
{
    return [self removeItemsInDirectoryAtPath:path error:nil];
}


+(BOOL)removeItemsInDirectoryAtPath:(NSString *)path error:(NSError **)error
{
    return [self removeItemsAtPaths:[self listItemsInDirectoryAtPath:path deep:NO] error:error];
}


+(BOOL)removeItemAtPath:(NSString *)path
{
    return [self removeItemAtPath:path error:nil];
}


+(BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error
{
    return [[NSFileManager defaultManager] removeItemAtPath:[self absolutePath:path] error:error];
}


+(BOOL)removeItemsAtPaths:(NSArray *)paths
{
    return [self removeItemsAtPaths:paths error:nil];
}


+(BOOL)removeItemsAtPaths:(NSArray *)paths error:(NSError **)error
{
    BOOL success = YES;
    
    for(NSString *path in paths)
    {
        success &= [self removeItemAtPath:[self absolutePath:path] error:error];
    }
    
    return success;
}


+(BOOL)renameItemAtPath:(NSString *)path withName:(NSString *)name
{
    return [self renameItemAtPath:path withName:name error:nil];
}


+(BOOL)renameItemAtPath:(NSString *)path withName:(NSString *)name error:(NSError **)error
{
    NSRange indexOfSlash = [name rangeOfString:@"/"];
    
    if(indexOfSlash.location < name.length)
    {
        [NSException raise:@"Invalid name" format:@"file name can't contain a '/'."];
        
        return NO;
    }
    
    return [self moveItemAtPath:path toPath:[[[self absolutePath:path] stringByDeletingLastPathComponent] stringByAppendingPathComponent:name] error:error];
}


+(NSNumber *)sizeOfItemAtPath:(NSString *)path
{
    return [self sizeOfItemAtPath:path error:nil];
}


+(NSNumber *)sizeOfItemAtPath:(NSString *)path error:(NSError **)error
{
    return (NSNumber *)[self attributeOfItemAtPath:path forKey:NSFileSize error:error];
}


+(NSURL *)urlForItemAtPath:(NSString *)path
{
    return [NSURL fileURLWithPath:[self absolutePath:path]];
}


+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content
{
    return [self writeFileAtPath:path content:content error:nil];
}


+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError **)error
{
    if(content == nil)
    {
        [NSException raise:@"Invalid content" format:@"content can't be nil."];
    }
    
    [self createFileAtPath:path withContent:nil error:error];
    
    NSString *absolutePath = [self absolutePath:path];
    
    if([content isKindOfClass:[NSMutableArray class]])
    {
        [((NSMutableArray *)content) writeToFile:absolutePath atomically:YES];
    }
    else if([content isKindOfClass:[NSArray class]])
    {
        [((NSArray *)content) writeToFile:absolutePath atomically:YES];
    }
    else if([content isKindOfClass:[NSMutableData class]])
    {
        [((NSMutableData *)content) writeToFile:absolutePath atomically:YES];
    }
    else if([content isKindOfClass:[NSData class]])
    {
        [((NSData *)content) writeToFile:absolutePath atomically:YES];
    }
    else if([content isKindOfClass:[NSMutableDictionary class]])
    {
        [((NSMutableDictionary *)content) writeToFile:absolutePath atomically:YES];
    }
    else if([content isKindOfClass:[NSDictionary class]])
    {
        [((NSDictionary *)content) writeToFile:absolutePath atomically:YES];
    }
    else if([content isKindOfClass:[NSJSONSerialization class]])
    {
        [((NSDictionary *)content) writeToFile:absolutePath atomically:YES];
    }
    else if([content isKindOfClass:[NSMutableString class]])
    {
        [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:absolutePath atomically:YES];
    }
    else if([content isKindOfClass:[NSString class]])
    {
        [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:absolutePath atomically:YES];
    }
    else if([content isKindOfClass:[UIImage class]])
    {
        [UIImagePNGRepresentation((UIImage *)content) writeToFile:absolutePath atomically:YES];
    }
    else if([content isKindOfClass:[UIImageView class]])
    {
        return [self writeFileAtPath:absolutePath content:((UIImageView *)content).image error:error];
    }
    else if([content conformsToProtocol:@protocol(NSCoding)])
    {
        [NSKeyedArchiver archiveRootObject:content toFile:absolutePath];
    }
    else {
        [NSException raise:@"Invalid content type" format:@"content of type %@ is not handled.", NSStringFromClass([content class])];
        
        return NO;
    }
    return YES;
}



@end
