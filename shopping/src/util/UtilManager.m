//
//  UtilManager.m
//  wine
//
//  Created by LiZujian on 13-6-24.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "UtilManager.h"

@implementation UtilManager
+(int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

+ (NSUInteger)fitString:(NSString *)string intoLabel:(UILabel *)label
{
    UIFont *font           = label.font;
    UILineBreakMode mode   = label.lineBreakMode;
    
    CGFloat labelWidth     = label.frame.size.width;
    CGFloat labelHeight    = label.frame.size.height;
    CGSize  sizeConstraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
    
    if ([string sizeWithFont:font constrainedToSize:sizeConstraint lineBreakMode:mode].height > labelHeight)
    {
        NSString *adjustedString;
        
        for (NSUInteger i = 1; i < [string length]; i++)
        {
            adjustedString = [string substringToIndex:i];
            
            if ([adjustedString sizeWithFont:font constrainedToSize:sizeConstraint lineBreakMode:mode].height > labelHeight)
                return i - 1;
        }
    }
    
    return [string length];
}

+ (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}


+(AppLanguageType)getPreferredLanguageType
{
    NSString *language = [self getPreferredLanguage];
    if ([language isEqualToString:@"zh-Hans"]) {
        return AppLanguageTypeCNS;
    }
    else if ([language isEqualToString:@"zh-Hant"]){
        return AppLanguageTypeCNT;
    }
    return AppLanguageTypeEn;
}

@end
