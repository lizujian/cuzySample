//
//  AuthorizeManager.h
//  shopping
//
//  Created by LiZujian on 13-8-1.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CuzyAdSDK.h"

typedef enum AuthorizeState {
    CuzyAuthorizeStateNone = 0,
    CuzyAuthorizeStateAction = 1,//授权中
    CuzyAuthorizeStateFail = 2,//授权失败
    CuzyAuthorizeStateSucc = 3,//授权成功。
    }CuzyAuthorizeState;
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
