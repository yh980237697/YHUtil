/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#ifdef WM_WEBP

#import "WM_SDWebImageCompat.h"

@interface UIImage (WMWebP)

/**
 * Get the current WebP image loop count, the default value is 0.
 * For static WebP image, the value is 0.
 * For animated WebP image, 0 means repeat the animation indefinitely.
 * Note that because of the limitations of categories this property can get out of sync
 * if you create another instance with CGImage or other methods.
 * @return WebP image loop count
 * @deprecated use `wm_imageLoopCount` instead.
 */
- (NSInteger)wm_webpLoopCount __deprecated_msg("Method deprecated. Use `wm_imageLoopCount` in `UIImage+MultiFormat.h`");

+ (nullable UIImage *)wm_imageWithWebPData:(nullable NSData *)data;

@end

#endif
