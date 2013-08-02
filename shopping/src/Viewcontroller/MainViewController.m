//
//  MainViewController.m
//  shopping
//
//  Created by LiZujian on 13-8-1.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+FlatUI.h"
//#import "IIViewDeckController.h"
#import "PullTableView.h"
#import "DataManager.h"
#import "CuzyAdSDK.h"
#import "ItemCell.h"
#import "WebViewController.h"
#import "ChoiceViewController.h"

@interface MainViewController ()<PullTableViewDelegate,UITableViewDataSource,UITableViewDelegate,DataManagerDelegate>
@property (nonatomic, retain)PullTableView *tableView;
@property (nonatomic, retain)NSMutableArray *requestData;
@property (nonatomic, assign)NSInteger selectedChoice;
@property (nonatomic, assign)NSInteger pageIndex;
@end

@implementation MainViewController
@synthesize tableView = _tableView;
@synthesize requestData = _requestData;
@synthesize selectedChoice = _selectedChoice;
@synthesize pageIndex = _pageIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView.pullDelegate = nil;
    self.tableView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorFromHexCode:@"E7DEE7"];
//    self.navigationItem.titleView = [self createTitleView];
    ChoiceViewController *rightVC = (ChoiceViewController *)self.viewDeckController.leftController;
    NSString *titleStr = Localize([rightVC.iconArr objectAtIndex:_selectedChoice]);
    self.title = titleStr;
    CGRect frame = self.view.frame;
    frame.origin = CGPointZero;
//    UIImage *backGroundImage = [[UIImage imageWithContentsOfFile:BWXBundlePath(@"my_frame_bg.png")]stretchableImageWithLeftCapWidth:80 topCapHeight:90];
//    UIImageView *backGroundImageView = [[[UIImageView alloc]initWithImage:backGroundImage]autorelease];
//    backGroundImageView.frame = frame;
//    backGroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:backGroundImageView];
    
    UIImageView *backGroundView = [[[UIImageView alloc]initWithFrame:frame]autorelease];
    backGroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    if ([DataManager sharedInstance].isIphone5) {
        backGroundView.image = [UIImage imageWithContentsOfFile:BWXBundlePath(@"index_bg_5.png")];
    }
    else {
        backGroundView.image = [UIImage imageWithContentsOfFile:BWXBundlePath(@"index_bg.png")];
    }
    [self.view addSubview:backGroundView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageWithContentsOfFile:BWXBundlePath(@"default_dark_icon.png")] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 39, 34);
    [leftButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"shoppingTaobao"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 51, 31);
    [rightButton addTarget:self action:@selector(presentLoginVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    _tableView = [[PullTableView alloc]initWithFrame:frame style:UITableViewStylePlain includeRefreshView:YES includeLoadMoreView:YES];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    
    [self requestDataWithKeyWord:nil WithThemeID:@"1" WithPageIndex:self.pageIndex];
    [self showLoadingView];
}

-(void)requestDataWithKeyWord:(NSString *)keyWord WithThemeID:(NSString *)themeID WithPageIndex:(NSInteger) pageIndex
{
    
//    if (pageIndex == 0) {
//        self.requestData = nil;
//        [_tableView reloadData];
//    }
    [[DataManager sharedInstance]requstTBKItemsWithKeyWord:keyWord WithThemeID:themeID WithPageIndex:pageIndex withDelegate:self];
}


-(void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideLoadingView
{
    [super hideLoadingView];
    _tableView.pullTableIsLoadingMore = NO;
    _tableView.pullTableIsRefreshing = NO;
}

-(void)showLoadingView
{
    [super showLoadingView];
    [_tableView reloadData];
}

-(void)updateViewForSuccess:(id)dataModel
{
    [self hideLoadingView];
    if ([dataModel isKindOfClass:[NSArray class]] && [[(NSArray *)dataModel lastObject] isKindOfClass:[CuzyTBKItem class]])
    {
        if (self.requestData.count > 0) {
            [self.requestData addObjectsFromArray:dataModel];
        }
        else {
            self.requestData = [NSMutableArray arrayWithArray:dataModel];
        }
    }
    [_tableView reloadData];
}

-(void)updateViewForError:(NSError *)errorInfo
{
    [self hideLoadingView];
    NSLog(@"错误");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.requestData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (nil == cell) {
        cell = [[[ItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
//        cell = [[UITableViewCell configureFlatCellWithColor:RGB(255, 188, 205) selectedColor:[UIColor colorFromHexCode:@"97DEE7"] style:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
//    NSString *iconName = [self.iconArr objectAtIndex:indexPath.row];
//    NSString *iconPath = [NSString stringWithFormat:@"icon_%@_bg.png",iconName];
//    //    NSString *iconHigltPath = [NSString stringWithFormat:@"icon_%@_selected.png",iconName];
//    cell.imageView.image = [UIImage imageWithContentsOfFile:BWXBundlePath(iconPath)];
//    //    cell.imageView.highlightedImage = [UIImage imageWithContentsOfFile:iconHigltPath];
//    cell.textLabel.text = Localize(iconName);
    CuzyTBKItem *item = [self.requestData objectAtIndex:indexPath.row];
    [cell bindData:item];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320.0f;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    ChoiceViewController *rightVC = (ChoiceViewController *)self.viewDeckController.leftController;
    NSString *key = Localize([rightVC.iconArr objectAtIndex:_selectedChoice]);
    if ([key isEqualToString:Localize(@"all")]) {
        key = nil;
    }
    self.requestData = nil;
    _pageIndex = 0;
    [self requestDataWithKeyWord:key WithThemeID:@"1" WithPageIndex:self.pageIndex];
}

-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    ChoiceViewController *rightVC = (ChoiceViewController *)self.viewDeckController.leftController;
    NSString *key = Localize([rightVC.iconArr objectAtIndex:_selectedChoice]);
    if ([key isEqualToString:Localize(@"all")]) {
        key = nil;
    }

    [self requestDataWithKeyWord:key WithThemeID:@"1" WithPageIndex:++self.pageIndex];

}

-(void)postUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    NSInteger selected = [[userInfo objectForKey:@"selectedIndex"]integerValue];
    if (self.selectedChoice != selected) {
        self.requestData = nil;
        self.pageIndex = 0;
    }
    self.selectedChoice = selected;
    NSString *key = [userInfo objectForKey:@"catalog"];
    self.title = key;
    if ([key isEqualToString:Localize(@"all")]) {
        key = nil;
    }
    [self requestDataWithKeyWord:key WithThemeID:@"1" WithPageIndex:self.pageIndex];

    [self showLoadingView];
    
}

//-(void)viewDeckController:(IIViewDeckController *)viewDeckController willCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
//{
//    NSLog(@"开始出现");
//    
//}

-(void)presentLoginVC
{
    WebViewController *loginVC = [[[WebViewController alloc]init]autorelease];
    UINavigationController *nav = [[[UINavigationController alloc]initWithRootViewController:loginVC]autorelease];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg"]   forBarMetrics:UIBarMetricsDefault & UIBarMetricsLandscapePhone];
    [self.navigationController presentModalViewController:nav animated:YES];
    [loginVC setUrlString:@"https://login.taobao.com/"];
}


@end
