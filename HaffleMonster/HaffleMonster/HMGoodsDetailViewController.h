//
//  HMGoodsDetailViewController.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 16..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "HMGoodsDetailDescriptionView.h"
#import "HMGoodsDetailFooterView.h"
#import "HMShareManager.h"
#import "HMMainNavigationController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SRLoad.h"

@interface HMGoodsDetailViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate> {
    IBOutlet UIWebView *webView;
    HMGoodsDetailDescriptionView *descriptionView;
    HMGoodsDetailFooterView *footerView;
    CGFloat screenWidth;
    CGFloat screenHeight;
    BOOL isFirstAction;
    CGRect itemImageViewFrame;
    NSTimer *timer;
    UIWebView *displayWebView;
}

@property(strong) SRGood *good;

@end
