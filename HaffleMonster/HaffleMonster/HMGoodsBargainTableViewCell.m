//
//  HMGoodsBargainTableViewCell.m
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 31..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMGoodsBargainTableViewCell.h"

@implementation HMGoodsBargainTableViewCell

- (void)layoutSubviews {
    // Initialization code
    UIColor *borderColor = [UIColor colorWithRed:200/255.0f green:201/255.0f blue:202/255.0f alpha:1];
    self.masterView.layer.borderWidth = 1;
    self.masterView.layer.borderColor = [borderColor CGColor];
    self.image.layer.borderWidth = 0.5;
    self.image.layer.borderColor = [borderColor CGColor];
    self.cartButton.layer.masksToBounds = NO;
    self.cartButton.layer.shadowOffset = CGSizeMake(0,2);
    self.cartButton.layer.shadowOpacity = 0.1;
    self.cartButton.layer.shadowRadius = 2;
    self.cartButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.timeLeftLabel.layer.masksToBounds = NO;
    self.timeLeftLabel.layer.shadowOffset = CGSizeMake(0,1);
    self.timeLeftLabel.layer.shadowOpacity = 0.5;
    self.timeLeftLabel.layer.shadowRadius = 2;
    self.timeLeftLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSaleRate:(NSUInteger)saleRate{
    if(saleRate == 0){
        saleRateView.hidden = YES;
    }else{
        saleRateView.hidden = NO;
        NSString *imageName = [NSString stringWithFormat:@"sale_percent_rate%ld", (unsigned long)saleRate];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        saleRateView.image = image;
    }
}

- (void)setOriginalPrice:(NSUInteger)originalPrice{
    if(originalPrice == 0){
        originalPriceLabel.hidden = YES;
    }else{
        originalPriceLabel.hidden = NO;
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *formattedNumberString = [decimalFormatter stringFromNumber:@(originalPrice)];
        NSString *finalString = [NSString stringWithFormat:@"%@원", formattedNumberString];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:finalString];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName value:@1 range:NSMakeRange(0, [attributeString length])];
        originalPriceLabel.attributedText = attributeString;
        if(saleRateView.hidden){
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"sale_special_price" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            saleRateView.image = image;
        }
    }
}

- (void)setEventDescriptionText:(NSString *)eventDescriptionText{
    if([eventDescriptionText isEqualToString:@""]){
        self.eventDescription.text = @"슈퍼레디가";
    }else{
        self.eventDescription.text = eventDescriptionText;
    }
}
@end
