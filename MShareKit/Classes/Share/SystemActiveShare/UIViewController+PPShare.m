//
//  UIViewController+PPScreenshotShare.m
//  PatPat
//
//  Created by Chris Zhong on 2018/7/24.
//  Copyright © 2018年 http://www.patpat.com. All rights reserved.
//

#import "UIViewController+PPShare.h"
#import "PPActivityShareManager.h"
#import <objc/runtime.h>
#import "PPUIFont.h"
#import "Masonry.h"
#import "PPLocalizationManager.h"
#import "VMacros.h"
#import "UIView+Extensions.h"

#define MViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

static char kScreenshotProcessingKey;
static char kScreenshotImageKey;
static char kShareViewKey;
static char kHideNavigationBarKey;
static char kCallBlockKey;

@implementation UIViewController (PPShare)

- (void)screenshotHandlerWithShareAction:(SEL)selector
                                  target:(id)target
                 shouldHideNavigationBar:(BOOL)flag
                                   block:(ScreeshotShareCompletionHandlerBlock)block
{
    self.callBackBlock = block;
    if (self.processingFlag.integerValue > 0) return;
    self.hideNavigationBarFlag = [NSNumber numberWithBool:flag];
    self.processingFlag = @1;
    
    UIView *bgView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].delegate.window.bounds];
    bgView.backgroundColor = PPC7;
    
    CGFloat scale = 0.6;
    self.snapImage = [self.view.window getImageForScreenshot];
    UIImageView *iv = [[UIImageView alloc] initWithImage:self.snapImage];
    iv.transform = CGAffineTransformMakeScale(scale, scale);
    iv.layer.shadowColor = PPC4.CGColor;
    iv.layer.shadowOpacity = 0.8f;
    [bgView addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView).offset(-30);
        make.centerX.mas_equalTo(bgView);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage: [UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(bgView).offset(20);
        make.top.mas_equalTo(bgView).offset(kNavigationBarOriginY);
    }];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:shareButton];
    [shareButton setTitle:PPLocalizationString(@"Share Screenshot", nil) forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = PPF2Border;
    [shareButton setBackgroundColor:PPC3];
    [shareButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    MViewRadius(shareButton, 4);
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bgView.mas_bottomMargin).offset(-20);
        make.centerX.mas_equalTo(bgView);
        make.width.mas_equalTo(0.8* kScreenWidth);
        make.height.mas_equalTo(44);
    }];
    
    UILabel *lb = [UILabel new];
    [bgView addSubview:lb];
    lb.font = PPF2;
    lb.textColor = PPC3;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.numberOfLines = 0;
    lb.text = PPLocalizationString(@"Saved to camera roll\nWant to share it with your friends?", nil);
    CGFloat padding = (1 - scale) / 2.0 *  kScreenWidth;
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(shareButton.mas_top).offset(-10);
        make.leading.mas_equalTo(bgView).offset(padding);
        make.trailing.mas_equalTo(bgView).offset(-padding);
    }];
    
    if (flag) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    [self.view addSubview:bgView];
    self.shareView = bgView;
}

- (void)closeButtonClick {
    self.processingFlag = @0;
    [self dismissShareView];
    if (self.callBackBlock) {
        self.callBackBlock(@(1));
    }
}

- (void)dismissShareView {
    if (self.hideNavigationBarFlag.boolValue) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.shareView.y = kScreenHeight;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.shareView removeFromSuperview];
            self.shareView = nil;
            self.snapImage = nil;
            self.processingFlag = nil;
        }
    }];
}

- (void)handleShareWithTitle:(NSString *)title description:(NSString *)desc image:(UIImage *)image soureUrl:(NSString *)urlString success:(ScreeshotShareSuccessCompletionHandler)successHandler failure:(ScreeshotShareFailureCompletionHandler)failureHandler {
    UIImage *shareImage = image ? : self.snapImage;
    [PPActivityShareManager activityShareWithTitle:title description:desc image:shareImage soureUrl:urlString controller:self success:^(UIActivityType activityType) {
        self.processingFlag = @0;
        [self dismissShareView];
        if (successHandler) {
            successHandler (activityType);
        }
    } failure:failureHandler];
}

#pragma mark - associate
//正在处理截屏的标记位,防止处理期间再次截屏
- (NSNumber *)processingFlag {
    id obj = objc_getAssociatedObject(self, &kScreenshotProcessingKey);
    if (obj) {
        return obj;
    }
    NSNumber *num = @0;
    [self setProcessingFlag:num];
    return num;
}

- (void)setProcessingFlag:(NSNumber *)processingFlag {
    objc_setAssociatedObject(self, &kScreenshotProcessingKey, processingFlag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//是否需要隐藏导航条的标记位
- (NSNumber *)hideNavigationBarFlag {
    id obj = objc_getAssociatedObject(self, &kHideNavigationBarKey);
    if (obj) {
        return obj;
    }
    NSNumber *num = @0;
    [self setProcessingFlag:num];
    return num;
}

- (void)setHideNavigationBarFlag:(NSNumber *)hideNavigationBarFlag {
    objc_setAssociatedObject(self, &kHideNavigationBarKey, hideNavigationBarFlag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//截屏图片，持有以便分享时传入
- (UIImage *)snapImage {
    return objc_getAssociatedObject(self, &kScreenshotImageKey);
}

- (void)setSnapImage:(UIImage *)snapImage {
    objc_setAssociatedObject(self, &kScreenshotImageKey, snapImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//展示的分享视图
- (UIView *)shareView {
    return objc_getAssociatedObject(self, &kShareViewKey);
}

- (void)setShareView:(UIView *)shareView {
    objc_setAssociatedObject(self, &kShareViewKey, shareView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setCallBackBlock:(ScreeshotShareCompletionHandlerBlock)block
{
    objc_setAssociatedObject(self, &kCallBlockKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ScreeshotShareCompletionHandlerBlock)callBackBlock
{
    return objc_getAssociatedObject(self, &kCallBlockKey);
}


@end
