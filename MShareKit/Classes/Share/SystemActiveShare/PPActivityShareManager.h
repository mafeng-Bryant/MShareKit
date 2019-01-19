//
//  PPActivityShareManager.h
//  PatPat
//
//  Created by 刘曦 on 2018/7/4.
//  Copyright © 2018年 http://www.patpat.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ActivityShareSuccessCompletionHandler)(UIActivityType activityType);
typedef void(^ActivityShareFailureCompletionHandler)(void);

@interface PPActivityShareManager : NSObject

/**
 * ActivityShare分享方法
 * @param description 分享描述
 * @param imageURL 分享图片URL
 * @param sourceURL 分享链接
 * @param controller
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)activityShareWithTitle:(NSString *)title
                   description:(NSString *)description
                         image:(UIImage  *)image
                      soureUrl:(NSString *)sourceURL
                    controller:(UIViewController*)controller
                       success:(ActivityShareSuccessCompletionHandler)success
                       failure:(ActivityShareFailureCompletionHandler)failure;

/**
 * VisibleViewController
 */
+ (UIViewController*)currentVisibleViewController;


@end
