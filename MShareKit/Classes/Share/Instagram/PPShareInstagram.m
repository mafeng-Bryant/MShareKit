//
//  PPShareInstagram.m
//  PatPat
//
//  Created by patpat on 15/4/18.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import "PPShareInstagram.h"

@interface PPShareInstagram()<UIDocumentInteractionControllerDelegate>
@end

@implementation PPShareInstagram

#pragma mark -
#pragma mark Share To Instagram

- (void)shareToInstagram:(UIViewController *)controller
                   image:(UIImage *)image
                 content:(NSString *)content
                imageUrl:(NSString *)imageurl
              resultBack:(void(^)(BOOL result,NSString *des))resultBack
{
    if (!image && imageurl.length<=0) {
        resultBack(NO,nil);
        return;
    }
    PPHUDView* hudView = [PPHUDView showTo:controller.view];
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL]){
        NSString *imageName = isValidString(imageurl)?[imageurl toMD5]:@"instagram_tmp";
        NSString *fullPath = [PPFileHelper instagramPath:imageName];
        NSURL *hookURL = [NSURL fileURLWithPath:fullPath];
        if (!image) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[imageurl urlByProductImageSize:ProductImageSize3]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                [hudView hide];
                if (image && finished){
                    [UIImagePNGRepresentation(image) writeToFile:fullPath atomically:YES];
                    [self shareToInstagram:controller url:hookURL  resultBack:resultBack];
                }else{
                    resultBack(NO,nil);
                }
            }];
            
        }else{
            [hudView hide];
            [UIImagePNGRepresentation(image) writeToFile:fullPath atomically:YES];
            [self shareToInstagram:controller url:hookURL  resultBack:resultBack];
        }
    }else{
        [UIAlertController showAlertCntroller:controller alertControllerStyle:UIAlertControllerStyleAlert title:PPString(SHAREFAILED) message:PPString(INSTAGRAM_TRY_AGAIN_TIPS) block:^(NSInteger index) {
        } cancelButtonTitle:nil okButtonTitle:PPString(OK_STRING) otherButtonTitles:nil];
        [hudView hide];
        resultBack(NO,PPString(INSTAGRMNOTFOUND));
    }
}


- (void)shareToInstagram:(UIViewController *)controller
              orginImage:(UIImage *)orginImage
                 content:(NSString *)content
                imageUrl:(NSString *)imageurl
              resultBack:(void (^)(BOOL, NSString *))resultBack
{
    
    if (!orginImage && imageurl.length<=0) {
        resultBack(NO,nil);
        return;
    }
    PPHUDView* hudView = [PPHUDView showTo:controller.view];
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL]){
        NSString *imageName = isValidString(imageurl)?[imageurl toMD5]:@"instagram_tmp";
        NSString *fullPath = [PPFileHelper instagramPath:imageName];
        NSURL *hookURL = [NSURL fileURLWithPath:fullPath];
        if (!orginImage) {
            [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageurl] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                [hudView hide];
                if (image && finished){
                    [UIImagePNGRepresentation(image) writeToFile:fullPath atomically:YES];
                    [self shareToInstagram:controller url:hookURL  resultBack:resultBack];
                }else{
                    resultBack(NO,nil);
                }
            }];
        }else{
            [hudView hide];
            [UIImagePNGRepresentation(orginImage) writeToFile:fullPath atomically:YES];
            [self shareToInstagram:controller url:hookURL  resultBack:resultBack];
        }
    }else{
        [hudView hide];
        [UIAlertController showAlertCntroller:controller alertControllerStyle:UIAlertControllerStyleAlert title:PPString(SHAREFAILED) message:PPString(INSTAGRAM_TRY_AGAIN_TIPS) block:^(NSInteger index) {
        } cancelButtonTitle:nil okButtonTitle:PPString(OK_STRING) otherButtonTitles:nil];
        resultBack(NO,PPString(INSTAGRMNOTFOUND));
    }
    
}

- (void)shareToInstagram:(UIViewController *)controller
                     url:(NSURL *)hookURL
              resultBack:(void(^)(BOOL result,NSString *des))resultBack
{
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:hookURL];
    self.documentController.delegate = self;
    [self.documentController setUTI:@"com.instagram.exclusivegram"];
    [self.documentController setAnnotation:@{@"InstagramCaption" : @"patpat.com"}];
    [self.documentController presentOpenInMenuFromRect:CGRectZero inView:controller.view animated:YES];
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(nullable NSString *)application
{
    [self performSelector:@selector(shareInstagramSuccessCallBack) withObject:nil afterDelay:1.0];
}

- (void)shareInstagramSuccessCallBack
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareInstagramSuccess)]) {
        [self.delegate shareInstagramSuccess];
    }
}


@end

