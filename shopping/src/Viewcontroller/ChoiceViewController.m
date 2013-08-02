//
//  ChoiceViewController.m
//  shopping
//
//  Created by LiZujian on 13-8-1.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "ChoiceViewController.h"
#import "UITableViewCell+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "IIViewDeckController.h"
#import "MainViewController.h"
#import "UIFont+FlatUI.h"

@interface ChoiceViewController ()

@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation ChoiceViewController
@synthesize iconArr = _iconArr;
@synthesize selectedIndex = _selectedIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
         _iconArr = [[NSArray alloc]initWithObjects:@"all",@"clothing",@"shoes",@"bag",@"beauties",@"home",@"accessories",@"food",@"other", nil];
    }
    return self;
}

-(void)dealloc
{
    [_iconArr release];
    _iconArr = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.iconArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (nil == cell) {
//        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell = [[UITableViewCell configureFlatCellWithColor:RGB(255, 188, 205) selectedColor:[UIColor colorFromHexCode:@"97DEE7"] style:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
//    if (indexPath.row == _selectedIndex) {
//        [cell setSelected:YES];
//    }
    NSString *iconName = [self.iconArr objectAtIndex:indexPath.row];
    NSString *iconPath = [NSString stringWithFormat:@"icon_%@_bg.png",iconName];
//    NSString *iconHigltPath = [NSString stringWithFormat:@"icon_%@_selected.png",iconName];
    cell.imageView.image = [UIImage imageWithContentsOfFile:BWXBundlePath(iconPath)];
//    cell.imageView.highlightedImage = [UIImage imageWithContentsOfFile:iconHigltPath];
    cell.textLabel.text = Localize(iconName);
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *view = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)]autorelease];
    UIImage *image = [[UIImage imageNamed:@"logout_normal"]stretchableImageWithLeftCapWidth:100 topCapHeight:15];
    view.image = image;
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 320-100, 50)]autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont flatFontOfSize:18.0];
    titleLabel.text = Localize(@"choice");
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [view addSubview:titleLabel];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 0.0;
//    }
    return 50.0;
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
    _selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSString *iconName = Localize([self.iconArr objectAtIndex:indexPath.row]);
    NSDictionary *dic = @{@"selectedIndex": [NSNumber numberWithInteger:_selectedIndex],@"catalog":iconName};

    UINavigationController *nav = (UINavigationController *)self.viewDeckController.centerController;
    [nav popToRootViewControllerAnimated:NO];
    UIViewController *vc = [nav.viewControllers lastObject];
    if (vc && [vc isKindOfClass:[MainViewController class]]) {
        [(MainViewController *)vc postUserInfo:dic];
    }
    [self.viewDeckController closeLeftView];
}

@end
