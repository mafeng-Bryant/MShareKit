//
//  PPSharePinterest.h
//  PatPat
//
//  Created by patpat on 15/4/18.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PPSharePinterestCallBack)(BOOL result);

@interface PPSharePinterest : NSObject

+ (PPSharePinterest *)sharedPPSharePinterest;

/**
 *   share content to pinterest
 *
 *  @param description        描述,pinterest限定了长度为40个字符，超出整个不接受处理
 *  @param imageURL           URL of the image to pin.
 *  @param sourceURL          The source page of the image.
 *  @param suggestedBoardName A suggested name of a board to pin to
 *  @param callback           resultBack
 */
-(void)shareToPinterest:(NSString *)description
           withImageURL:(NSString *)imageURL
          withSourceURL:(NSString *)sourceURL
     suggestedBoardName:(NSString*)suggestedBoardName
             controller:(UIViewController*)controller
             resultBack:(PPSharePinterestCallBack)resultBack;


/**
 *  处理open url
 *
 *  @param url                   地址
 *  @param sourceApplication     内容
 */
- (void)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication;




@end
