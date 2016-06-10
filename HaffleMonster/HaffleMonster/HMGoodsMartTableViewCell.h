//
//  HMGoodsMartTableViewCell.h
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 31..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"
@interface HMGoodsMartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *panorama;
@property (weak, nonatomic) IBOutlet UILabel *martDescription;
@property (weak, nonatomic) IBOutlet UILabel *businessHour;
@property (weak, nonatomic) IBOutlet UIButton *map;
@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UIView *masterView;

@end
