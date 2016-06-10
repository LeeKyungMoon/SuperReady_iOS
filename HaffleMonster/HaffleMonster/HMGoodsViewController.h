//
//  HMGoodsViewController.h
//  HaffleMonster
//
//  Created by LKM on 2015. 6. 5..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMGoodsCollectionViewCell.h"
#import "HMGoodsGeneralCollectionViewCell.h"
@interface HMGoodsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *goodsCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property NSMutableArray *generalCampaigns;
@property NSMutableArray *bargainCampaigns;
@property NSMutableArray *bargainItems;
@property NSMutableArray *generalItems;
@property SRMarket *selectedMart;
@property BOOL isNoItem;
@end
