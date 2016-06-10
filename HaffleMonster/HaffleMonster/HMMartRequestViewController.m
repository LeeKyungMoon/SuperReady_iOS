//
//  HMMartRequestViewController.m
//  HaffleMonster
//
//  Created by LKM on 2015. 7. 10..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMMartRequestViewController.h"

@interface HMMartRequestViewController ()

@end

@implementation HMMartRequestViewController

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if([[[request URL] absoluteString] hasSuffix:@"superready.done"]){
        [self dismissNavigationController];
        return NO;
    }else{
        return YES;
    }
}

- (void)dismissNavigationController{
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"감사합니다" message:@"소중한 의견 귀담아 듣겠습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [customAlert show];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    webview.delegate = self;
    //http://superready" + urlAddess + ".azurewebsites.net/app/request/#
    //#define kHMDefaultURL @"http://superready-staging.azurewebsites.net"
    NSURL *url = [NSURL URLWithString:[kHMDefaultURL stringByAppendingString:[NSString stringWithFormat:@"/app/request#"]]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webview loadRequest:urlRequest];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:(222/255.0) green:(20/255.0) blue:(30/255.0) alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"슈퍼레디 마트요청";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"취소" style:UIBarButtonItemStylePlain target:self action:@selector(closeSupport:)];
    self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)presentOnViewController:(UIViewController*)target{
    nc = [[UINavigationController alloc] initWithRootViewController:self];
    [target presentViewController:nc animated:YES completion:nil];
}

- (void)closeSupport:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
