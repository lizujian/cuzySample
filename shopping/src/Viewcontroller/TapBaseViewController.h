//
//  TapBaseViewController.h
//  TapTapMonster
//
//  Created by LiZujian on 13-4-30.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapBaseViewController : UIViewController

@property(nonatomic, retain) NSString *backTitle;

//-(void)setView:(UIView *)aView OutOrIn:(BOOL)isIn;
//-(void)setSubViewUserInterfaceEable:(BOOL)isEnable;

-(void)back:(id)sender;
-(void)showLoadingView;
-(void)hideLoadingView;
@end
