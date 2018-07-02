/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Fabrice Aneche
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "NSData+WM_ImageContentType.h"
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

+ (WM_SDImageFormat)wm_sd_imageFormatForImageData:(nullable NSData *)data {
    if (!data) {
        return WM_SDImageFormatUndefined;
    }
    
    // File signatures table: http://www.garykessler.net/library/file_sigs.html
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return WM_SDImageFormatJPEG;
        case 0x89:
            return WM_SDImageFormatPNG;
        case 0x47:
            return WM_SDImageFormatGIF;
        case 0x49:
        case 0x4D:
            return WM_SDImageFormatTIFF;
        case 0x52: {
            if (data.length >= 12) {
                //RIFF....WEBP
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    return WM_SDImageFormatWebP;
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
                    return WM_SDImageFormatHEIC;
                }
            }
            break;
        }
    }
    return WM_SDImageFormatUndefined;
}

+ (nonnull CFStringRef)wm_UTTypeFromSDImageFormat:(WM_SDImageFormat)format {
    CFStringRef UTType;
    switch (format) {
        case WM_SDImageFormatJPEG:
            UTType = kUTTypeJPEG;
            break;
        case WM_SDImageFormatPNG:
            UTType = kUTTypePNG;
            break;
        case WM_SDImageFormatGIF:
            UTType = kUTTypeGIF;
            break;
        case WM_SDImageFormatTIFF:
            UTType = kUTTypeTIFF;
            break;
        case WM_SDImageFormatWebP:
            UTType = kSDUTTypeWebP;
            break;
        case WM_SDImageFormatHEIC:
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
