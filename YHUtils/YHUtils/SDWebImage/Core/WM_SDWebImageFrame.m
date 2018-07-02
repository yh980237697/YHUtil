/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "WM_SDWebImageFrame.h"

@interface WM_SDWebImageFrame ()

@property (nonatomic, strong, readwrite, nonnull) UIImage *image;
@property (nonatomic, readwrite, assign) NSTimeInterval duration;

@end

@implementation WM_SDWebImageFrame

+ (instancetype)frameWithImage:(UIImage *)image duration:(NSTimeInterval)duration {
    WM_SDWebImageFrame *frame = [[WM_SDWebImageFrame alloc] init];
    frame.image = image;
    frame.duration = duration;
    
    return frame;
}

@end
