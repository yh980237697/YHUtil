/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#ifdef WM_WEBP

#import "UIImage+WMWebP.h"
#import "WM_SDWebImageWebPCoder.h"
#import "UIImage+WM_MultiFormat.h"

@implementation UIImage (WebP)

- (NSInteger)wm_webpLoopCount {
    return self.wm_imageLoopCount;
}

+ (nullable UIImage *)wm_imageWithWebPData:(nullable NSData *)data {
    if (!data) {
        return nil;
    }
    return [[WM_SDWebImageWebPCoder sharedCoder] decodedImageWithData:data];
}

@end

#endif
