//
//  HMGoodsTableViewController.h
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 25..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Home.h"
#import "Goods.h"
#import "HMYakdoViewController.h"
#import "SRCampaign.h"
#import "SRLoads.h"
#import "HMGoodsDetailViewController.h"
#import "HMMainNavigationController.h"
@interface HMGoodsTableViewController : UITableViewController <UINavigationControllerDelegate> {
    BOOL isKakaoChecked;
    BOOL isNoItem;
    UIImageView *martPanoramaView;
    CGRect martPanoramaFrame;
}

@property NSString *test;
@property UINavigationBar *navBar;
@property NSString *titleViewURL;
@property SRMarket *selectedMarket;

@property BOOL isEvenAtGeneral;
@property float selfLatitude;
@property float selfLongitude;
@property NSTimer *timer;
/**
 * 이유를 알 수 없는 prepareForSegue로 데이터 패싱이 안되서 특가셀도 UITapGestureRecognizer 메소드 사용.
 * 일반셀에 홀짝 구분 메소드를 넣은거는 메소드에 뷰를 2개 이상 넣을 시에 마지막에 넣은 뷰만 이벤트에 걸리므로 따로 구분해서 메소드 만듦.
 */

- (NSString *)updateLabel:(id)sender :(SRCampaign*)campaign;
- (void)reloadTableViewData;
- (NSIndexPath*)indexPathForItemId:(NSUInteger)itemId;
- (SRCampaign *)campaignOfItem:(NSMutableArray *)campaigns :(NSInteger)indexpathRow :(SRCampaignType)campaignType :(BOOL)isEven;
@end
