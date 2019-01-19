//
//  PPShareInstagram.h
//  PatPat
//
//  Created by patpat on 15/4/18.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PPShareInstagramDelegate <NSObject>

- (void)shareInstagramSuccess;

@end

@interface PPShareInstagram : NSObject
@property (nonatomic,weak) id<PPShareInstagramDelegate>delegate;
@property (nonatomic,strong) id data;//分享的数据源
@property (nonatomic, strong) UIDocumentInteractionController *documentController;

/**
 *  分享内容到Instagram
 *
 *  @param controller  当前控制器
 *  @param image       图片
 *  @param content     内容
 *  @param imageurl    图片地址
 *  @param resultBack  回调
 */
- (void)shareToInstagram:(UIViewController *)controller
                   image:(UIImage *)image
                 content:(NSString *)content
                imageUrl:(NSString *)imageurl
              resultBack:(void(^)(BOOL result,NSString *des))resultBack;


/**
 *  分享内容到Instagram
 *
 *  @param controller  当前控制器
 *  @param orginImage  描述
 *  @param content     内容
 *  @param imageurl    图片地址
 *  @param resultBack  回调
 */
- (void)shareToInstagram:(UIViewController *)controller
                 orginImage:(UIImage *)orginImage
                 content:(NSString *)content
                imageUrl:(NSString *)imageurl
              resultBack:(void (^)(BOOL, NSString *))resultBack;


@end
