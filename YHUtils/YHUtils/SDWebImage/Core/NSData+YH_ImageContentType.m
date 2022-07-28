/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Fabrice Aneche
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "NSData+YH_ImageContentType.h"
#if SD_MAC
#import <CoreServices/CoreServices.h>
#else
#import <MobileCoreServices/MobileCoreServices.h>
#endif

// Currently Image/IO does not support WebP
#define kSDUTTypeWebP ((__bridge CFStringRef)@"public.webp")
// AVFileTypeHEIC is defined in AVFoundation via iOS 11, we use this without import AVFoundation
#define kSDUTTypeHEIC ((__bridge CFStringRef)@"public.heic")

@implementation NSData (ImageContentType)

+ (YH_SDImageFormat)yh_sd_imageFormatForImageData:(nullable NSData *)data {
    if (!data) {
        return YH_SDImageFormatUndefined;
    }
    
    // File signatures table: http://www.garykessler.net/library/file_sigs.html
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return YH_SDImageFormatJPEG;
        case 0x89:
            return YH_SDImageFormatPNG;
        case 0x47:
            return YH_SDImageFormatGIF;
        case 0x49:
        case 0x4D:
            return YH_SDImageFormatTIFF;
        case 0x52: {
            if (data.length >= 12) {
                //RIFF....WEBP
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    return YH_SDImageFormatWebP;
                }
            }
            break;
        }
        case 0x00: {
            if (data.length >= 12) {
                //....ftypheic ....ftypheix ....ftyphevc ....ftyphevx
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, 8)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"ftypheic"]
                    || [testString isEqualToString:@"ftypheix"]
                    || [testString isEqualToString:@"ftyphevc"]
                    || [testString isEqualToString:@"ftyphevx"]) {
                    return YH_SDImageFormatHEIC;
                }
            }
            break;
        }
    }
    return YH_SDImageFormatUndefined;
}

+ (nonnull CFStringRef)yh_UTTypeFromSDImageFormat:(YH_SDImageFormat)format {
    CFStringRef UTType;
    switch (format) {
        case YH_SDImageFormatJPEG:
            UTType = kUTTypeJPEG;
            break;
        case YH_SDImageFormatPNG:
            UTType = kUTTypePNG;
            break;
        case YH_SDImageFormatGIF:
            UTType = kUTTypeGIF;
            break;
        case YH_SDImageFormatTIFF:
            UTType = kUTTypeTIFF;
            break;
        case YH_SDImageFormatWebP:
            UTType = kSDUTTypeWebP;
            break;
        case YH_SDImageFormatHEIC:
            UTType = kSDUTTypeHEIC;
            break;
        default:
            // default is kUTTypePNG
            UTType = kUTTypePNG;
            break;
    }
    return UTType;
}

@end
