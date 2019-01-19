//
//  PPActivityShareManager.m
//  PatPat
//
//  Created by 刘曦 on 2018/7/4.
//  Copyright © 2018年 http://www.patpat.com. All rights reserved.
//

#import "PPActivityShareManager.h"
#import <Social/Social.h>

@interface PPActivityShareManager()

@end

@implementation PPActivityShareManager

#pragma mark - share methods
+ (void)activityShareWithTitle:(NSString *)title
                   description:(NSString *)description
                               image:(UIImage *)image
                            soureUrl:(NSString *)sourceURL
                          controller:(UIViewController*)controller
                             success:(ActivityShareSuccessCompletionHandler)success
                             failure:(ActivityShareFailureCompletionHandler)failure
{
    NSMutableArray *activityItems = [NSMutableArray array];
    if ([title isKindOfClass:[NSString class]]) {
        [activityItems addObject:title.length>0?title:@"PatPat"];
    }
    if ([description isKindOfClass:[NSString class]]) {
        [activityItems addObject:description.length>0?description:@"description"];
    }
    if (image) {
        [activityItems addObject:image];
    }
    if ([sourceURL isKindOfClass:[NSString class]]) {
        [activityItems addObject:[NSURL URLWithString:(sourceURL.length>0)?sourceURL:@"https://www.patpat.com"]];
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.popoverPresentationController.sourceView = controller.view;
    activityVC.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [controller presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    __weak UIActivityViewController *weakActivityVC = activityVC;
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) { //分享 成功
            if (!activityError && activityType) {
                if (success) success(activityType);
            } else {
                if (failure) failure();
            }
        } else  { //分享 取消
            if (failure) failure();
        }
        // set to nil after call
        weakActivityVC.completionWithItemsHandler = nil;
    };
}

+ (UIViewController*)currentVisibleViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
