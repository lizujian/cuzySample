//
//  WebViewController.h
//  shopping
//
//  Created by LiZujian on 13-8-1.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "TapBaseViewController.h"

@interface WebViewController : TapBaseViewController<UIWebViewDelegate>

-(void)setUrlString:(NSString *)inputUrlString;
@end
