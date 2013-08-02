

#import <Foundation/Foundation.h>
@interface ImageCacheManager : NSObject
{
}

+(void) setImageView: (UIImageView*) imageView withUrlString: (NSString *) urlString withPlaceHolder:(NSString*)placeHoderString;
+(void) setImageView: (UIImageView*)imageView withUrlString: (NSString *) urlString;
+(void) initCacheDirectory;
+(void) clearCache;
@end
