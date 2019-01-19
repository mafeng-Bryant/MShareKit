//
//  PPHUDView.m
//  PatPat
//
//  Created by Yuan on 15/1/12.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import "PPHUDView.h"

#define kPPHUDViewAnimationTime 1.6
#define PPHUDViewColor [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:0.9]
#define PFONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

@interface PPHUDView()

-  (void)setImage:(NSString *)imageName
             text:(NSString *)text;

@end

@implementation PPHUDView

- (NSTimeInterval)delayTime:(NSString *)string
{
    if ([string isKindOfClass:[NSString class]]) {
        if (string.length > 25) {//大于25个字就返回2.5s
            return 2.0;
        }else if (string.length > 40){//大于40个字就返回2.6s
            return 2.6;
        }
    }
    return kPPHUDViewAnimationTime;
}

-  (void)setImage:(NSString *)imageName
             text:(NSString *)text
            delay:(CGFloat)time
{
    UIImage* image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.customView = imageView;
    self.mode = MBProgressHUDModeCustomView;
    self.labelFont = PFONT(@"Avenir-Roman",14);
    self.detailsLabelFont = PFONT(@"Avenir-Roman",14);
    self.detailsLabelText = text;
    self.color = PPHUDViewColor;
    [self hide:YES afterDelay:time];
}

- (void)setImage:(NSString *)imageName view:(UIView*)view
{
    UIImage* image = [UIImage imageNamed:imageName];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    self.color =  [UIColor lightGrayColor];
    self.customView = imageView;
    self.labelText = @"";
    self.mode = MBProgressHUDModeCustomView;
    self.frame= CGRectMake(0, 0, 90, 90);
    self.center = view.center;
    self.alpha = 0.9;
    [self hide:YES afterDelay:5.0];
}

-  (void)setImage:(NSString *)imageName
             text:(NSString *)text
           detail:(NSString *)detail
            delay:(CGFloat)time
{
    UIImage* image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.customView = imageView;
    self.mode = MBProgressHUDModeCustomView;
    self.labelText = text;
    self.labelFont = PFONT(@"Avenir-Light",14);
    self.detailsLabelFont = PFONT(@"Avenir-Light",12);
    self.color = PPHUDViewColor;
    self.detailsLabelText = detail;
    [self hide:YES afterDelay:time];
}

-  (void)setImage:(NSString *)imageName
             text:(NSString *)text
{
    [self setImage:imageName text:text delay:[self delayTime:text]];
}

-  (void)showSuccessedLabelText:(NSString *)text
{
    [self setImage:@"hub_success" text:text];
}

-  (void)showFailurLabelText:(NSString *)text
{
    [self setImage:@"hub_error" text:text];
}

-  (void)showFailurLabelText:(NSString *)text dismiss:(NSTimeInterval)delay
{
   [self setImage:@"hub_error" text:text delay:delay];
}

-  (void)showFailurLabelText:(NSString *)text
                      detail:(NSString *)detail
{
    [self setImage:@"hub_error" text:text detail:detail delay:[self delayTime:detail]];
}

- (void)showTips:(NSString*)tips image:(NSString*)imageName
{
    [self setImage:imageName text:tips];
}

+ (void)showTitle:(NSString *)title
           detail:(NSString *)detail
{
    PPHUDView *hub = [PPHUDView showTo:[[UIApplication sharedApplication].windows lastObject]];
    hub.mode = MBProgressHUDModeText;
    hub.labelText = title;
    hub.color = PPHUDViewColor;
    hub.detailsLabelText = detail;
    hub.labelFont = PFONT(@"Avenir-Light",14);
    hub.detailsLabelFont = PFONT(@"Avenir-Light",12);
    hub.removeFromSuperViewOnHide = YES;
    [hub hide:YES afterDelay:[hub delayTime:detail]];
}

+ (void)showErrorDetailMessage:(NSString *)message
{
    [self showTitle:@"Oops!" detail:message];
}

+ (void)showTips:(NSString*)message image:(NSString*)imageName showToView:(UIView*)view
{
    UIImage* image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    PPHUDView *hub = [PPHUDView showTo:view];
    hub.mode = MBProgressHUDModeCustomView;
    hub.customView = imageView;
    hub.color = PPHUDViewColor;
    hub.detailsLabelText = message;
    hub.detailsLabelFont = PFONT(@"Avenir-Roman",13);
    hub.detailsLabelColor = [UIColor whiteColor];
    hub.removeFromSuperViewOnHide = YES;    
    [hub hide:YES afterDelay:[hub delayTime:message]];
}

+ (void)showTips:(NSString*)message imageName:(NSString*)imageName
{
    UIImage* image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    PPHUDView *hub = [PPHUDView showToWindow];
    hub.mode = MBProgressHUDModeCustomView;
    hub.customView = imageView;
    hub.color = PPHUDViewColor;
    hub.detailsLabelText = message;
    hub.detailsLabelFont = PFONT(@"Avenir-Roman",13);
    hub.detailsLabelColor = [UIColor whiteColor];
    hub.removeFromSuperViewOnHide = YES;
    [hub hide:YES afterDelay:[hub delayTime:message]];
}

- (void)showTips:(NSString*)message imageName:(NSString*)imageName
{
    [PPHUDView showTips:message imageName:imageName];
}

+ (void)showNormalDetailMessage:(NSString *)message
{
    [self showTitle:nil detail:message];
}

+ (PPHUDView *)showToWindow
{
    PPHUDView *hub = [PPHUDView showTo:[UIApplication sharedApplication].keyWindow];
    return hub;
}

+ (PPHUDView *)showTo:(UIView *)view
{
    PPHUDView *hub = [PPHUDView showHUDAddedTo:view animated:YES];
    hub.color = PPHUDViewColor;
    return hub;
}

+ (PPHUDView *)showLoadingTo:(UIView *)view text:(NSString *)text
{
   return [self showTo:view text:text];
}

+ (PPHUDView *)showTo:(UIView *)view text:(NSString *)text
{
    PPHUDView *hub = [PPHUDView showHUDAddedTo:view animated:YES];
    hub.labelText = text;
    hub.labelFont = PFONT(@"Avenir-Light",14);
    hub.color = PPHUDViewColor;
    return hub;
}

- (void)hide
{
    [self hide:YES];
}

- (void)setErrorTitle:(NSString *)title
               detail:(NSString *)detail
{
    [self setTitle:title detail:detail];
    UIImage* image = [UIImage imageNamed:@"hub_error"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.labelFont = PFONT(@"Avenir-Light",14);
    self.detailsLabelFont = PFONT(@"Avenir-Light",12);
    self.customView = imageView;
    self.color = PPHUDViewColor;
    self.mode = MBProgressHUDModeCustomView;
}

- (void)setTitle:(NSString *)title
          detail:(NSString *)detail
{
    self.labelText = title;
    self.detailsLabelText = detail;
    self.removeFromSuperViewOnHide = YES;
    self.color = PPHUDViewColor;
    self.labelFont = PFONT(@"Avenir-Light",14);
    self.detailsLabelFont = PFONT(@"Avenir-Light",12);
}

- (void)showError:(NSError *)error
{
    NSString *txt = error?error.localizedDescription:@"";
    [self showError:error afterDelay:[self delayTime:txt]];
}

- (void)showError:(NSError *)error dismiss:(NSTimeInterval)delay
{
    [self showError:error afterDelay:delay];
}

- (void)showError:(NSError *)error afterDelay:(NSTimeInterval)delay
{
    [self setErrorTitle:[NSString stringWithFormat:@"%@ (%ld)",error.descriptionSummaryDesc,(long)error.code] detail:error.localizedDescription];
    self.color = PPHUDViewColor;
    self.labelFont = PFONT(@"Avenir-Light",14);
    self.detailsLabelFont = PFONT(@"Avenir-Light",12);
    [self hide:YES afterDelay:delay];
}

- (void)showFailureStatus:(NSString *)desc code:(NSString*)code
{
    NSString *txt = desc?desc:@"";
    if (txt.length <=0) {
        [self hide:NO];
        return;
    }
    [self showFailureStatus:txt code:code delay:[self delayTime:txt]];
}

- (void)showFailureStatus:(NSString *)desc
                     code:(NSString*)code
                    delay:(CGFloat)time
{
    if (!desc || desc.length<=0) {
        [self hide:NO];
        return;
    }
    [self setImage:@"hub_error" text:[NSString stringWithFormat:@"%@ (%@)",@"Oops!",code] detail:desc delay:time];
}


+ (PPHUDView *)hubView:(UIView *)inView
           titleString:(NSString *)title
          detailString:(NSString *)detail
{
    return [self hubView:inView titleString:title detailString:detail];
}

+ (PPHUDView *)hubView:(UIView *)inView
           titleString:(NSString *)title
          detailString:(NSString *)detail
             delayTime:(CGFloat)delayTime
{
    PPHUDView *hub = [PPHUDView showHUDAddedTo:inView animated:YES];
    hub.detailsLabelText = detail;
    hub.labelFont = PFONT(@"Avenir-Light",14);
    hub.detailsLabelFont = PFONT(@"Avenir-Light",12);
    hub.removeFromSuperViewOnHide = YES;
    hub.color = PPHUDViewColor;
    [hub setImage:@"hub_error" text:title delay:delayTime];
    return hub;
}

//标题，文字和提示时间
+ (void)hubText:(NSString *)text
      withTitle:(NSString *)title
       withTime:(int)time
       withView:(UIView *)view{
    PPHUDView *hub = [PPHUDView showHUDAddedTo:view animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.labelText = text;
    hub.detailsLabelText = title;
    hub.labelFont = PFONT(@"Avenir-Light",14);
    hub.detailsLabelFont = PFONT(@"Avenir-Light",12);
    hub.removeFromSuperViewOnHide = YES;
    hub.color = PPHUDViewColor;
    [hub hide:YES afterDelay:time];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end


@implementation NSError(PP_Error)

- (NSString *)descriptionSummaryDesc
{
    if ([self.userInfo isKindOfClass:[NSDictionary class]]) {
        return self.userInfo[@"NSLocalizedErrorSummaryKey"]?self.userInfo[@"NSLocalizedErrorSummaryKey"]:@"";
    }
    return @"";
}

@end
































