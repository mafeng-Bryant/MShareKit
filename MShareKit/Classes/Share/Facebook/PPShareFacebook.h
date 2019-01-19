//
//  PPShareFaceBook.h
//  PatPat
//
//  Created by patpat on 15/4/18.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PPShareFacebookResultOK,
    PPShareFacebookResultCancel,
    PPShareFacebookResultError,
    PPShareFacebookResultOther,
    PPShareFacebookResultNotInstall
}PPShareFacebookResult;

typedef void (^PPShareFacebookBlock)(PPShareFacebookResult resultType);

@interface PPShareFacebook : UIViewController<FBSDKSharingDelegate>
{
    FBSDKShareDialog *_shareDialog;
    FBSDKMessageDialog *_messageDialog;
}
@property(nonatomic,copy)PPShareFacebookBlock shareBlock;

+ (PPShareFacebook *)sharedInstance;

/**
 *  分享内容到facebook
 *
 *  @param title       标题
 *  @param description 描述
 *  @param link        链接
 *  @param pictureURL  图片地址
 *  @param resultBack  回调
 */
- (void)shareToFacebook:(NSString *)title
            description:(NSString *)description
                   link:(NSString *)link
             pictureURL:(NSString *)pictureURL
             controller:(UIViewController *)controller
             resultBack:(PPShareFacebookBlock)resultBack;


/**
 *  分享内容到facebook messenger
 *
 *  @param title       标题
 *  @param description 描述
 *  @param link        链接
 *  @param pictureURL  图片地址
 *  @param resultBack  回调block
 */
//只有iphone可以使用facebookMessenger，Ipad不支持
- (void)shareToFacebookMessenger:(NSString *)title
                     description:(NSString *)description
                            link:(NSString *)link
                      pictureURL:(NSString *)pictureURL
                      resultBack:(PPShareFacebookBlock)resultBack;

    
/**
 *  分享内容到facebook
 *
 *  @param title       标题
 *  @param description 描述
 *  @param link        链接
 *  @param pictureURL  图片地址
 *  @param controller  当前控制器
 *  @param resultBack  回调block
 */
- (void)shareToFacebookImageLink:(NSString *)title
                     description:(NSString *)description
                            link:(NSString *)link
                      pictureURL:(NSString *)pictureURL
                      controller:(UIViewController *)controller
                      resultBack:(PPShareFacebookBlock)resultBack;
    
/**
 *  以app内弹出分享表的形式分享内容到facebook
 *  @param pictureURL  图片地址
 *  @param controller  当前控制器
 *  @param resultBack  回调block
 */
- (void)sheetStyleShareToFacebookWithLink:(NSString *)urlString
                               controller:(UIViewController *)controller
                               resultBack:(PPShareFacebookBlock)resultBack;





/**
 以app内弹出分享表的形式分享内容到facebook

 @param quote 分享文案
 @param link 分析链接
 @param controller 弹出源控制器
 @param resultBack 结果回调
 */
- (void)sheetStyleShareToFacebookQuote:(NSString *)quote
                                  link:(NSString *)link
                            controller:(UIViewController *)controller
                            resultBack:(PPShareFacebookBlock)resultBack;






        
@end
