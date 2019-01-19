//
//  PPFileManager.h
//  PatPat
//
//  Created by Yuan on 14/12/22.
//  Copyright (c) 2014年 http://www.patpat.com. All rights reserved.
//

#import "MFileManager.h"

@interface PPFileHelper : MFileManager

/**
 *  初始化目录
 */
+ (void)initFolder;

/**
 *  根据userid生成路径
 *
 *  @param userId 用户id
 *
 *  @return 路径
 */
+ (NSString *)userPath:(NSNumber *)userId;

/**
 *  根据filename生存文件路径
 *
 *  @param fileName 文件名
 *
 *  @return 路径
 */
+ (NSString *)configurePath:(NSString *)fileName;

/**
 *  instagram file path
 *
 *  @param fileName 文件名
 *
 *  @return 路径
 */
+ (NSString *)instagramPath:(NSString *)fileName;


/**
 *  save file path
 *
 *  @param fileName 文件名
 *
 *  @return 路径
 */
+ (NSString *)savePath:(NSString *)fileName;


/**
 *  save data
 *
 *  @param data,name
 *
 *  @return Bool
 */
+ (BOOL)saveData:(id)data name:(NSString *)name;

/**
 *  read data
 *
 *  @param name
 *
 *  @return data
 */
+ (id)readData:(NSString *)name;

@end
