//
//  PPShareFaceBook.m
//  PatPat
//
//  Created by patpat on 15/4/18.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import "PPShareFacebook.h"
#import <Social/Social.h>
#import "PPActivityShareManager.h"
#import "UIAlertController+Alert.h"
#import "PPLocalizedString.h"
#import "MBProgressHUD.h"

@implementation PPShareFacebook

+ (PPShareFacebook *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
    
- (void)shareToFacebookImageLink:(NSString *)title
                     description:(NSString *)description
                            link:(NSString *)link
                      pictureURL:(NSString *)pictureURL
                      controller:(UIViewController *)controller
                      resultBack:(PPShareFacebookBlock)resultBack
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:link];
    _shareDialog  = [[FBSDKShareDialog alloc] init];
    _shareDialog.mode = FBSDKShareDialogModeNative; //只让从fb原生的share
    _shareDialog.fromViewController = controller;
    _shareDialog.shareContent = content;
    if ([_shareDialog canShow]) {
        _shareBlock = resultBack;
        _shareDialog.delegate = self;
        [_shareDialog show];
    }else{
        resultBack(PPShareFacebookResultNotInstall);
    }
}

- (void)sheetStyleShareToFacebookWithLink:(NSString *)linkURL
                                     controller:(UIViewController *)controller
                                     resultBack:(PPShareFacebookBlock)resultBack {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:linkURL];
    _shareDialog  = [[FBSDKShareDialog alloc] init];
    _shareDialog.mode = FBSDKShareDialogModeShareSheet;
    _shareDialog.fromViewController = controller;
    _shareDialog.shareContent = content;
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if ([_shareDialog canShow]) {
        _shareBlock = resultBack;
        _shareDialog.delegate = self;
        [_shareDialog show];
    }else{
        NSError *error = nil;
        [_shareDialog validateWithError:&error];
        resultBack(PPShareFacebookResultOther);
        [UIAlertController showAlertCntroller:[PPActivityShareManager currentVisibleViewController] alertControllerStyle:UIAlertControllerStyleAlert title:PPString(SHAREFAILED) message:PPString(INSTALLFACEBOOKTIPS) block:^(NSInteger index) {
        } cancelButtonTitle:nil okButtonTitle:PPString(OK_STRING) otherButtonTitles:nil];
    }
}

- (void)shareToFacebook:(NSString *)title
            description:(NSString *)description
                   link:(NSString *)link
             pictureURL:(NSString *)pictureURL
             controller:(UIViewController *)controller
             resultBack:(PPShareFacebookBlock)resultBack
{
 
   FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:link];
    content.quote = title;
    _shareDialog  = [[FBSDKShareDialog alloc] init];
    _shareDialog.mode = FBSDKShareDialogModeNative; //只让从fb原生的share
    _shareDialog.fromViewController = controller;
    _shareDialog.shareContent = content;
    if ([_shareDialog canShow]) {
        _shareBlock = resultBack;
        _shareDialog.delegate = self;
        [_shareDialog show];
    }else{
        resultBack(PPShareFacebookResultOther);
        [UIAlertController showAlertCntroller:[PPActivityShareManager currentVisibleViewController] alertControllerStyle:UIAlertControllerStyleAlert title:PPString(SHAREFAILED) message:PPString(INSTALLFACEBOOKTIPS) block:^(NSInteger index) {
        } cancelButtonTitle:nil okButtonTitle:PPString(OK_STRING) otherButtonTitles:nil];
    }
}

- (void)sheetStyleShareToFacebookQuote:(NSString *)quote
                                  link:(NSString *)link
                            controller:(UIViewController *)controller
                            resultBack:(PPShareFacebookBlock)resultBack
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:link];
    content.quote = quote;
    _shareDialog  = [[FBSDKShareDialog alloc] init];
    _shareDialog.mode = FBSDKShareDialogModeShareSheet;
    _shareDialog.fromViewController = controller;
    _shareDialog.shareContent = content;
    if ([_shareDialog canShow]) {
        _shareBlock = resultBack;
        _shareDialog.delegate = self;
        [_shareDialog show];
    }else{
        resultBack(PPShareFacebookResultOther);
        [UIAlertController showAlertCntroller:[PPActivityShareManager currentVisibleViewController] alertControllerStyle:UIAlertControllerStyleAlert title:PPString(SHAREFAILED) message:PPString(INSTALLFACEBOOKTIPS) block:^(NSInteger index) {
        } cancelButtonTitle:nil okButtonTitle:PPString(OK_STRING) otherButtonTitles:nil];
    }
}

- (void)shareToFacebookMessenger:(NSString *)title
                     description:(NSString *)description
                            link:(NSString *)link
                      pictureURL:(NSString *)pictureURL
                      resultBack:(PPShareFacebookBlock)resultBack
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:link];
    _messageDialog = [[FBSDKMessageDialog alloc] init];
    _messageDialog.shareContent = content;
    if ([_messageDialog canShow]) {
        _shareBlock = resultBack;
        _messageDialog.delegate = self;
        [_messageDialog show];
    }else{
        resultBack(PPShareFacebookResultOther);
        [UIAlertController showAlertCntroller:[PPActivityShareManager currentVisibleViewController] alertControllerStyle:UIAlertControllerStyleAlert title:PPString(SHAREFAILED) message:PPString(INSTALLFACEBOOKMESSENGERTIPS) block:^(NSInteger index) {
        } cancelButtonTitle:nil okButtonTitle:PPString(OK_STRING) otherButtonTitles:nil];
    }
}

#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    if (_shareBlock) {
        if ([sharer isEqual:_messageDialog] || [sharer isEqual:_shareDialog]) {
            _shareBlock(PPShareFacebookResultOK);
        }
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    if (_shareBlock) {
        _shareBlock(PPShareFacebookResultError);
    }
    NSString *message = PPString(CONTANCTADMINISTRATORINFO);
    if ([error.userInfo[@"error_reason"] isKindOfClass:[NSString class]]) {
        NSString* desc = ([error.userInfo[@"error_reason"] length]>0?error.userInfo[@"error_reason"]:@"");
        message = [NSString stringWithFormat:@"%@,%@",desc,PPString(CONTANCTADMINISTRATORINFO)];
    }
   [UIAlertController showAlertCntroller:[PPActivityShareManager currentVisibleViewController] alertControllerStyle:UIAlertControllerStyleAlert title:PPString(SHAREFAILED) message:message block:^(NSInteger index) {
    } cancelButtonTitle:nil okButtonTitle:PPString(OK_STRING) otherButtonTitles:nil];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    if (_shareBlock) {
        _shareBlock(PPShareFacebookResultCancel);
    }
}

@end
