//
//  UIImageView+CacheControl.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 15..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIImageView (UIImageViewCacheControl)

- (void)setImageWithURLCached:(NSString *)urlString placeholderImage:(UIImage*)placeholderImage;
- (void)setImageWithURLCached:(NSString *)urlString completed:(void(^)(UIImage *image))completed;

@end
