//
//  PPSharePinterest.m
//  PatPat
//
//  Created by patpat on 15/4/18.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import "PPSharePinterest.h"
#import "PDKPin.h"
#import "PDKCategories.h"
#import <PDKClient.h>

//notification name
static NSString * const kShareToPinterestNotification   = @"ShareToPinterestNotification";

@interface PPSharePinterest ()
{
    PPSharePinterestCallBack _callBack;
}
@end

@implementation PPSharePinterest

SINGLETON_GCD(PPSharePinterest);

- (void)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
{
    [[PDKClient sharedInstance] handleCallbackURL:url];
    if (!_callBack) {
        return;
    }
    NSString *pinterestResult =  [url.absoluteString urlValueForParameter:@"error"];
    if (!pinterestResult) {
        _callBack(YES);
    }else{
        _callBack(NO);
    }
}

-(void)shareToPinterest:(NSString *)description
           withImageURL:(NSString *)imageURL
          withSourceURL:(NSString *)sourceURL
     suggestedBoardName:(NSString*)suggestedBoardName
             controller:(UIViewController*)controller
             resultBack:(PPSharePinterestCallBack)resultBack
{
    
    PPHUDView *hudview = [PPHUDView showTo:controller.view];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        [hudview hide];
        if (image && finished){
            UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[image,sourceURL] applicationActivities:nil];
            activity.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
                if (completed) {
                    if (!activityError && activityType) {
                        resultBack(YES);
                    }else {
                        resultBack(NO);
                    }
                }
            };
            activity.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,
                                               UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,
                                               UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
            UIPopoverPresentationController *popover = activity.popoverPresentationController;
            if (popover) {
                popover.sourceView = controller.view;
                popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
            }
            [controller presentViewController:activity animated:YES completion:NULL];
        }
    }];
}

@end
