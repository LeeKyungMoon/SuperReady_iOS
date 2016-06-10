//
//  UIImageView+CacheControl.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 15..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "UIImageView+CacheControl.h"

@implementation UIImageView (UIImageViewCacheControl)

- (void)setImageWithURLCached:(NSString *)urlString placeholderImage:(UIImage*)placeholderImage{
    NSURL *url;
    url = [NSURL URLWithString:urlString];
    [self sd_setImageWithURL:url placeholderImage:placeholderImage];
}

- (void)setImageWithURLCached:(NSString *)urlString completed:(void(^)(UIImage *image))completed{
    NSURL *url;
    url = [NSURL URLWithString:urlString];
    [self sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image;
        completed(image);
    }];
}

@end
