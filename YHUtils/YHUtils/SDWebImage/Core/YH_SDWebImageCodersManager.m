/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "YH_SDWebImageCodersManager.h"
#import "YH_SDWebImageImageIOCoder.h"
#import "YH_SDWebImageGIFCoder.h"
#ifdef YH_WEBP
#import "YH_SDWebImageWebPCoder.h"
#endif

#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define UNLOCK(lock) dispatch_semaphore_signal(lock);

@interface YH_SDWebImageCodersManager ()

@property (nonatomic, strong, nonnull) dispatch_semaphore_t codersLock;

@end

@implementation YH_SDWebImageCodersManager

+ (nonnull instancetype)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // initialize with default coders
        NSMutableArray<id<YH_SDWebImageCoder>> *mutableCoders = [@[[YH_SDWebImageImageIOCoder sharedCoder]] mutableCopy];
#ifdef YH_WEBP
        [mutableCoders addObject:[YH_SDWebImageWebPCoder sharedCoder]];
#endif
        _coders = [mutableCoders copy];
        _codersLock = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - Coder IO operations

- (void)addCoder:(nonnull id<YH_SDWebImageCoder>)coder {
    if (![coder conformsToProtocol:@protocol(YH_SDWebImageCoder)]) {
        return;
    }
    LOCK(self.codersLock);
    NSMutableArray<id<YH_SDWebImageCoder>> *mutableCoders = [self.coders mutableCopy];
    if (!mutableCoders) {
        mutableCoders = [NSMutableArray array];
    }
    [mutableCoders addObject:coder];
    self.coders = [mutableCoders copy];
    UNLOCK(self.codersLock);
}

- (void)removeCoder:(nonnull id<YH_SDWebImageCoder>)coder {
    if (![coder conformsToProtocol:@protocol(YH_SDWebImageCoder)]) {
        return;
    }
    LOCK(self.codersLock);
    NSMutableArray<id<YH_SDWebImageCoder>> *mutableCoders = [self.coders mutableCopy];
    [mutableCoders removeObject:coder];
    self.coders = [mutableCoders copy];
    UNLOCK(self.codersLock);
}

#pragma mark - SDWebImageCoder
- (BOOL)canDecodeFromData:(NSData *)data {
    LOCK(self.codersLock);
    NSArray<id<YH_SDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<YH_SDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canDecodeFromData:data]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)canEncodeToFormat:(YH_SDImageFormat)format {
    LOCK(self.codersLock);
    NSArray<id<YH_SDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<YH_SDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canEncodeToFormat:format]) {
            return YES;
        }
    }
    return NO;
}

- (UIImage *)decodedImageWithData:(NSData *)data {
    LOCK(self.codersLock);
    NSArray<id<YH_SDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<YH_SDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canDecodeFromData:data]) {
            return [coder decodedImageWithData:data];
        }
    }
    return nil;
}

- (UIImage *)decompressedImageWithImage:(UIImage *)image
                                   data:(NSData *__autoreleasing  _Nullable *)data
                                options:(nullable NSDictionary<NSString*, NSObject*>*)optionsDict {
    if (!image) {
        return nil;
    }
    LOCK(self.codersLock);
    NSArray<id<YH_SDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<YH_SDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canDecodeFromData:*data]) {
            return [coder decompressedImageWithImage:image data:data options:optionsDict];
        }
    }
    return nil;
}

- (NSData *)encodedDataWithImage:(UIImage *)image format:(YH_SDImageFormat)format {
    if (!image) {
        return nil;
    }
    LOCK(self.codersLock);
    NSArray<id<YH_SDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<YH_SDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canEncodeToFormat:format]) {
            return [coder encodedDataWithImage:image format:format];
        }
    }
    return nil;
}

@end
