//
//  UtilManager.h
//  wine
//
//  Created by LiZujian on 13-6-24.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum LanguageType {
    AppLanguageTypeEn = 0,
    AppLanguageTypeCNS = 1,
    AppLanguageTypeCNT
    }AppLanguageType;

@interface UtilManager : NSObject
+(int)convertToInt:(NSString*)strtemp;
+ (NSUInteger)fitString:(NSString *)string intoLabel:(UILabel *)label;
+ (NSString*)getPreferredLanguage;
+ (AppLanguageType)getPreferredLanguageType;
@end
