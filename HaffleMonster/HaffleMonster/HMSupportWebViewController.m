//
//  HMSupportWebViewController.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 5. 8..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMSupportWebViewController.h"
#define kHMSupportURL @"http://haffle.cafe24.com/support/index.htm"

@interface HMSupportWebViewController ()

@end

@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [customAlert show];
}

@end

@implementation HMSupportWebViewController

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if([[[request URL] absoluteString] hasSuffix:@"superready.done"]){
        [self dismissNavigationController];
        return NO;
    }else{
        return YES;
    }
}

- (void)dismissNavigationController{
    SET_KADATA = @{
                   @"앱 실행 횟수":[KA appLaunchCount],
                   @"지역":[KA userAddress],
                   @"사용자 나이":[KA userBirthYear],
                   @"사용자 성별":[KA userGenderString]
                   };
    SEND_KA_ @"고객지원 제출" _EVENT;
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"감사합니다" message:@"소중한 의견 귀담아 듣겠습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [customAlert show];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentOnViewController:(UIViewController*)target{
    nc = [[UINavigationController alloc] initWithRootViewController:self];
    [target presentViewController:nc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    supportWeb.delegate = self;
    NSURL *url = [NSURL URLWithString:[kHMSupportURL stringByAppendingString:[NSString stringWithFormat:@"#%@",[HMAPIRequestManager userId]]]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [supportWeb loadRequest:urlRequest];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:(222/255.0) green:(20/255.0) blue:(30/255.0) alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"슈퍼레디 고객지원";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"취소" style:UIBarButtonItemStylePlain target:self action:@selector(closeSupport:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    // Do any additional setup after loading the view from its nib.
}

- (void)closeSupport:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[HMKinsightSession shared] tagScreen:@"고객지원"];
    SET_KADATA = @{
                   @"앱 실행 횟수":[KA appLaunchCount],
                   @"지역":[KA userAddress],
                   @"사용자 나이":[KA userBirthYear],
                   @"사용자 성별":[KA userGenderString]
                   };
    SEND_KA_ @"고객지원 시작" _EVENT;
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
