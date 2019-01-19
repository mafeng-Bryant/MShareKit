//
//  UIViewController+PPScreenshotShare.h
//  PatPat
//
//  Created by Chris Zhong on 2018/7/24.
//  Copyright © 2018年 http://www.patpat.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScreeshotShareSuccessCompletionHandler)(UIActivityType activityType);
typedef void(^ScreeshotShareFailureCompletionHandler)(void);
typedef void(^ScreeshotShareCompletionHandlerBlock)(id result);

@interface UIViewController (PPShare)

//@property (nonatomic, strong) NSNumber          *processingFlag;
//@property (nonatomic, strong) UIImage           *snapImage;//截屏图片
//@property (nonatomic, strong) UIView            *shareView;//分享界面

/**
 *  生成截屏分享界面
 *
 *  selector:分享按钮添加的方法
 *  target:方法响应者
 *  target:方法响应者
 *  flag:在展示截屏分享界面时是否需要隐藏导航条
 */
- (void)screenshotHandlerWithShareAction:(SEL)selector
                                  target:(id)target
                 shouldHideNavigationBar:(BOOL)flag
                                   block:(ScreeshotShareCompletionHandlerBlock)block;


/**
 *  处理分享事件
 *
 *  title:分享标题
 *  desc:分享内容
 *  image:分享图片
 *  urlString:分享链接
 *  ctl:原视图控制器
 *  successHandler:成功回调
 *  failureHandler:失败回调
 */
- (void)handleShareWithTitle:(NSString *)title description:(NSString *)desc image:(UIImage *)image soureUrl:(NSString *)urlString success:(ScreeshotShareSuccessCompletionHandler)successHandler failure:(ScreeshotShareFailureCompletionHandler)failureHandler;

@end
