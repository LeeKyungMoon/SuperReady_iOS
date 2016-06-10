//
//  HMGoodsTableViewController.m
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 25..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMGoodsTableViewController.h"

@interface HMGoodsTableViewController ()
@property NSString *goodsURL;
@property float webViewHeight;
@end

@implementation HMGoodsTableViewController

- (IBAction)requestMart:(id)sender {
    NSLog(@"클릭");
    //HMLog(HMLogImportant, @"마트 요청 버튼 클릭!");
}


- (IBAction)martMap:(id)sender {
    HMYakdoViewController *yakdo = [[HMYakdoViewController alloc] initWithMarket:self.selectedMarket];
    yakdo.selfLatitude = self.selfLatitude;
    yakdo.selfLongitude = self.selfLongitude;
    [self.navigationController pushViewController:yakdo animated:YES];
}
- (IBAction)martPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.selectedMart.phone]]];
}

- (void)updatingCampaginsFromServer{
    
#warning TODO: 페이징 처리
    
    [[SRAPIManager manager] campaignsForMarket:self.selectedMarket action:^(NSArray *campaigns) {
        self.selectedMarket.campaigns = campaigns;
        [SVProgressHUD dismiss];
        
        if (error) {
            HMLog(HMLogImportant, @"전단뷰 네트워크 에러 : %@",error);
        }else{
            switch (self.selectedMart.APIstate) {
                case HMAPIStateSuccess:
                {
                    self.bargainCampaigns = self.selectedMart.timesaleCampaigns;
                    self.generalCampaigns = self.selectedMart.normalCampaigns;
                    self.rawFlyerCampaigns = self.selectedMart.rawFlyerCampaigns;
                    
                    __block int finalCount = 0;
                    void (^finishAction)() = ^{
                        finalCount++;
                        if(finalCount == self.generalCampaigns.count + self.bargainCampaigns.count + self.rawFlyerCampaigns.count){
                            [SVProgressHUD dismiss];
                            self.bargainItems =[[NSMutableArray alloc] init];
                            self.generalItems = [[NSMutableArray alloc] init];
                            self.rawFlyerItems = [[NSMutableArray alloc] init];
                            for(SRCampaign *campaign in self.generalCampaigns){
                                for(SRGood *item in campaign.items){
                                    [self.generalItems addObject:item];
                                }
                            }
                            for(SRCampaign *campaign in self.bargainCampaigns){
                                for(SRGood *item in campaign.items){
                                    [self.bargainItems addObject:item];
                                }
                            }
                            for(SRCampaign *campaign in self.rawFlyerCampaigns){
                                for(SRGood *item in campaign.items){
                                    [self.rawFlyerItems addObject:item];
                                    self.selectedMart.rawFlyerURLString = item.imageURLString;
                                }
                            }
                            
                            if ([self.bargainItems count] == 0 && [self.generalItems count] == 0 && [self.rawFlyerItems count] == 0) {
                                isNoItem = YES;
                            }
                        }
                    };
                    
                    for(SRCampaign *campaign in self.generalCampaigns){
                        [[HMAPIRequestManager manager] goodsForCampaign:campaign action:^(){
                            finishAction();
                        }];
                    }
                    for(SRCampaign *campaign in self.bargainCampaigns){
                        [[HMAPIRequestManager manager] goodsForCampaign:campaign action:^(){
                            finishAction();
                        }];
                    }
                    for(SRCampaign *campaign in self.rawFlyerCampaigns){
                        [[HMAPIRequestManager manager] goodsForCampaign:campaign action:^(){
                            finishAction();
                        }];
                    }
                    [self.tableView reloadData];
                }
                    break;
                default:
                {
                    self.bargainCampaigns = [[NSMutableArray alloc] init];
                    self.generalCampaigns = [[NSMutableArray alloc] init];
                    isNoItem = YES;
                }
                    break;
            }
        }
    }];
}
- (void)bargainCellTap:(UITapGestureRecognizer *)recognizer {
    HMGoodsDetailViewController *goodsDetail = [[HMGoodsDetailViewController alloc] init];
    HMGoodsBargainTableViewCell *cell = (HMGoodsBargainTableViewCell*)recognizer.view.superview.superview;
    goodsDetail.clickedItem = cell.item;
    goodsDetail.parentCampaign = cell.campaign;
    goodsDetail.parentMart = self.selectedMart;
    [self.navigationController pushViewController:goodsDetail animated:YES];
}
- (void)evenCellTap:(UITapGestureRecognizer *)recognizer {
    HMGoodsDetailViewController *goodsDetail = [[HMGoodsDetailViewController alloc] init];
    HMGoodsGeneralTableViewCell *cell = (HMGoodsGeneralTableViewCell*)recognizer.view.superview.superview.superview;
    goodsDetail.clickedItem = cell.evenItem;
    goodsDetail.parentCampaign = cell.evenCampaign;
    goodsDetail.parentMart = self.selectedMart;
    [self.navigationController pushViewController:goodsDetail animated:YES];

}
- (void)oddCellTap:(UITapGestureRecognizer *)recognizer {
    HMGoodsDetailViewController *goodsDetail = [[HMGoodsDetailViewController alloc] init];
    HMGoodsGeneralTableViewCell *cell = (HMGoodsGeneralTableViewCell*)recognizer.view.superview.superview.superview;
    goodsDetail.clickedItem = cell.oddItem;
    goodsDetail.parentCampaign = cell.oddCampaign;
    goodsDetail.parentMart = self.selectedMart;
    [self.navigationController pushViewController:goodsDetail animated:YES];
}

- (void)popOutCurrentView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [SVProgressHUD dismiss];
    }
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    [(HMMainNavigationController*)(self.navigationController) updateCartButton];
    [self readyForKakaoAction];
    [[HMKinsightSession shared] tagScreen:@"전단상품목록"];
    [[HMKakaoAnalytics manager] distanceOfMart:self.selectedMart];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 8, 0)];
}
- (void)reloadTableViewData{
     [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isKakaoChecked = NO;
    isNoItem = NO;
    martPanoramaFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] - 44);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(reloadTableViewData)
                                                userInfo:nil
                                                 repeats:YES ];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [SVProgressHUD show];
    [self updatingCampaginsFromServer];

    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 28)];
    [titleLabel setTextColor:[UIColor colorWithRed:(255/255.f) green:(66/255.f) blue:(55/255.f) alpha:1.0f]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth=true;
    UINib *rawFlyerCellNib = [UINib nibWithNibName:@"HMGoodsRawFlyerTableViewCell" bundle:nil];
    [self.tableView registerNib:rawFlyerCellNib forCellReuseIdentifier:@"RawFlyerTableViewCell"];

    switch (self.martNameState) {
        case SRMarketNameWithLogo:{
            UIView *temporaryView = [[UIView alloc] initWithFrame:CGRectMake(0,0,150,22)];
            UIImageView *titleView = [[UIImageView alloc] initWithFrame:temporaryView.frame];
            titleView.contentMode = UIViewContentModeScaleAspectFit;
            [titleView setImageWithURLCached:[self.selectedMart.logo stringByAppendingString:@"@white"] placeholderImage:nil];
            [temporaryView addSubview:titleView];
            self.navigationItem.titleView = temporaryView;
            break;
        }
        case SRMarketNameWithBrand:{
            NSString *titleText = self.selectedMart.brand.name;
            self.navigationItem.title = titleText;
            break;
        }
        case SRMarketNameWithName:{
            NSString *titleText=self.selectedMart.name;
            self.navigationItem.title = titleText;
            break;
        }
        default:{
            NSString *titleText=self.selectedMart.name;
            self.navigationItem.title = titleText;
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ([[UIScreen mainScreen] bounds].size.height - 80) / 2;
    }else if(indexPath.section == 1 || indexPath.section == 2){
        return ([[UIScreen mainScreen] bounds].size.height - 72) / 2;
    }else{
        return 244;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        //NSLog(@"%d",[self.rawFlyerItems count]);

        if (isNoItem || [self.rawFlyerItems count] != 0) {
            return 1;
        }else{
            return 0;
        }
    }
    else if(section == 2){
        //NSLog(@"%d",[self.bargainItems count]);
        return [self.bargainItems count];
    }else{
        //NSLog(@"%d",[self.generalItems count]);
        if ([self.generalItems count]%2==0) {
            return [self.generalItems count]/2;
        }else{
            return [self.generalItems count]/2+1;
        }
    }
}
- (NSString *)updateLabel:(id)sender :(SRCampaign*)campaign{
    HMTimeLeft timeLeft =[campaign campaignTimeLeftFromNow:campaign.endDate];

    NSString *timeLeftString;
    switch (timeLeft.timeLeftType) {
        case HMTimeLeftWithDays:
            switch (timeLeft.days) {
                case 1:
                    timeLeftString = [NSString stringWithFormat:@"하루 남음"];
                    break;
                case 2:
                    timeLeftString = [NSString stringWithFormat:@"이틀 남음"];
                    break;
                case 0:
                    timeLeftString = [NSString stringWithFormat:@"%d시간 %d분 %d초 남음",timeLeft.hours,timeLeft.minutes,timeLeft.seconds];
                default:
                    timeLeftString = [NSString stringWithFormat:@"%d일 남음",timeLeft.days];
                    break;
            }
            break;
        case HMTimeLeftWithHours:
            if (timeLeft.hours == 0) {
                timeLeftString = [NSString stringWithFormat:@"%d분 %d초 남음",timeLeft.minutes,timeLeft.seconds];
            }else{
                timeLeftString = [NSString stringWithFormat:@"%d시간 %d분 %d초 남음",timeLeft.hours,timeLeft.minutes,timeLeft.seconds];
            }
            break;
        case HMTimeLeftWithMinutes:
            if (timeLeft.minutes == 0) {
                timeLeftString = [NSString stringWithFormat:@"%d초 남음",timeLeft.seconds];
            }else{
                timeLeftString =  [NSString stringWithFormat:@"%d분 %d초 남음",timeLeft.minutes,timeLeft.seconds];
            }
            break;
        case HMTimeLeftWithSeconds:
            if (timeLeft.seconds == 0) {
                timeLeftString = [NSString stringWithFormat:@"행사가 만료되었습니다"];
            }else{
                timeLeftString = [NSString stringWithFormat:@"%d초 남음",timeLeft.seconds];
            }
            break;
        case HMTimeLeftNone :
            timeLeftString = [NSString stringWithFormat:@"행사가 만료되었습니다"];
    }
    return timeLeftString;
}

- (SRCampaign *)campaignOfItem:(NSMutableArray *)campaigns :(NSInteger)indexpathRow :(SRCampaignType)campaignType :(BOOL)isEven{
    SRCampaign *destinationCampaign;
    NSInteger rowCount;
    NSInteger countOfCampaigns = [campaigns count];
    NSInteger accumulativeCountsOfItems[countOfCampaigns];
    
    for (NSInteger camp_cnt = 0; countOfCampaigns > camp_cnt; camp_cnt++) {
        SRCampaign *campaign = [campaigns objectAtIndex:camp_cnt];
        NSInteger countOfItem = [campaign.items count];
        if (camp_cnt == 0) {
            accumulativeCountsOfItems[0] = countOfItem;
        }else{
            NSInteger beforeSumCount = accumulativeCountsOfItems[camp_cnt - 1];
            accumulativeCountsOfItems[camp_cnt] = beforeSumCount + countOfItem;
        }
    }
    
    if (campaignType == SRCampaignTypeTimeSale) {
        rowCount = indexpathRow + 1;
        for (NSInteger cnt = 0; countOfCampaigns > cnt; cnt++) {
            if (accumulativeCountsOfItems[cnt] >= rowCount) {
                destinationCampaign = [campaigns objectAtIndex:cnt];
                break;
            }
        }
        if (destinationCampaign) {
            return destinationCampaign;
        }
        return  nil;
    }else{
        if (isEven) {
            rowCount = (indexpathRow+1) * 2;
        }else{
            rowCount = (indexpathRow+1);
        }
        
        for (NSInteger cnt = 0; countOfCampaigns > cnt; cnt++) {
            if (accumulativeCountsOfItems[cnt] >= rowCount) {
                destinationCampaign = [campaigns objectAtIndex:cnt];
                break;
            }
        }
        
        if (destinationCampaign) {
            return destinationCampaign;
        }
        return nil;
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollOffset = scrollView.contentOffset.y;
    if(scrollOffset <= 0){
        CGRect targetFrame = martPanoramaFrame;
        targetFrame.origin.y += scrollOffset;
        targetFrame.size.height -= scrollOffset;
        [martPanoramaView setFrame:targetFrame];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (!isNoItem) {
            SRGood *rawFlyerItem = [self.rawFlyerItems objectAtIndex:indexPath.row];
            HMRawFlyerWebViewController *rawFlyer = [[HMRawFlyerWebViewController alloc] init];
            rawFlyer.rawFlyerURLString = [NSString stringWithFormat:@"%@/app/image/#%@",kHMDefaultURL,rawFlyerItem.imageURLString];
            HMLog(HMLogImportant, @"%@ : %@",rawFlyerItem.imageURLString,[NSString stringWithFormat:@"%@/app/image/#%@",kHMDefaultURL,rawFlyerItem.imageURLString]);
            [self.navigationController pushViewController:rawFlyer animated:YES];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        HMGoodsMartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"martCell" forIndexPath:indexPath];
        if (self.selectedMart.panorama.length == 0) {
            [cell.panorama setImage:[UIImage imageNamed:@"DefaultMartImage"]];
            cell.panorama.contentMode = UIViewContentModeScaleAspectFill;
        }else{
            [cell.panorama  setImageWithURLCached:self.selectedMart.panorama placeholderImage:nil];
        }
        martPanoramaView = cell.panorama;
        cell.martDescription.text=self.selectedMart.description;
        cell.businessHour.text = self.selectedMart.businessHours;
        return cell;
    }else if(indexPath.section==1){
        if (isNoItem) {
            HMGoodsBargainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoItemCell" forIndexPath:indexPath];
            return cell;
        }else{
            HMGoodsRawFlyerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RawFlyerTableViewCell" forIndexPath:indexPath];
            SRGood *item = [self.rawFlyerItems objectAtIndex:0];
            [cell.rawFlyerImageView setImageWithURLCached:item.imageURLString completed:^(UIImage *image) {
                [cell.rawFlyerImageView setContentMode:UIViewContentModeScaleAspectFit];
                [cell.rawFlyerImageView setBackgroundColor:[image averageCornerColors]];
            }];
            return cell;
        }
    }else if(indexPath.section == 2){
        HMGoodsBargainTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"bargainCell" forIndexPath:indexPath];
        UITapGestureRecognizer *bargainCellRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(bargainCellTap:)];
        [cell.masterView addGestureRecognizer:bargainCellRecognizer];
        
        SRGood *bargainItem = [self.bargainItems objectAtIndex:indexPath.row];
        cell.item = bargainItem;
        
        cell.itemId = bargainItem.itemId;
        [cell.image setImageWithURLCached:bargainItem.imageURLString completed:^(UIImage *image) {
            if([image isProductSingleShot]){
                [cell.image setContentMode:UIViewContentModeScaleAspectFit];
            
            cell.campaign = [self campaignOfItem:self.bargainCampaigns :indexPath.row :SRCampaignTypeTimeSale :NO];
            
            NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
            decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *decimalNumber = [NSNumber numberWithInteger:bargainItem.price];
            NSString *formattedNumberString = [decimalFormatter stringFromNumber:decimalNumber];
            
            if (bargainItem.price) {                
                cell.postPrice.text=[NSString stringWithFormat:@"%@원",formattedNumberString];
                cell.postPrice.hidden = NO;
                cell.priceDescription.hidden = NO;
            }else{
                cell.postPrice.hidden = YES;
                cell.priceDescription.hidden = YES;
            }
            
            //[cell setOriginalPrice:bargainItem.originalPrice];
            //[cell setSaleRate:bargainItem.discountRate];
            [cell setEventDescriptionText:bargainItem.eventDescription];
            [cell setSaleRate:bargainItem.discountRate];
            [cell setOriginalPrice:bargainItem.originalPrice];
            
            //cell.postPrice.text=[NSString stringWithFormat:@"%@원",formattedNumberString];
            
            cell.itemName.text=bargainItem.itemName;
            
            cell.itemDescription.text=bargainItem.itemDescription;
            //[cell.itemDescription sizeToFit];
            cell.timeLeftLabel.text = [self updateLabel:self.timer :cell.campaign];
            
            if ([[SRDatabase db] isItemInUserCart:cell.item]) {
                [cell.cartButton setImage:[UIImage imageNamed:@"full_likecircle"] forState:UIControlStateNormal];
            }else{
                [cell.image setContentMode:UIViewContentModeScaleAspectFill];
            }
        }];
        
        cell.campaign = [self campaignOfItem:self.bargainCampaigns :indexPath.row :SRCampaignTypeTimeSale :NO];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *decimalNumber = [NSNumber numberWithInteger:bargainItem.price];
        NSString *formattedNumberString = [decimalFormatter stringFromNumber:decimalNumber];
        
        if (bargainItem.price) {
            cell.postPrice.text=[NSString stringWithFormat:@"%@원",formattedNumberString];
            cell.postPrice.hidden = NO;
            cell.priceDescription.hidden = NO;
        }else{
            cell.postPrice.hidden = YES;
            cell.priceDescription.hidden = YES;
        }
        //cell.postPrice.text=[NSString stringWithFormat:@"%@원",formattedNumberString];
        
        cell.itemName.text=bargainItem.itemName;
        
        cell.itemDescription.text=bargainItem.itemDescription;
        //[cell.itemDescription sizeToFit];
        cell.timeLeftLabel.text = [self updateLabel:self.timer :cell.campaign];
        
        if ([[SRDatabase db] isItemInUserCart:cell.item]) {
            [cell.cartButton setImage:[UIImage imageNamed:@"full_likecircle"] forState:UIControlStateNormal];
        }else{
            [cell.cartButton setImage:[UIImage imageNamed:@"likecircle"] forState:UIControlStateNormal];
        }
        return cell;
    }else{
        HMGoodsGeneralTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"generalCell" forIndexPath:indexPath];
        cell.oddCampaign = [self campaignOfItem:self.generalCampaigns :indexPath.row :SRCampaignTypeNormal :NO];
        UITapGestureRecognizer *evenCellRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(evenCellTap:)];
        UITapGestureRecognizer *oddCellRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(oddCellTap:)];
        [cell.oddMasterView addGestureRecognizer:oddCellRecognizer];
        [cell.evenMasterView addGestureRecognizer:evenCellRecognizer]; // 일반전단상품 뷰 클릭 시 상세정보로 이동하는 이벤트걸기
        // 하나의 TapGestureRecognizer 객체에 다 넣으면 마지막에 넣은 뷰만 이벤트가 걸림 그래서 따로 이벤트를 줌! -경문
        SRGood *oddItem = [self.generalItems objectAtIndex:indexPath.row * 2];
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *decimalOddNumber = [NSNumber numberWithInteger:oddItem.price];
        NSString *formattedOddNumberString = [decimalFormatter stringFromNumber:decimalOddNumber];
        
        //짝수번째 셀을 채워야하는가의 조건 - 경문
        //짝수번째 셀이 없는 경우 - 경문
        if ((indexPath.row * 2 + 1) == [self.generalItems count]) {
            cell.oddItem = oddItem;
            cell.oddItemId = oddItem.itemId;
            if (oddItem.imageURLString.length == 0) {
                [cell.oddImage setImage:[UIImage imageNamed:@"DefaultMartImage"]];
                cell.oddImage.contentMode = UIViewContentModeScaleAspectFill;
            }else{
                [cell.oddImage setImageWithURLCached:oddItem.imageURLString completed:^(UIImage *image) {
                    if([image isProductSingleShot]){
                        [cell.oddImage setContentMode:UIViewContentModeScaleAspectFit];
                        [cell.oddImage setBackgroundColor:[image averageCornerColors]];
                    }else{
                        [cell.oddImage setContentMode:UIViewContentModeScaleAspectFill];
                    }
                }];
            }
            cell.oddItemName.text = oddItem.itemName;
            cell.oddItemDescription.text = oddItem.itemDescription;
            if(oddItem.price){
                cell.oddPrice.text = [NSString stringWithFormat:@"%@원", formattedOddNumberString];
                cell.oddPrice.hidden = NO;
                cell.oddPriceDescription.hidden = NO;
            }else{
                cell.oddPrice.hidden = YES;
                cell.oddPriceDescription.hidden = YES;
            }
            
            if ([[SRDatabase db] isItemInUserCart:cell.oddItem]) {
                [cell.oddCartButton setImage:[UIImage imageNamed:@"full_likecircle"] forState:UIControlStateNormal];
            }else{
                [cell.oddCartButton setImage:[UIImage imageNamed:@"likecircle" ] forState:UIControlStateNormal];
            }
            
            cell.oddMasterView.tag = 0;
            
            cell.evenMasterView.alpha = 0;
        }else{
            //짝수번째 셀이 있는 경우 - 경문
            cell.oddItem = oddItem;
            
            cell.oddItemId = oddItem.itemId;
            if (oddItem.imageURLString.length == 0) {
                [cell.oddImage setImage:[UIImage imageNamed:@"DefaultMartImage"]];
                cell.oddImage.contentMode = UIViewContentModeScaleAspectFill;
            }else{
                [cell.oddImage setImageWithURLCached:oddItem.imageURLString completed:^(UIImage *image) {
                    if([image isProductSingleShot]){
                        [cell.oddImage setContentMode:UIViewContentModeScaleAspectFit];
                        [cell.oddImage setBackgroundColor:[image averageCornerColors]];
                    }else{
                        [cell.oddImage setContentMode:UIViewContentModeScaleAspectFill];
                    }
                }];
            }
            cell.oddItemName.text = oddItem.itemName;
            cell.oddItemDescription.text = oddItem.itemDescription;
            
            if(oddItem.price){
                cell.oddPrice.text = [NSString stringWithFormat:@"%@원", formattedOddNumberString];
                cell.oddPrice.hidden = NO;
                cell.oddPriceDescription.hidden = NO;
            }else{
                cell.oddPrice.hidden = YES;
                cell.oddPriceDescription.hidden = YES;
            }
            
            [cell setOddEventDescriptionText:oddItem.eventDescription];
            [cell setOddSaleRate:oddItem.discountRate];
            [cell setOddOriginalPrice:oddItem.originalPrice];
            
            
            if ([[SRDatabase db] isItemInUserCart:cell.oddItem]) {
                [cell.oddCartButton setImage:[UIImage imageNamed:@"full_likecircle"] forState:UIControlStateNormal];
            }else{
                [cell.oddCartButton setImage:[UIImage imageNamed:@"likecircle"] forState:UIControlStateNormal];
            }
            
            cell.oddMasterView.tag = 0;
            
            SRGood *evenItem = [self.generalItems objectAtIndex:indexPath.row * 2 + 1];
            cell.evenItem = evenItem;
            cell.evenCampaign = [self campaignOfItem:self.generalCampaigns :indexPath.row :SRCampaignTypeNormal :YES];
            
            cell.evenItemId = evenItem.itemId;
            if (evenItem.imageURLString.length == 0) {
                [cell.evenImage setImage:[UIImage imageNamed:@"defaultMartImage"]];
                cell.evenImage.contentMode = UIViewContentModeScaleAspectFill;
            }else{
                [cell.evenImage setImageWithURLCached:evenItem.imageURLString completed:^(UIImage *image) {
                    if([image isProductSingleShot]){
                        [cell.evenImage setContentMode:UIViewContentModeScaleAspectFit];
                        [cell.evenImage setBackgroundColor:[image averageCornerColors]];
                    }else{
                        [cell.evenImage setContentMode:UIViewContentModeScaleAspectFill];
                    }
                }];
            }
            cell.evenItemName.text = evenItem.itemName;
            cell.evenItemDescription.text = evenItem.itemDescription;
            NSNumber *decimalEvenNumber = [NSNumber numberWithInteger:evenItem.price];
            NSString *formattedEvenNumberString = [decimalFormatter stringFromNumber:decimalEvenNumber];
            
            if(evenItem.price){
                cell.evenPrice.text = [NSString stringWithFormat:@"%@원", formattedEvenNumberString];
                //cell.oddPrice.hidden = NO;
                //cell.oddPriceDescription.hidden = NO;
            }else{
                cell.evenPrice.hidden = YES;
                cell.evenPriceDescription.hidden = YES;
            }
            
            [cell setEvenEventDescriptionText:evenItem.eventDescription];
            [cell setEvenSaleRate:evenItem.discountRate];
            [cell setEvenOriginalPrice:evenItem.originalPrice];
            
            
            if ([[SRDatabase db] isItemInUserCart:cell.evenItem]) {
                [cell.evenCartButton setImage:[UIImage imageNamed:@"full_likecircle"] forState:UIControlStateNormal];
            }else{
                [cell.evenCartButton setImage:[UIImage imageNamed:@"likecircle"] forState:UIControlStateNormal];
            }
            cell.evenMasterView.tag = 1;
            cell.evenMasterView.alpha = 1;
        }
        return cell;
    }

}


- (NSIndexPath*)indexPathForItemId :(NSUInteger)itemId{
    NSUInteger result = 0;
    
    for(SRCampaign *campaign in self.bargainCampaigns){
        for (SRGood *item in campaign.items) {
            if(item.itemId == itemId){
                return [NSIndexPath indexPathForRow:result inSection:1];
            }else{
                result ++;
            }
        }
    }
    BOOL isEven = NO;
    result = 0;
    
    for(SRCampaign *campaign in self.generalCampaigns){
        for(SRGood *item in campaign.items){
            if(item.itemId == itemId){
                return [NSIndexPath indexPathForRow:result inSection:2];
            }else{
                if(isEven){
                    result++;
                }
                isEven = !isEven;
            }
        }
    }
    return nil;
}

- (void)readyForKakaoAction{
    [[HMShareManager manager] sharedAction:^(NSUInteger itemId, NSUInteger martId) {
        NSIndexPath *indexPath = [self indexPathForItemId:itemId];
        isKakaoChecked = YES;
        [[HMShareManager manager] clear];
        if(indexPath == nil) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            SET_KADATA = @{
                           @"앱 실행 횟수":[KA appLaunchCount],
                           @"현위치와 마켓사이 거리":[KA distanceOfMart:self.selectedMart],
                           @"사용자 나이":[KA userBirthYear],
                           @"사용자 성별":[KA userGenderString]
                           };
            SEND_KA_ @"카카오링크 조회" _EVENT;
        });
    }];
}

@end
