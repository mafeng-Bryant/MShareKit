//
//  PPShareTwitter.m
//  PatPat
//
//  Created by patpat on 15/4/18.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import "PPShareTwitter.h"
#import <Social/Social.h>
#import <TwitterKit/TWTRComposer.h>
#import <TwitterKit/TWTRComposerViewController.h>

@implementation PPShareTwitter

+(void)shareToTwitter:(UIViewController *)controller
             withText:(NSString *)text
              withURL:(NSString *)URL
            withImage:(NSString *)imageurl
           resultBack:(void(^)(BOOL result,NSString *des))resultBack
{
   if (@available(iOS 11.0, *)) {
        if ([[Twitter sharedInstance].sessionStore hasLoggedInUsers]) {
            PPHUDView *hudview = [PPHUDView showTo:controller.view];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageurl] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                [hudview hide];
                if (image && finished){
                    TWTRComposer* composer = [[TWTRComposer alloc]init];
                    [composer setURL:[NSURL URLWithString:URL]];
                    [composer setImage:image];
                    [composer showFromViewController:controller completion:^(TWTRComposerResult result) {
                        if (result == TWTRComposerResultCancelled) {
                            resultBack(NO,nil);
                        }else {
                            resultBack(YES,nil);
                        }
                    }];
                }
            }];
        }else {
            [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
                if (session) {
                    PPHUDView *hudview = [PPHUDView showTo:controller.view];
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageurl] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                        [hudview hide];
                        if (image && finished){
                            TWTRComposer* composer = [[TWTRComposer alloc]init];
                            [composer setURL:[NSURL URLWithString:URL]];
                            [composer setImage:image];
                            [composer showFromViewController:controller completion:^(TWTRComposerResult result) {
                                if (result == TWTRComposerResultCancelled) {
                                    resultBack(NO,nil);
                                }else {
                                    resultBack(YES,nil);
                                }
                            }];
                        }
                    }];
                } else {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:PPString(SORRY) message:PPString(CANT_POST_TWITTER_TIPS) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:PPString(CANCEL_STRING) style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:PPString(OK_STRING) style:UIAlertActionStyleDestructive handler:nil];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [controller presentViewController:alertController animated:YES completion:nil];
                    resultBack(NO,nil);
                    return;
                }
            }];
        }
    }else {
        //先判断twitter是否可用
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:PPString(SORRY) message:PPString(CANT_POST_TWITTER_TIPS) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:PPString(CANCEL_STRING) style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:PPString(OK_STRING) style:UIAlertActionStyleDestructive handler:nil];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [controller presentViewController:alertController animated:YES completion:nil];
            resultBack(NO,nil);
            return;
        }
        //twitter分享图片需要分享本地图片，故需要先下载后分享。
        PPHUDView *hudview = [PPHUDView showTo:controller.view];
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageurl] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            [hudview hide];
            if (image && finished){
                SLComposeViewController *slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                if (!slComposerSheet) { //
                    resultBack(NO,nil);
                }else{
                    [slComposerSheet setInitialText:text];
                    [slComposerSheet addImage:image];
                    if ([URL isKindOfClass:[NSString class]] && URL.length > 0) {
                        [slComposerSheet addURL:[NSURL URLWithString:URL]];
                    }
                    [controller presentViewController:slComposerSheet animated:YES completion:nil];    //进行分享
                    [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                        if (result == SLComposeViewControllerResultDone) {
                            resultBack(YES,nil);
                        }else{
                            resultBack(NO,nil);
                        }
                    }];
                }
            }else{
                resultBack(NO,nil);
            }
        }];
        
    }
}

@end

