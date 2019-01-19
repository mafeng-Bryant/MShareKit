//
//  PPFileManager.m
//  PatPat
//
//  Created by Yuan on 14/12/22.
//  Copyright (c) 2014年 http://www.patpat.com. All rights reserved.
//

#import "PPFileHelper.h"
#import "MFStoreHelper.h"
#import "NSDate+Extensions.h"
#import <SDWebImage/SDImageCache.h>

static NSString * const kLastClearImagesDate = @"patpat.lastclearimagesdate"; //patpat file
static NSString * const kPPFileExtension = @"pp"; //patpat file
static NSString * const kInstagramFileExtension = @"igo"; //instagram file
static NSString * const kSaveFileExtension = @"da"; //instagram file

@implementation PPFileHelper

//Documents/public/Image 图片
+ (NSString *)imagePath
{
    return [PPFileHelper pathForDocumentsDirectoryWithPath:@"public/Image/"];
}

//Documents/user/用户信息
+ (NSString *)userPath
{
    return [PPFileHelper pathForDocumentsDirectoryWithPath:@"user/"];
}

//Documents/configure/配置信息
+ (NSString *)configurePath
{
    return [PPFileHelper pathForDocumentsDirectoryWithPath:@"config/"];
}

//Documents/instagram 分享到Instagram的文件零时存储目录
+ (NSString *)instagramPath
{
    return [PPFileHelper pathForDocumentsDirectoryWithPath:@"instagram/"];
}

+ (NSString*)savePath {
    return [PPFileHelper pathForDocumentsDirectoryWithPath:@"save/"];
}

+ (NSString *)instagramPath:(NSString *)fileName
{
    return [[self instagramPath]stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:kInstagramFileExtension]];
}

+ (NSString *)savePath:(NSString *)fileName
{
    return [[self savePath]stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:kSaveFileExtension]];
}

//Documents/configure/配置信息
+ (NSString *)configurePath:(NSString *)fileName
{
    return [[self configurePath]stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:kPPFileExtension]];
}

+ (NSString *)userPath:(NSNumber *)userId
{
    if (![userId isKindOfClass:[NSNumber class]]) {
        userId = @(0);
    }
    [PPFileHelper createFileDirIfNotExists:[PPFileHelper userPath]];
    return [[self userPath]stringByAppendingPathComponent:[[userId stringValue] stringByAppendingPathExtension:kPPFileExtension]];
}

//初始化路径
+ (void)initFolder
{
//    [PPFileManager initLogSystem];
    [PPFileHelper createFileDirIfNotExists:[PPFileHelper instagramPath]];
    [PPFileHelper createFileDirIfNotExists:[PPFileHelper imagePath]];
    [PPFileHelper createFileDirIfNotExists:[PPFileHelper userPath]];
    [PPFileHelper createFileDirIfNotExists:[PPFileHelper configurePath]];
    [PPFileHelper createFileDirIfNotExists:[PPFileHelper savePath]];
    [PPFileHelper clearImageCache];
}

//超过3天清理一次所有web下载的图片
+ (void)clearImageCache
{
    NSDate *lastClearDate = [MFStoreHelper getValueForKey:kLastClearImagesDate];
    NSDate *threeDaysAgoDate = [[NSDate date] dateBySubtractingDays:3];
    if (!lastClearDate || [threeDaysAgoDate isLaterThanDate:lastClearDate]) { //大于3天,就自动清理一次
        [[SDImageCache sharedImageCache]clearMemory];
        [MFStoreHelper storeValue:[NSDate date] forKey:kLastClearImagesDate];
        NSLog(@"清理图片缓存完成");
    }
}

+ (BOOL)saveData:(id)data name:(NSString *)name
{
    NSString *path = [PPFileHelper configurePath:name];
    BOOL success = [NSKeyedArchiver archiveRootObject:data toFile:path];
    if (success) {
        NSLog(@"save data successful to: %@",path);
    }else{
        NSLog(@"save %@ error!",name);
    }
    return success;
}

+ (id)readData:(NSString *)name
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[PPFileHelper configurePath:name]];
}

@end
