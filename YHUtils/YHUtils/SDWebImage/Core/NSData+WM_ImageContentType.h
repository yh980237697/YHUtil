/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Fabrice Aneche
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "WM_SDWebImageCompat.h"

typedef NS_ENUM(NSInteger, WM_SDImageFormat) {
    WM_SDImageFormatUndefined = -1,
    WM_SDImageFormatJPEG = 0,
    WM_SDImageFormatPNG,
    WM_SDImageFormatGIF,
    WM_SDImageFormatTIFF,
    WM_SDImageFormatWebP,
    WM_SDImageFormatHEIC
};

@interface NSData (WM_ImageContentType)

/**
 *  Return image format
 *
 *  @param data the input image data
 *
 *  @return the image format as `SDImageFormat` (enum)
 */
+ (WM_SDImageFormat)wm_sd_imageFormatForImageData:(nullable NSData *)data;

/**
 Convert SDImageFormat to UTType

 @param format Format as SDImageFormat
 @return The UTType as CFStringRef
 */
+ (nonnull CFStringRef)wm_UTTypeFromSDImageFormat:(WM_SDImageFormat)format;

@end
