//
//  HMHomeGPSTableViewCell.h
//  HaffleMonster
//
//  Created by LKM on 2015. 3. 16..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMHomeGPSTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_gps;
@property (weak, nonatomic) IBOutlet UILabel *location_map;
@property (weak, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet UIButton *relocate_map;
@end
