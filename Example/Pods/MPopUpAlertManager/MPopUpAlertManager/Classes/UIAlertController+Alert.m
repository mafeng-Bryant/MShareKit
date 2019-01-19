//
//  UIAlertController+Alert.m
//  MPopUpAlertManager_Example
//
//  Created by patpat on 2018/12/29.
//  Copyright © 2018 1499603656@qq.com. All rights reserved.
//

#import "UIAlertController+Alert.h"

@implementation UIAlertController (Alert)

+(void)showAlertCntroller:(UIViewController *)viewController
     alertControllerStyle:(UIAlertControllerStyle)alertControllerStyle
                    title:(NSString *)title message:(NSString *)message
                    block:(callBackBlock)block cancelButtonTitle:(NSString *)cancelBtnTitle
            okButtonTitle:(NSString *)okButtonTitle
        otherButtonTitles:(NSString *)otherBtnTitles, ...
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:alertControllerStyle];
    //添加按钮
    if (cancelBtnTitle.length) {
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            block(0);
        }];
        [alertController addAction:cancelAction];
    }
    if (okButtonTitle.length) {
        UIAlertAction * destructiveAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(1);
        }];
        [alertController addAction:destructiveAction];
    }
    if (otherBtnTitles.length) {
        UIAlertAction *otherActions = [UIAlertAction actionWithTitle:otherBtnTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            (!cancelBtnTitle.length && !okButtonTitle.length) ? block(0) : (((cancelBtnTitle.length && !okButtonTitle.length) || (!cancelBtnTitle.length && okButtonTitle.length)) ? block(1) : block(2));
        }];
        [alertController addAction:otherActions];
        /**
         * va_list : (1)首先在函数里定义一具VA_LIST型的变量,这个变量是指向参数的指针;
         * (2)然后用VA_START宏初始化变量刚定义的VA_LIST变量;
         * (3)然后用VA_ARG返回可变的参数,VA_ARG的第二个参数是你要返回的参数的类型(如果函数有多个可变参数的,依次调用VA_ARG获取各个参数);
         * (4)最后用VA_END宏结束可变参数的获取。
         * va_start :获取可变参数列表的第一个参数的地址;
         * va_arg :获取当前参数,返回指定类型并将指针指向下一参数
         * va_end :清空va_list可变参数列表:
         *
         *
         */
        va_list args;
        va_start(args, otherBtnTitles);
        if (otherBtnTitles.length) {
            NSString * otherString;
            int index = 2;
            (!cancelBtnTitle.length && !okButtonTitle.length) ? (index = 0) : ((cancelBtnTitle.length && !okButtonTitle.length) || (!cancelBtnTitle.length && okButtonTitle.length) ? (index = 1) : (index = 2));
            while ((otherString = va_arg(args, NSString*))) {
                index ++ ;
                UIAlertAction * otherActions = [UIAlertAction actionWithTitle:otherString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    block(index);
                }];
                [alertController addAction:otherActions];
            }
        }
        va_end(args);
    }
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+(void)showAlertCntroller:(UIViewController *)viewController
     alertControllerStyle:(UIAlertControllerStyle)alertControllerStyle
                    title:(NSString *)title
                  message:(NSString *)message
        cancelButtonTitle:(NSString *)cancelBtnTitle
                    block:(callBackBlock)block
        otherButtonTitles:(NSArray *)otherBtnTitles
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:alertControllerStyle];
    if (cancelBtnTitle.length) {
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            block(-1);
        }];
        [alertController addAction:cancelAction];
    }
    if ([otherBtnTitles isKindOfClass:[NSArray class]] && otherBtnTitles.count>0) {
        for (NSString* value in otherBtnTitles) {
            NSInteger index = [otherBtnTitles indexOfObject:value];
            UIAlertAction * otherActions = [UIAlertAction actionWithTitle:value style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                block(index);
            }];
            [alertController addAction:otherActions];
        }
    }
    [viewController presentViewController:alertController animated:YES completion:nil];
}



@end
