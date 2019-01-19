//
//  PPShareEmailAndSMS.m
//  PatPat
//
//  Created by patpat on 15/4/18.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import "PPShareEmailAndSMS.h"
#import <MessageUI/MessageUI.h>
#import "PPActivityShareManager.h"

@implementation PPShareEmailAndSMS

+ (PPShareEmailAndSMS *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)sendToEmail:(NSString *)email
            subject:(NSString *)subject
            message:(NSString *)message
             isHtml:(BOOL)isHtml
         controller:(UIViewController *)controller
{
    
    if ([MFMailComposeViewController canSendMail]) { //判断是否能发送邮件，部分用户没有设置邮箱账户，需提示。
        MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc]init];
        emailController.mailComposeDelegate = self;
        emailController.modalPresentationStyle = UIModalPresentationFormSheet;
        [emailController setSubject:subject];  //设置主题
        [emailController setMessageBody:message isHTML:isHtml];  //设置邮件内容
        if ([email isKindOfClass:[NSString class]] && email.length>0) {
            NSArray *toRecipients = [NSArray arrayWithObjects:email,nil]; //设置邮件发送对象，email为nil时，则需用户自己填写发送对象。
            [emailController setToRecipients: toRecipients]; //设置邮件发送对象
        }
        [controller presentViewController:emailController animated:YES completion:nil];
    }else{
        [UIAlertController showAlertCntroller:[PPActivityShareManager currentVisibleViewController] alertControllerStyle:UIAlertControllerStyleAlert title:nil message:PPString(SETEAMILACCOUNT) block:^(NSInteger index) {
        } cancelButtonTitle:nil okButtonTitle:PPString(OK_STRING) otherButtonTitles:nil];
    }
}

- (void)sendToMessenger:(NSString *)recipients
                subject:(NSString *)subject
                message:(NSString *)message
             controller:(UIViewController *)controller
{
    if ([MFMessageComposeViewController canSendText]){ //判断用户设备能否发送短信
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc]init];
        messageController.messageComposeDelegate = self;
        messageController.subject = subject;
        if ([recipients isKindOfClass:[NSString class]] && recipients.length > 0) {
            messageController.recipients = @[recipients];
        }
        messageController.body =message;  //短信内容
        [controller presentViewController:messageController animated:YES completion:nil];
    }else{
        [UIAlertController showAlertCntroller:[PPActivityShareManager currentVisibleViewController] alertControllerStyle:UIAlertControllerStyleAlert title:nil message:PPString(SETIMESSAGEACCOUNT) block:^(NSInteger index) {
        } cancelButtonTitle:nil okButtonTitle:PPString(OK_STRING) otherButtonTitles:nil];
    }
}

#pragma mark MFMailComposeViewControllerDelegate Methods
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
    PPHUDView *hudview = [PPHUDView showToWindow];
    if (result == MFMailComposeResultSent){
        [hudview showSuccessedLabelText:PPString(SENDEMAIL_SUCCEEDED)];
    }else if(result ==MFMailComposeResultFailed){
        [hudview showFailurLabelText:PPString(SENDEMAIL_FAILED)];
    }else if (result ==MFMailComposeResultCancelled){
        [hudview showFailurLabelText:PPString(SENDEMAIL_CANCELLED)];
    }else if (result ==MFMailComposeResultSaved){
        [hudview showFailurLabelText:PPString(SENDEMAIL_SAVED)];
    }
}

#pragma mark MFMessageComposeViewControllerDelegate Methods
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    PPHUDView *hudview = [PPHUDView showToWindow];
    if (result == MessageComposeResultSent){
        [hudview showSuccessedLabelText:PPString(SENDMESSAGE_SUCCEEDED)];
    }else if(result == MessageComposeResultFailed){
        [hudview showFailurLabelText:PPString(SENDMESSAGE_FAILED)];
    }else if (result ==MessageComposeResultCancelled){
        [hudview showFailurLabelText:PPString(SENDMESSAGE_CANCELLED)];
    }
}

@end
