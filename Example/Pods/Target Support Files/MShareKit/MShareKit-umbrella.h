#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "PPShareEmailAndSMS.h"
#import "PPShareFacebook.h"
#import "PPShareInstagram.h"
#import "PPSharePinterest.h"
#import "PPShare.h"
#import "PPActivityShareManager.h"
#import "UIViewController+PPShare.h"
#import "PPShareTwitter.h"

FOUNDATION_EXPORT double MShareKitVersionNumber;
FOUNDATION_EXPORT const unsigned char MShareKitVersionString[];

