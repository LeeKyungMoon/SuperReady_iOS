//
//  HMSupportWebViewController.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 5. 8..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRLoads.h"

@interface UIWebView (JavaScriptAlert)
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
@end

@interface HMSupportWebViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *supportWeb;
    UINavigationController *nc;
}

- (void)dismissNavigationController;
- (void)presentOnViewController:(UIViewController*)target;
@end
