//
//  AuthorizeManager.h
//  shopping
//
//  Created by LiZujian on 13-8-1.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CuzyAdSDK.h"
typedef void (^AuthorizeBlock)(void);

@protocol AuthorizeManagerDelegate <NSObject>

@optional
-(void)AuthorizeDelegateSuccess;
-(void)AuthorizeDelegateFail;
@end
@interface AuthorizeManager : NSObject<CuzyAdSDKDelegate>
AS_SINGLETON(AuthorizeManager)
@property (nonatomic, readonly) BOOL isAuthorized;
-(void)requestForAuthorizeWithDelegate:(id<AuthorizeManagerDelegate>)aDelegate;
-(void)authorize;
-(void)requestForAuthorizeSucc:(AuthorizeBlock)succBlock Fail:(AuthorizeBlock)failBlock;
@end
