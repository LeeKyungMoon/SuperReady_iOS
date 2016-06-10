//
//  HMGoodsDetailViewController.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 16..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMGoodsDetailViewController.h"

#define kDetailViewHeight 280
#define kDetailTabHeight 0
#define kDetailFootHeight 56

@implementation NSString (HMStringURLRequestAddition)

- (NSURLRequest*)URLRequest{
    NSURL *url = [NSURL URLWithString:self];
    return [NSURLRequest requestWithURL:url];
}

@end

@interface HMGoodsDetailViewController ()

@end

@implementation HMGoodsDetailViewController

- (CGFloat)statusBarHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
}

- (id)init{
    self = [super init];
    if(self != nil){
        screenWidth = [[UIScreen mainScreen] bounds].size.width;
        screenHeight = [[UIScreen mainScreen] bounds].size.height;
        isFirstAction = YES;
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)nWebView{
    [self updateViewHierarchyAfterWorks];
}

- (void)updateViewHierarchyAfterWorks{
    [descriptionView setFrame:CGRectMake(0,-(kDetailTabHeight + kDetailViewHeight),screenWidth,kDetailViewHeight + kDetailTabHeight)];
    webView.scrollView.contentInset = UIEdgeInsetsMake(kDetailViewHeight + kDetailTabHeight, 0, kDetailFootHeight, 0);
    webView.scrollView.contentOffset = CGPointMake(0,-(kDetailViewHeight + kDetailTabHeight));
    [self.view setNeedsDisplay];
}
- (void)setFooterView{
    footerView.impactDescriptionLabel.text = self.good.parentCampaign.timeLeftMessage;
    if(self.good.retailPrice){
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *formattedNumberString = [decimalFormatter stringFromNumber:self.good.retailPrice];
        footerView.priceLabel.text = [NSString stringWithFormat:@"%@원", formattedNumberString];
    }else{
        footerView.priceLabel.hidden = YES;
        footerView.priceDescriptionLabel.hidden = YES;
    }
}
- (void)updateViewHierarchy{
    if(isFirstAction){
        isFirstAction = NO;
        descriptionView = [[HMGoodsDetailDescriptionView alloc] init];
        [webView.scrollView addSubview:descriptionView];
        [descriptionView setFrame:CGRectMake(0,0,screenWidth,kDetailViewHeight + kDetailTabHeight)];
        [self setFooterView];
        [self.view addSubview:footerView];
        [footerView setFrame:CGRectMake(0,screenHeight - kDetailFootHeight - [self statusBarHeight],screenWidth, kDetailFootHeight)];
        [webView.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, kDetailFootHeight, 0)];
    }
    
}

- (void)insertCart{
//    SRDatabase *db = [SRDatabase db];
//    HMUserCartItem *cartItem = [[HMUserCartItem alloc] initWithMart:self.parentMart campaign:self.parentCampaign item:self.clickedItem];
//    NSNumber *timeLeft = @((int)([self.parentCampaign.endDate timeIntervalSinceNow]) / 60 / 60);
//    NSString *campaignType = @"일반";
//    if(self.parentCampaign.campaignType == SRCampaignTypeTimeSale){
//        campaignType = @"특가";
//    }
//    if([db isUserCartItemInUserCart:cartItem]){
//        [db deleteUserCartItem:cartItem];
//        [self.footerView.userCartButton setImage:[UIImage imageNamed:@"likecircle"] forState:UIControlStateNormal];
//        SET_KADATA = @{
//                       @"등록한 뷰":@"상세뷰",
//                       @"앱 실행 횟수":[KA appLaunchCount],
//                       @"사용자 나이":[KA userBirthYear],
//                       @"사용자 성별":[KA userGenderString],
//                       @"가격":@(cartItem.itemPrice),
//                       @"현위치와 마켓사이 거리":[KA distanceOfMart:self.parentMart],
//                       @"캠페인 유형":campaignType,
//                       @"캠페인 남은 시간":timeLeft
//                       };
//        SEND_KA_ @"관심상품 등록" _EVENT;
//    }else{
//        HMUserCartItem *cartItem = [[HMUserCartItem alloc] initWithMart:self.parentMart campaign:self.parentCampaign item:self.clickedItem];
//        [db insertUserCartItem:cartItem];
//        [self.footerView.userCartButton setImage:[UIImage imageNamed:@"full_likecircle"] forState:UIControlStateNormal];
//        SET_KADATA = @{
//                       @"삭제한 뷰":@"상세뷰",
//                       @"앱 실행 횟수":[KA appLaunchCount],
//                       @"가격":@(cartItem.itemPrice),
//                       @"캠페인 유형":campaignType,
//                       @"캠페인 남은 시간":timeLeft
//                       };
//        SEND_KA_ @"관심상품 삭제" _EVENT;
//    }
//    if([self.navigationController isKindOfClass:[HMMainNavigationController class]]){
//        [kMainNavigation updateCartButton];
//    }
}
- (void)checkItem{
//    // LOGGING NSLog(@"관심상품 클릭");
//    SRDatabase *db = [SRDatabase db];
//    HMUserCartItem *cartItem = [[HMUserCartItem alloc] initWithMart:self.parentMart campaign:self.parentCampaign item:self.clickedItem];
//    if([db isUserCartItemInUserCart:cartItem]){
//        [self.footerView.userCartButton setImage:[UIImage imageNamed:@"full_likecircle"] forState:UIControlStateNormal];
//    }else{
//        [self.footerView.userCartButton setImage:[UIImage imageNamed:@"likecircle"] forState:UIControlStateNormal];
//    }
}

- (void)shareKakao{
    // LOGGING NSLog(@"카톡공유 클릭");
    [HMShareManager sendKakaoTalkShareWithGood:self.clickedItem];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.footerView = [[HMGoodsDetailFooterView alloc] init];
    [self.footerView.userCartButton addTarget:self action:@selector(insertCart) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView.kakaoButton addTarget:self action:@selector(shareKakao) forControlEvents:UIControlEventTouchUpInside];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(setFooterView)
                                                userInfo:nil
                                                 repeats:YES ];
    webView.delegate = self;
    webView.scrollView.delegate = self;
    [webView setOpaque:NO];
    webView.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"상세정보";
    [self checkItem];
    [self performSelectorOnMainThread:@selector(loadData) withObject:nil waitUntilDone:NO];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    //[self.timer invalidate];
}

- (void)loadData{
    if (self.clickedItem.imageURLString.length == 0) {
        [descriptionView.itemImage setImage:[UIImage imageNamed:@"DefaultMartImage"]];
        descriptionView.itemImage.contentMode = UIViewContentModeScaleAspectFill;
    }else{
        __weak typeof(descriptionView) weakDescriptionView = descriptionView;
        [descriptionView.itemImage setImageWithURLCached:self.clickedItem.imageURLString completed:^(UIImage *image) {
            if([image isProductSingleShot]){
                [weakDescriptionView.itemImage setContentMode:UIViewContentModeScaleAspectFit];
                [weakDescriptionView.itemImage setBackgroundColor:[image averageCornerColors]];
            }else{
                [weakDescriptionView.itemImage setContentMode:UIViewContentModeScaleAspectFill];
            }
        }];
    }
    descriptionView.martNameLabel.text = self.parentMart.name;
    descriptionView.itemName.text = self.clickedItem.itemName;
    descriptionView.itemDescription.text = self.clickedItem.itemDescription;
    if(self.clickedItem.price){
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *decimalNumber = [NSNumber numberWithInteger:self.clickedItem.price];
        NSString *formattedNumberString = [decimalFormatter stringFromNumber:decimalNumber];
        descriptionView.itemPrice.text = [NSString stringWithFormat:@"%@원", formattedNumberString];
    }else{
        descriptionView.itemPrice.hidden = YES;
        descriptionView.priceDescriptionLabel.hidden = YES;
    }
    itemImageViewFrame = descriptionView.itemImage.frame;
    [descriptionView setNeedsDisplay];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIColor *borderColor = [UIColor colorWithRed:200/255.0f green:201/255.0f blue:202/255.0f alpha:1];
    [descriptionView.itemImage drawBorder:HCUIBordersBottom withColor:borderColor width:0.5];
    [self.footerView drawBorder:HCUIBordersTop withColor:borderColor width:0.5];
    [self updateViewHierarchy];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.parentMart.rawFlyerURLString) {
        [webView loadRequest:[[NSString stringWithFormat:@"%@/app/image/#%@", kHMDefaultURL, self.parentMart.rawFlyerURLString] URLRequest]];
    }else{
        [webView loadRequest:[[NSString stringWithFormat:@"%@/app/detail/#%ld", kHMDefaultURL, self.clickedItem.itemId] URLRequest]];
    }
    [[HMKinsightSession shared] tagScreen:@"상품상세보기"];
    SET_KADATA = @{
                   @"사용자 나이":[KA userBirthYear],
                   @"사용자 성별":[KA userGenderString],
                   @"현위치와 마켓사이 거리":[KA distanceOfMart:self.parentMart],
                   @"마켓 조회패턴":[KA patternStringForNear:[KA isMartNear] favorite:[KA isMartFavorite]]
                   };
    SEND_KA_ @"상품상세 조회" _EVENT;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollOffset = scrollView.contentOffset.y;
    if(scrollOffset + kDetailViewHeight <= 0){
        HMLog(HMLogIgnorable, @"%f", scrollOffset + kDetailViewHeight);
        CGRect targetFrame = itemImageViewFrame;
        targetFrame.origin.y += scrollOffset;
        targetFrame.size.height -= scrollOffset;
        [descriptionView.itemImage setFrame:targetFrame];
    }
    if(scrollOffset >= -(kDetailTabHeight)){
        CGRect updatedFrame = CGRectMake(0, scrollOffset - kDetailViewHeight, screenWidth, (kDetailTabHeight + kDetailViewHeight));
        [descriptionView setFrame:updatedFrame];
    }else{
        [descriptionView setFrame:CGRectMake(0,-(kDetailTabHeight + kDetailViewHeight),screenWidth,kDetailViewHeight + kDetailTabHeight)];
    }
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
