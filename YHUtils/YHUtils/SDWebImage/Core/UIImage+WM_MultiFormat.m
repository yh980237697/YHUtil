/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImage+WM_MultiFormat.h"

#import "objc/runtime.h"
#import "WM_SDWebImageCodersManager.h"

@implementation UIImage (WM_MultiFormat)

#if SD_MAC
- (NSUInteger)wm_imageLoopCount {
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

- (void)setWm_imageLoopCount:(NSUInteger)wm_imageLoopCount {
    for (NSImageRep *rep in self.representations) {
        if ([rep isKindOfClass:[NSBitmapImageRep class]]) {
            NSBitmapImageRep *bitmapRep = (NSBitmapImageRep *)rep;
            [bitmapRep setProperty:NSImageLoopCount withValue:@(wm_imageLoopCount)];
            break;
        }
    }
}

#else

- (NSUInteger)wm_imageLoopCount {
    NSUInteger imageLoopCount = 0;
    NSNumber *value = objc_getAssociatedObject(self, @selector(wm_imageLoopCount));
    if ([value isKindOfClass:[NSNumber class]]) {
        imageLoopCount = value.unsignedIntegerValue;
    }
    return imageLoopCount;
}

- (void)setWm_imageLoopCount:(NSUInteger)wm_imageLoopCount {
    NSNumber *value = @(wm_imageLoopCount);
    objc_setAssociatedObject(self, @selector(wm_imageLoopCount), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#endif

+ (nullable UIImage *)wm_imageWithData:(nullable NSData *)data {
    return [[WM_SDWebImageCodersManager sharedInstance] decodedImageWithData:data];
}

- (nullable NSData *)wm_imageData {
    return [self wm_imageDataAsFormat:WM_SDImageFormatUndefined];
}

- (nullable NSData *)wm_imageDataAsFormat:(WM_SDImageFormat)imageFormat {
    NSData *imageData = nil;
    if (self) {
        imageData = [[WM_SDWebImageCodersManager sharedInstance] encodedDataWithImage:self format:imageFormat];
    }
    return imageData;
}


@end
