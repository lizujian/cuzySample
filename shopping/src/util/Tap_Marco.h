//
//  Tap_Marco.h
//  TapTapMonster
//
//  Created by LiZujian on 13-4-30.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#ifndef TapTapMonster_Tap_Marco_h
#define TapTapMonster_Tap_Marco_h

#define RGB(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1]

#define Localize(X) NSLocalizedString((X), nil)

#define BWXBundlePath(X) [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: (X)]
#define BWXResourcePath(X,Y,Z) [[NSBundle bundleWithPath:BWXBundlePath(Z) ] pathForResource:(X) ofType:(Y)]

//load an image same as imageNamed
#define BWXPNGImage(X,Y) [UIImage imageWithContentsOfFile:BWXResourcePath(([NSString stringWithFormat:@"%@", (X)]), @"jpg",Y)]

//单例的宏

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

//系统版本
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

//高度，宽度
#define UIScreenHeight     [[UIScreen mainScreen] bounds].size.height
#define UIScreenWidth      [[UIScreen mainScreen] bounds].size.width

#pragma mark -

#define BEE_RELEASE(x) ([(x) release])

#undef	SAFE_RELEASE_SUBLAYER
#define SAFE_RELEASE_SUBLAYER( __x ) \
{ \
[__x removeFromSuperlayer]; \
BEE_RELEASE(__x); \
__x = nil; \
}

#undef	SAFE_RELEASE_SUBVIEW
#define SAFE_RELEASE_SUBVIEW( __x ) \
{ \
[__x removeFromSuperview]; \
BEE_RELEASE(__x); \
__x = nil; \
}

#pragma mark -

//字体
#define kfontName   @"Marker Felt"

//Umeng appKey
#define kUmengAppKey    @"51d51b0c56240b03e50a45c0"

#endif
