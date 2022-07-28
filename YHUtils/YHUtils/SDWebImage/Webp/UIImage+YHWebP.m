/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#ifdef YH_WEBP

#import "UIImage+YHWebP.h"
#import "YH_SDWebImageWebPCoder.h"
#import "UIImage+YH_MultiFormat.h"

@implementation UIImage (WebP)

- (NSInteger)yh_webpLoopCount {
    return self.yh_imageLoopCount;
}

+ (nullable UIImage *)yh_imageWithWebPData:(nullable NSData *)data {
    if (!data) {
        return nil;
    }
    return [[YH_SDWebImageWebPCoder sharedCoder] decodedImageWithData:data];
}

@end

#endif
