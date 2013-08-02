//
//  AuthorizeManager.m
//  shopping
//
//  Created by LiZujian on 13-8-1.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "AuthorizeManager.h"
@interface AuthorizeManager ()
{
    AuthorizeBlock successBlock;
    AuthorizeBlock faildBlock;
}
@property (nonatomic, assign) id<AuthorizeManagerDelegate> delegate;
@end
@implementation AuthorizeManager
DEF_SINGLETON(AuthorizeManager)
@synthesize isAuthorized = _isAuthorized;
@synthesize delegate = _delegate;

-(void)dealloc
{
    [self releaseBlocksOnMainThread];
    [super dealloc];
}
-(id)init
{
    self = [super init];
    if (self) {
        _isAuthorized = NO;
    }
    return self;
}
-(void)authorize
{
    [[CuzyAdSDK sharedAdSDK] registerAppWithAppKey:@"200045" 	andAppSecret:@"07b1c45b6f236ab24805dc4e60ef8b16"];
    [[CuzyAdSDK sharedAdSDK] setRawItemPicSize:@"220x220"];
    [[CuzyAdSDK sharedAdSDK] setDelegate:self];
}

-(void)registerAppFailed
{
    NSLog(@"fail");
    if (faildBlock != nil) {
        faildBlock();
    }
    if (_delegate && [_delegate respondsToSelector:@selector(AuthorizeDelegateFail)]) {
        [_delegate AuthorizeDelegateFail];
    }
}

-(void)registerAppSucceed
{
    NSLog(@"succ");
    _isAuthorized = YES;
    if (successBlock != nil) {
        successBlock();
    }
    if (_delegate && [_delegate respondsToSelector:@selector(AuthorizeDelegateSuccess)]) {
        [_delegate AuthorizeDelegateSuccess];
    }
}

-(void)requestForAuthorizeWithDelegate:(id<AuthorizeManagerDelegate>)aDelegate
{
    _delegate = aDelegate;
    [self authorize];
}

-(void)requestForAuthorizeSucc:(AuthorizeBlock)succBlock Fail:(AuthorizeBlock)failBlock
{
    [successBlock release];
    successBlock = [succBlock copy];
    
    [faildBlock release];
    faildBlock = [failBlock copy];
    [self authorize];
}

- (void)releaseBlocksOnMainThread
{
	NSMutableArray *blocks = [NSMutableArray array];
	if (successBlock) {
		[blocks addObject:successBlock];
		[successBlock release];
		successBlock = nil;
	}
	if (faildBlock) {
		[blocks addObject:faildBlock];
		[faildBlock release];
		faildBlock = nil;
	}
	[[self class] performSelectorOnMainThread:@selector(releaseBlocks:) withObject:blocks waitUntilDone:[NSThread isMainThread]];
}

// Always called on main thread
+ (void)releaseBlocks:(NSArray *)blocks
{
	// Blocks will be released when this method exits
}
@end
