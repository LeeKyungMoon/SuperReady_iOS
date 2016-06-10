//
//  HMGoodsDetailDescriptionView.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 16..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMGoodsDetailDescriptionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *martNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UILabel *itemDescription;
@property (strong, nonatomic) IBOutlet UILabel *itemPrice;
@property (strong, nonatomic) IBOutlet UILabel *priceDescriptionLabel;
@end
