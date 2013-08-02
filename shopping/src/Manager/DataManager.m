//
//  DataManager.m
//  wine
//
//  Created by LiZujian on 13-6-23.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "DataManager.h"
//#import "JSONKit.h"
//#import "WineDataBaseModel.h"
//#import "Members.h"
#import "UtilManager.h"
#import "CuzyAdSDK.h"
#import "AuthorizeManager.h"

@interface DataManager ()<CuzyAdSDKDelegate>

@end

@implementation DataManager
@synthesize delegate = _delegate;
@synthesize isIphone5 = _isIphone5;
DEF_SINGLETON(DataManager)

-(void)dealloc
{
    _delegate = nil;
    [super dealloc];
}

-(id)init
{
    self = [super init];
    if (self) {
        if(UIScreenHeight > 480)
            _isIphone5 = YES;
        else
            _isIphone5 = NO;
    }
    return self;
}

-(void)requstTBKItemsWithKeyWord:(NSString *)searchKey WithThemeID:(NSString *)themeId WithPageIndex:(NSInteger)pageIndex withDelegate:(id<DataManagerDelegate>)aDelegate
{
    _delegate = aDelegate;
    if (![AuthorizeManager sharedInstance].isAuthorized) {
        [[AuthorizeManager sharedInstance]requestForAuthorizeSucc:^{
            [self startThreadWork_fetchTBKItems:searchKey WithThemeID:themeId WithPageIndex:pageIndex];
        }
        Fail:^{
            [self dataIsReadyWithArr:nil];
        }];
        return;
    }
    [self startThreadWork_fetchTBKItems:searchKey WithThemeID:themeId WithPageIndex:pageIndex];
}

-(void)dataIsReadyWithArr:(NSMutableArray *)dataArr
{
    if (dataArr && dataArr.count > 0)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(updateViewForSuccess:)])
        {
            [_delegate updateViewForSuccess:dataArr];
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(updateViewForError:)])
        {
            [_delegate updateViewForError:nil];
        }
    }
    
}

-(void)startThreadWork_fetchTBKItems:(NSString*)searchKey WithThemeID:(NSString *)themeId WithPageIndex:(NSInteger) pageIndex
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("fetch TBK Items queue", NULL);
    dispatch_async(downloadQueue, ^{
//        NSArray* ThemeIdArray =[[[NSArray alloc] initWithObjects:@"12",@"14",@"25",@"6", nil] autorelease ];
//        
//        int random = rand()%4;
//        
//        NSString* themeString = [ThemeIdArray objectAtIndex:random];
        NSMutableArray* returnArray =
        (NSMutableArray*)[[CuzyAdSDK sharedAdSDK] fetchRawItemArraysWithThemeID:themeId orSearchKeywords:searchKey withPageIndex:pageIndex];

        
        dispatch_async(dispatch_get_main_queue(), ^{
            //update the UI in main queue;
            [self dataIsReadyWithArr:returnArray];
        });
    });
    dispatch_release(downloadQueue); //won’t actually go away until queue is empty
    
}

-(void)AuthorizeDelegateSuccess
{
    
}

-(void)AuthorizeDelegateFail
{
    
}


@end
