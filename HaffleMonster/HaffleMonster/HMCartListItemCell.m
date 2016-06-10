//
//  HMCartListItemCell.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 31..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMCartListItemCell.h"

@implementation HMCartListItemCell

- (void)layoutSubviews{
    self.evenMasterView.layer.borderWidth = 1;
    self.evenMasterView.layer.borderColor = [[UIColor colorWithRed:200/255.0f green:201/255.0f blue:202/255.0f alpha:1] CGColor];
    self.oddMasterView.layer.borderWidth = 1;
    self.oddMasterView.layer.borderColor = [[UIColor colorWithRed:200/255.0f green:201/255.0f blue:202/255.0f alpha:1] CGColor];
    self.oddImage.layer.borderWidth = 0.5;
    self.oddImage.layer.borderColor = [[UIColor colorWithRed:200/255.0f green:201/255.0f blue:202/255.0f alpha:1] CGColor];
    self.evenImage.layer.borderWidth = 0.5;
    self.evenImage.layer.borderColor = [[UIColor colorWithRed:200/255.0f green:201/255.0f blue:202/255.0f alpha:1] CGColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadContentsWithCartItem:(SRGood*)targetCartItem{

}

- (void)setCartItem:(SRGood *)cartItem{
    [self loadContentsWithCartItem:cartItem];
}

- (id)initWithCartItem:(SRGood *)cartItem{
    self = [super init];
    if(self != nil){
        self.cartItem = cartItem;
        
    }
    return self;
}

@end
