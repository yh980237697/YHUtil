/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Fabrice Aneche
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "YH_SDWebImageCompat.h"

typedef NS_ENUM(NSInteger, YH_SDImageFormat) {
    YH_SDImageFormatUndefined = -1,
    YH_SDImageFormatJPEG = 0,
    YH_SDImageFormatPNG,
    YH_SDImageFormatGIF,
    YH_SDImageFormatTIFF,
    YH_SDImageFormatWebP,
    YH_SDImageFormatHEIC
};

@interface NSData (YH_ImageContentType)

/**
 *  Return image format
 *
 *  @param data the input image data
 *
 *  @return the image format as `SDImageFormat` (enum)
 */
+ (YH_SDImageFormat)yh_sd_imageFormatForImageData:(nullable NSData *)data;

/**
 Convert SDImageFormat to UTType

 @param format Format as SDImageFormat
 @return The UTType as CFStringRef
 */
+ (nonnull CFStringRef)yh_UTTypeFromSDImageFormat:(YH_SDImageFormat)format;

@end
