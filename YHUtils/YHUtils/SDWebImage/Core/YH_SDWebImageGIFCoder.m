/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "YH_SDWebImageGIFCoder.h"
#import "NSImage+YH_WebCache.h"
#import <ImageIO/ImageIO.h>
#import "NSData+YH_ImageContentType.h"
#import "UIImage+YH_MultiFormat.h"
#import "YH_SDWebImageCoderHelper.h"
#import "YH_SDAnimatedImageRep.h"

@implementation YH_SDWebImageGIFCoder

+ (instancetype)sharedCoder {
    static YH_SDWebImageGIFCoder *coder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coder = [[YH_SDWebImageGIFCoder alloc] init];
    });
    return coder;
}

#pragma mark - Decode
- (BOOL)canDecodeFromData:(nullable NSData *)data {
    return ([NSData yh_sd_imageFormatForImageData:data] == YH_SDImageFormatGIF);
}

- (UIImage *)decodedImageWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
#if SD_MAC
    SDAnimatedImageRep *imageRep = [[SDAnimatedImageRep alloc] initWithData:data];
    NSImage *animatedImage = [[NSImage alloc] initWithSize:imageRep.size];
    [animatedImage addRepresentation:imageRep];
    return animatedImage;
#else
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (!source) {
        return nil;
    }
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        NSMutableArray<YH_SDWebImageFrame *> *frames = [NSMutableArray array];
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!imageRef) {
                continue;
            }
            
            float duration = [self yh_frameDurationAtIndex:i source:source];
            UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            YH_SDWebImageFrame *frame = [YH_SDWebImageFrame frameWithImage:image duration:duration];
            [frames addObject:frame];
        }
        
        NSUInteger loopCount = 1;
        NSDictionary *imageProperties = (__bridge_transfer NSDictionary *)CGImageSourceCopyProperties(source, nil);
        NSDictionary *gifProperties = [imageProperties valueForKey:(__bridge_transfer NSString *)kCGImagePropertyGIFDictionary];
        if (gifProperties) {
            NSNumber *gifLoopCount = [gifProperties valueForKey:(__bridge_transfer NSString *)kCGImagePropertyGIFLoopCount];
            if (gifLoopCount != nil) {
                loopCount = gifLoopCount.unsignedIntegerValue;
            }
        }
        
        animatedImage = [YH_SDWebImageCoderHelper animatedImageWithFrames:frames];
        animatedImage.yh_imageLoopCount = loopCount;
    }
    
    CFRelease(source);
    
    return animatedImage;
#endif
}

- (float)yh_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    if (!cfFrameProperties) {
        return frameDuration;
    }
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp != nil) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp != nil) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

- (UIImage *)decompressedImageWithImage:(UIImage *)image
                                   data:(NSData *__autoreleasing  _Nullable *)data
                                options:(nullable NSDictionary<NSString*, NSObject*>*)optionsDict {
    // GIF do not decompress
    return image;
}

#pragma mark - Encode
- (BOOL)canEncodeToFormat:(YH_SDImageFormat)format {
    return (format == YH_SDImageFormatGIF);
}

- (NSData *)encodedDataWithImage:(UIImage *)image format:(YH_SDImageFormat)format {
    if (!image) {
        return nil;
    }
    
    if (format != YH_SDImageFormatGIF) {
        return nil;
    }
    
    NSMutableData *imageData = [NSMutableData data];
    CFStringRef imageUTType = [NSData yh_UTTypeFromSDImageFormat:YH_SDImageFormatGIF];
    NSArray<YH_SDWebImageFrame *> *frames = [YH_SDWebImageCoderHelper framesFromAnimatedImage:image];
    
    // Create an image destination. GIF does not support EXIF image orientation
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData, imageUTType, frames.count, NULL);
    if (!imageDestination) {
        // Handle failure.
        return nil;
    }
    if (frames.count == 0) {
        // for static single GIF images
        CGImageDestinationAddImage(imageDestination, image.CGImage, nil);
    } else {
        // for animated GIF images
        NSUInteger loopCount = image.yh_imageLoopCount;
        NSDictionary *gifProperties = @{(__bridge_transfer NSString *)kCGImagePropertyGIFDictionary: @{(__bridge_transfer NSString *)kCGImagePropertyGIFLoopCount : @(loopCount)}};
        CGImageDestinationSetProperties(imageDestination, (__bridge CFDictionaryRef)gifProperties);
        
        for (size_t i = 0; i < frames.count; i++) {
            YH_SDWebImageFrame *frame = frames[i];
            float frameDuration = frame.duration;
            CGImageRef frameImageRef = frame.image.CGImage;
            NSDictionary *frameProperties = @{(__bridge_transfer NSString *)kCGImagePropertyGIFDictionary : @{(__bridge_transfer NSString *)kCGImagePropertyGIFDelayTime : @(frameDuration)}};
            CGImageDestinationAddImage(imageDestination, frameImageRef, (__bridge CFDictionaryRef)frameProperties);
        }
    }
    // Finalize the destination.
    if (CGImageDestinationFinalize(imageDestination) == NO) {
        // Handle failure.
        imageData = nil;
    }
    
    CFRelease(imageDestination);
    
    return [imageData copy];
}

@end
