//
//  DataManager.h
//  wine
//
//  Created by LiZujian on 13-6-23.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataManagerDelegate <NSObject>

-(void) updateViewForSuccess:(id)dataModel;
-(void) updateViewForError:(NSError *)errorInfo;
@end

@interface DataManager : NSObject
{
    id<DataManagerDelegate> _delegate;
}

@property (nonatomic, assign) id<DataManagerDelegate> delegate;
@property (nonatomic, assign) BOOL isIphone5;
AS_SINGLETON(DataManager)

-(void)requstTBKItemsWithKeyWord:(NSString*)searchKey WithThemeID:(NSString *)themeId WithPageIndex:(NSInteger) pageIndex withDelegate:(id<DataManagerDelegate>)aDelegate;

@end
