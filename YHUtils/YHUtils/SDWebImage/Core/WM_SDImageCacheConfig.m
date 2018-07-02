/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "WM_SDImageCacheConfig.h"

static const NSInteger WM_kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 week

@implementation WM_SDImageCacheConfig

- (instancetype)init {
    if (self = [super init]) {
        _shouldDecompressImages = YES;
        _shouldDisableiCloud = YES;
        _shouldCacheImagesInMemory = YES;
        _diskCacheReadingOptions = 0;
        _diskCacheWritingOptions = NSDataWritingAtomic;
        _maxCacheAge = WM_kDefaultCacheMaxCacheAge;
        _maxCacheSize = 0;
    }
    return self;
}

@end
