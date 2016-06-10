//
//  HMRawFlyerWebViewController.m
//  HaffleMonster
//
//  Created by LKM on 2015. 7. 9..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMRawFlyerWebViewController.h"

@interface HMRawFlyerWebViewController ()

@end

@implementation HMRawFlyerWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.rawFlyerWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.rawFlyerURLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.rawFlyerWebView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (id)initWithURLString:(NSString*)urlString;

- (id)initWithURLString:(NSString *)urlString
{
    self = [super init];
    if(self != nil){
        self.rawFlyerURLString = urlString;
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
