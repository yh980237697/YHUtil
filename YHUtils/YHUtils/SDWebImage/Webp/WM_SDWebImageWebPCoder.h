/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#ifdef WM_WEBP

#import <Foundation/Foundation.h>
#import "WM_SDWebImageCoder.h"

/**
 Built in coder that supports WebP and animated WebP
 */
@interface WM_SDWebImageWebPCoder : NSObject <WM_SDWebImageProgressiveCoder>

+ (nonnull instancetype)sharedCoder;

@end

#endif
