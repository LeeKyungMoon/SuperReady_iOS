//
//  HMMainNavigationController.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 23..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMMainNavigationController.h"

@interface HMMainNavigationController ()

@end

@implementation HMMainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userCartButton = [[HMUserCartBarButtonItem alloc] initWithTarget:self action:@selector(touchedUserCartButton)];
    [self.userCartButton setBadgeNumber:0];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spacer setWidth:-8.0];
    self.delegate = self;
    rightButtonItems = @[spacer,self.userCartButton];
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.barTintColor =[UIColor colorWithRed:(222/255.0) green:(20/255.0) blue:(30/255.0) alpha:1.0];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.navigationItem.rightBarButtonItems = rightButtonItems;
}

- (void)touchedUserCartButton{
    UINavigationController *userCartViewNavigationRoot = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserCartNavigationRoot"];
    [self presentViewController:userCartViewNavigationRoot animated:YES completion:nil];
}

- (void)updateCartButton{
    NSUInteger userCartCount = [[SRDatabase db] userCartItemCount];
    if(self.userCartButton.badgeNumber != userCartCount){
        self.userCartButton.badgeNumber = userCartCount;
        [self.userCartButton shake];
    }
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
