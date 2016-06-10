//
//  HMMartRequestViewController.h
//  HaffleMonster
//
//  Created by LKM on 2015. 7. 10..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptAlert)
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

@end

@interface HMMartRequestViewController : UIViewController{
    UINavigationController *nc;
    IBOutlet UIWebView *webview;
}

- (void)dismissNavigationController;
- (void)presentOnViewController:(UIViewController*)target;
@end
