//
//  ItemCell.h
//  shopping
//
//  Created by LiZujian on 13-8-1.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CuzyTBKItem;
@interface ItemCell : UITableViewCell

-(void)bindData:(CuzyTBKItem *)item;
@end
