//
//  UIAlertController+Alert.h
//  MPopUpAlertManager_Example
//
//  Created by patpat on 2018/12/29.
//  Copyright © 2018 1499603656@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^callBackBlock)(NSInteger index);

@interface UIAlertController (Alert)

+(void)showAlertCntroller:(UIViewController *)viewController
     alertControllerStyle:(UIAlertControllerStyle)alertControllerStyle
                    title:(NSString *)title message:(NSString *)message
                    block:(callBackBlock)block cancelButtonTitle:(NSString *)cancelBtnTitle
            okButtonTitle:(NSString *)okButtonTitle
        otherButtonTitles:(NSString *)otherBtnTitles, ...;

+(void)showAlertCntroller:(UIViewController *)viewController
     alertControllerStyle:(UIAlertControllerStyle)alertControllerStyle
                    title:(NSString *)title
                  message:(NSString *)message
        cancelButtonTitle:(NSString *)cancelBtnTitle
                    block:(callBackBlock)block
        otherButtonTitles:(NSArray *)otherBtnTitles;

@end

