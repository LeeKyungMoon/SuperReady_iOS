//
//  HMHomeTableViewCell.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 15..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMHomeTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HMHomeTableViewCell

@synthesize market = _market;

- (void)layoutSubviews{
    UIColor *borderColor = [UIColor colorWithRed:200/255.0f green:201/255.0f blue:202/255.0f alpha:1];
    [masterView drawBorder:HCUIBordersTop|HCUIBordersBottom withColor:borderColor width:1];
    [martImageView drawBorder:HCUIBordersRight withColor:borderColor width:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMarket:(SRMarket *)market{
    _market = market;
    UIImage *placeholderImage = [UIImage imageNamed:@"DefaultMartImage"];
    if(market.panoramaURL){
        [martImageView setImageWithURLCached:market.panoramaURL placeholderImage:placeholderImage];
    }else{
        [martImageView setImage:placeholderImage];
    }
    [nameLabel setText:market.name];
    if([market isKindOfClass:[SRFavoriteMarket class]]){
        favoriteButton
    }else{
        
    }
}

@end
