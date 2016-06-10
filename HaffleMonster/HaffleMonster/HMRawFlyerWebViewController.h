//
//  HMRawFlyerWebViewController.h
//  HaffleMonster
//
//  Created by LKM on 2015. 7. 9..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMRawFlyerWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *rawFlyerWebView;
@property NSString *rawFlyerURLString;
- (id)initWithURLString:(NSString*)urlString;
@end
