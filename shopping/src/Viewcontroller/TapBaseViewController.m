//
//  TapBaseViewController.m
//  TapTapMonster
//
//  Created by LiZujian on 13-4-30.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "TapBaseViewController.h"
//#import "MobClick.h"
#import "UIFont+FlatUI.h"
#import "UIColor+FlatUI.h"
//#import "DetailViewController.h"
#import "UtilManager.h"
#import "MBProgressHUD.h"

@interface TapBaseViewController ()
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) MBProgressHUD *hud;
@end

@implementation TapBaseViewController
@synthesize backTitle;
@synthesize loadingView = _loadingView;
@synthesize hud = _hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if(self.navigationController.childViewControllers.count > 1)
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:[self backItemViewWithTitle:self.backTitle]]autorelease];
    
}

-(UIView *)backItemViewWithTitle:(NSString *)title
{
    if (nil == title || [UtilManager getPreferredLanguageType] == AppLanguageTypeEn) {
        title = Localize(@"back");
    }
//    NSLog(@"back title:%@",title);
    NSInteger len = [UtilManager convertToInt:title];
    CGFloat lenth = 100-23-len*18;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitleColor:[UIColor colorFromHexCode:@"1284FF"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorFromHexCode:@"1284FF"] forState:UIControlStateHighlighted];
    backButton.titleLabel.font = [UIFont boldFlatFontOfSize:17];
    backButton.frame = CGRectMake(0, 0, 100, 21);
    [backButton setImage:[UIImage imageNamed:@"Back-icon"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"Back-icon_down"] forState:UIControlStateHighlighted];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 2, lenth)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 100-18)];
//    [backButton]
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitle:title forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if ([self isKindOfClass:[DetailViewController class]]) {
//        [MobClick beginLogPageView:@"详情"];
//    }
//    else
//        [MobClick beginLogPageView:self.title];
#ifdef simulate_memory_warn
    SEL memoryWarningSel = @selector(_performMemoryWarning);
    if ([[UIApplication sharedApplication] respondsToSelector:memoryWarningSel]) {
        [[UIApplication sharedApplication] performSelector:memoryWarningSel];
    }else {
        NSLog(@"%@",@"Whoops UIApplication no loger responds to -_performMemoryWarning");
    }
#endif
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    if ([self isKindOfClass:[DetailViewController class]]) {
//        [MobClick beginLogPageView:@"详情"];
//    }
//    else
//        [MobClick endLogPageView:self.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    float sysVersion =[[[UIDevice currentDevice] systemVersion] floatValue];
   if (sysVersion < 6.0f) return;
    // 是否是正在使用的视图
    if ([self.view window] == nil){
        // Add code to preserve data stored in the views that might be
        // needed later.
        [self viewDidUnload];
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

-(void)viewDidUnload
{
//    NSLog(@"%@ 开始释放",NSStringFromClass([self class]));
    [self hideLoadingView];
    [super viewDidUnload];
}

-(void)dealloc
{
//    NSLog(@"%@ 完全释放",NSStringFromClass([self class]));
    [self hideLoadingView];
    self.backTitle = nil;
    [super dealloc];
}

-(void)back:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)showLoadingView
{
    if (nil == _loadingView) {
        CGRect rect = self.view.frame;
        rect.origin = CGPointZero;
        _loadingView = [[UIView alloc]initWithFrame:rect];
        _loadingView.backgroundColor = [UIColor colorWithRed:231/255.0f green:231/255.0f blue:230/255.0f alpha:1];
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _hud = [[[MBProgressHUD alloc] initWithView:_loadingView] autorelease];
        _hud.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_loadingView addSubview:_hud];
        [_hud show:YES];
        [self.view addSubview:_loadingView];
    }
    [self.view bringSubviewToFront:_loadingView];
}

-(void)hideLoadingView
{
    if (_loadingView) {
        [_hud hide:NO];
        [_loadingView removeFromSuperview];
        [_hud release];
        _hud = nil;
        //        [_loadingView release];
        _loadingView = nil;
    }
}


#pragma mark - 导航栏

-(UILabel *) createTitleView {
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor colorFromHexCode:@"1D2111"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [titleLabel sizeToFit];
    return titleLabel;
}

-(void)setTitle:(NSString *)title
{
    if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
        UILabel *titleLabel = (UILabel *) self.navigationItem.titleView;
        titleLabel.text = title;
        [titleLabel sizeToFit];
    }
    [super setTitle:title];
}

@end
