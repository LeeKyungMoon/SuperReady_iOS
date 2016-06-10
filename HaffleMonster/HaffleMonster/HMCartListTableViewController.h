//  HMCartListTableViewController.h
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 27..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartList.h"
#import "SRGood.h"
#import "HMLocationMarts.h"
@interface HMCartListTableViewController : UITableViewController <UIActionSheetDelegate>
@property NSMutableArray *cartItems;
@property SRGood *item;
@property HMUserCart *userCart;
@property HMLocationMarts *martsOfCart;
@property NSTimer *timer;
@property BOOL isEvenAtCart;
- (void)oddDetailTap:(UITapGestureRecognizer *)recognizer;
- (void)evenDetailTap:(UITapGestureRecognizer *)recognizer;
- (void)oddDeleteTap:(UITapGestureRecognizer *)recognizer;
- (void)evenDeleteTap:(UITapGestureRecognizer *)recognizer;
//- (void)reloadTableViewData;
//- (NSString *)updateLabel:(id)sender :(NSDate*)campaignEndDate;
@end