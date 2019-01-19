//
//  PPShareEmailAndSMS.h
//  PatPat
//
//  Created by patpat on 15/4/18.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface PPShareEmailAndSMS : NSObject<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

+ (PPShareEmailAndSMS *)sharedInstance;

/**
 *  sms share
 *
 *  @param subject    subject
 *  @param message    message
 *  @param controller 传入的controller
 */
- (void)sendToMessenger:(NSString *)recipients
                subject:(NSString *)subject
                message:(NSString *)message
             controller:(UIViewController *)controller;


/**
 *  email share
 *
 *  @param email      email地址
 *  @param subject    主题
 *  @param message    消息内容
 *  @param isHtml     是否是html
 *  @param controller 传入的controller
 */
- (void)sendToEmail:(NSString *)email
            subject:(NSString *)subject
            message:(NSString *)message
             isHtml:(BOOL)isHtml
         controller:(UIViewController *)controller;

@end
