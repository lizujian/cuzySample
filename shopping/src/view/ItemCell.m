//
//  ItemCell.m
//  shopping
//
//  Created by LiZujian on 13-8-1.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "ItemCell.h"
#import "CuzyAdSDK.h"
#import "ImageCacheManager.h"
#import "UIFont+FlatUI.h"
#import "UIImageView+WebCache.h"
#import "TTTAttributedLabel.h"
#import "UIImage+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UIImage+Resize.h"

@interface ItemCell ()
@property (nonatomic, retain)UIImageView *image;
@property (nonatomic, retain)UILabel *nameLabel;
@property (nonatomic, retain)UILabel *moneyLabel;
@property (nonatomic, retain)UILabel *originalmoneyLabel;
@property (nonatomic, retain)UILabel *discountLabel;
@end
@implementation ItemCell
@synthesize image,nameLabel;
@synthesize moneyLabel,originalmoneyLabel;
@synthesize discountLabel;

-(void)dealloc
{
    self.image = nil;
    self.nameLabel = nil;
    self.moneyLabel = nil;
    self.originalmoneyLabel = nil;
    self.discountLabel = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor redColor];
        UIImageView *cellKuang = [[[UIImageView alloc]initWithFrame:CGRectMake(28, 3, 262, 262)]autorelease];
        cellKuang.image = [[UIImage imageWithContentsOfFile:BWXBundlePath(@"info_bg.png")]stretchableImageWithLeftCapWidth:75 topCapHeight:60];
        [self addSubview:cellKuang];
        self.image = [[[UIImageView alloc]initWithFrame:CGRectZero]autorelease];
        [self addSubview:self.image];
        
        UIImageView *infoKuang = [[[UIImageView alloc]initWithFrame:CGRectMake(20, 260-15, 280, 60)]autorelease];
        infoKuang.image = [[UIImage imageNamed:@"tuan_item_info_bg"]stretchableImageWithLeftCapWidth:70 topCapHeight:30];
        [self addSubview:infoKuang];
        self.nameLabel = [[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
        [self addSubview:self.nameLabel];
        self.moneyLabel = [[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
        self.originalmoneyLabel = [[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
        [self addSubview:self.originalmoneyLabel];
        self.discountLabel =  [[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
        [self addSubview:self.discountLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.image.frame = CGRectMake(50, 25, 220, 220);
    self.nameLabel.frame = CGRectMake(30, 260-15, 260, 54);
    self.nameLabel.font = [UIFont flatFontOfSize:13];
    self.nameLabel.backgroundColor = [UIColor clearColor];
//    self.nameLabel.leading = 1.0;
    self.nameLabel.numberOfLines = 0;
//    self.nameLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bindData:(CuzyTBKItem *)item
{
    [self.image setImageWithURL:[NSURL URLWithString:item.itemImageURLString] placeholderImage:[UIImage imageWithColor:[UIColor colorFromHexCode:@"E7DEE7"] cornerRadius:1.0]];
    self.nameLabel.text = item.itemName;
//    self.originalmoneyLabel.text = item.itemPrice;
//    self.moneyLabel.text = item.promotionPrice;
//    double discount = item.promotionPrice.doubleValue/item.itemPrice.doubleValue;
//    self.discountLabel.text = [NSString stringWithFormat:@"%.1f 折",discount];
}

@end
