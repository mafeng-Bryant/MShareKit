//
//  PPShareTwitter.h
//  PatPat
//
//  Created by patpat on 15/4/18.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPShareTwitter : NSObject

/**
 *  分享内容到twitter
 *
 *  @param controller      当前控制器
 *  @param text            标题
 *  @param URL             URL地址
 *  @param image           图片地址
 *  @param resultBack      回调
 */
+(void)shareToTwitter:(UIViewController *)controller
             withText:(NSString *)text
              withURL:(NSString *)URL
            withImage:(NSString *)image
           resultBack:(void(^)(BOOL result,NSString *des))resultBack;


@end
