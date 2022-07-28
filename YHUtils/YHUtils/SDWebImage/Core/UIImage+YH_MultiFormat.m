/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImage+YH_MultiFormat.h"

#import "objc/runtime.h"
#import "YH_SDWebImageCodersManager.h"

@implementation UIImage (YH_MultiFormat)

#if SD_MAC
- (NSUInteger)yh_imageLoopCount {
    NSUInteger imageLoopCount = 0;
    for (NSImageRep *rep in self.representations) {
        if ([rep isKindOfClass:[NSBitmapImageRep class]]) {
            NSBitmapImageRep *bitmapRep = (NSBitmapImageRep *)rep;
            imageLoopCount = [[bitmapRep valueForProperty:NSImageLoopCount] unsignedIntegerValue];
            break;
        }
    }
    return imageLoopCount;
}

- (void)setYh_imageLoopCount:(NSUInteger)yh_imageLoopCount {
    for (NSImageRep *rep in self.representations) {
        if ([rep isKindOfClass:[NSBitmapImageRep class]]) {
            NSBitmapImageRep *bitmapRep = (NSBitmapImageRep *)rep;
            [bitmapRep setProperty:NSImageLoopCount withValue:@(yh_imageLoopCount)];
            break;
        }
    }
}

#else

- (NSUInteger)yh_imageLoopCount {
    NSUInteger imageLoopCount = 0;
    NSNumber *value = objc_getAssociatedObject(self, @selector(yh_imageLoopCount));
    if ([value isKindOfClass:[NSNumber class]]) {
        imageLoopCount = value.unsignedIntegerValue;
    }
    return imageLoopCount;
}

- (void)setYh_imageLoopCount:(NSUInteger)yh_imageLoopCount {
    NSNumber *value = @(yh_imageLoopCount);
    objc_setAssociatedObject(self, @selector(yh_imageLoopCount), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#endif

+ (nullable UIImage *)yh_imageWithData:(nullable NSData *)data {
    return [[YH_SDWebImageCodersManager sharedInstance] decodedImageWithData:data];
}

- (nullable NSData *)yh_imageData {
    return [self yh_imageDataAsFormat:YH_SDImageFormatUndefined];
}

- (nullable NSData *)yh_imageDataAsFormat:(YH_SDImageFormat)imageFormat {
    NSData *imageData = nil;
    if (self) {
        imageData = [[YH_SDWebImageCodersManager sharedInstance] encodedDataWithImage:self format:imageFormat];
    }
    return imageData;
}


@end
