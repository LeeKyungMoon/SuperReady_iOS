//
//  HMCartListItemCell.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 31..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDataModel.h"
#import "Home.h"

@interface HMCartListItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *oddImage;
@property (weak, nonatomic) IBOutlet UILabel *oddItemName;
@property (weak, nonatomic) IBOutlet UILabel *oddItemDescription;
@property (weak, nonatomic) IBOutlet UIView *oddMasterView;
@property (weak, nonatomic) IBOutlet UILabel *oddPrice;
@property NSUInteger oddItemId;
@property (weak, nonatomic) IBOutlet UIButton *oddDeleteButton;
@property SRGood *oddItem;
@property (nonatomic, retain) HMUserCartItem *oddUserCartItem;
@property (weak, nonatomic) IBOutlet UILabel *oddMartName;
@property (weak, nonatomic) IBOutlet UILabel *oddPriceDescription;
@property SRCampaign *oddParentCampaign;
@property SRMarket *oddParentMart;

@property (weak, nonatomic) IBOutlet UIImageView *evenImage;
@property (weak, nonatomic) IBOutlet UILabel *evenItemName;
@property (weak, nonatomic) IBOutlet UILabel *evenItemDescription;
@property (weak, nonatomic) IBOutlet UIView *evenMasterView;
@property (weak, nonatomic) IBOutlet UILabel *evenPrice;
@property (weak, nonatomic) IBOutlet UIButton *evenDeleteButton;
@property (nonatomic, retain) HMUserCartItem *evenUserCartItem;
@property (nonatomic, retain) SRGood *evenItem;
@property SRCampaign *evenParentCampaign;
@property SRMarket *evenParentMart;
@property (weak, nonatomic) IBOutlet UILabel *evenMartName;
@property (weak, nonatomic) IBOutlet UILabel *evenPriceDescription;

-(id)initWithCartItem:(SRGood*)cartItem;

@end