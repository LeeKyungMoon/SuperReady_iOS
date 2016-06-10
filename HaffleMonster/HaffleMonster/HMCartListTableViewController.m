//  HMCartListTableViewController.m
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 27..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMCartListTableViewController.h"
#import "CartList.h"

@interface HMCartListTableViewController ()

@end

@implementation HMCartListTableViewController

- (IBAction)completeButton:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteButton{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"모든 관심상품(들)을 비우시겠습니까?"
                           delegate:self
                           cancelButtonTitle:@"취소"
                           destructiveButtonTitle:@"비우기"
                           otherButtonTitles:nil];
    [menu showInView:self.view];
}
- (void)completeButton{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}
- (void)reloadTableViewData{
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self readyForOneDayLeftNotification];
    [[HMKinsightSession shared] tagScreen:@"관심상품목록"];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 8, 0)];
    self.userCart = [[SRDatabase db] fetchUserCart];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // LOGGING HMLog(HMLogIgnorable, @"cartlist viewdidload");
    
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:(222/255.0) green:(20/255.0) blue:(30/255.0) alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    UIImage *deleteImage = [UIImage imageNamed:@"usercart_navi_btn_delete"];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spacer setWidth:-8.0];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithImage:deleteImage style:UIBarButtonItemStylePlain target:self action:@selector((deleteButton))];
    self.navigationItem.leftBarButtonItems=@[spacer, deleteItem];
    
    UIImage *completeImage = [UIImage imageNamed:@"usercart_card_btn_cancel"];
    UIBarButtonItem *completeItem = [[UIBarButtonItem alloc] initWithImage:completeImage style:UIBarButtonItemStylePlain target:self action:@selector((completeButton))];
    self.navigationItem.rightBarButtonItems=@[spacer, completeItem];
    self.userCart = [[SRDatabase db] fetchUserCart];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"취소"]){
        // LOGGING HMLog(HMLogIgnorable, @"액션시트 취소");
    }else{
        // LOGGING HMLog(HMLogIgnorable, @"액션시트 비우기");
        int timesaleCampaigns = 0;
        int generalCampaigns = 0;
        int timeOverCampaigns = 0;
        int timeLeftCampaigns = 0;
        for(HMUserCartItem *item in self.userCart.userCart){
            if(item.campaignType == SRCampaignTypeTimeSale){
                timesaleCampaigns++;
            }else{
                generalCampaigns++;
            }
            if([item.campaignEndDate timeIntervalSinceNow] < 0){
                timeOverCampaigns++;
            }else{
                timeLeftCampaigns++;
            }
        }
        SET_KADATA = @{
                       @"특가상품 갯수":@(timesaleCampaigns),
                       @"일반상품 갯수":@(generalCampaigns),
                       @"캠페인 기간 끝난 상품 갯수":@(timeOverCampaigns),
                       @"캠페인 기간 남은 상품 갯수":@(timeLeftCampaigns)
                       };
        SEND_KA_ @"관심상품 비우기" _EVENT;
        [[SRDatabase db] emptyUserCart];
        HMUserCart *eliminatedCart = [[SRDatabase db] fetchUserCart];
        self.userCart.userCart = eliminatedCart.userCart;
        [self.tableView reloadData];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([self.userCart.userCart count]==0) {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        UIImageView *noCartImageView = [[UIImageView alloc] init];
        [noCartImageView setImage:[UIImage imageNamed:@"NoUserCartItem"]];
        noCartImageView.contentMode = UIViewContentModeCenter;
        self.tableView.backgroundView = noCartImageView;
        return 0;
    }else{
        NSInteger rowCount = [self.userCart.userCart count];
        //// LOGGING HMLog(HMLogIgnorable, @"cart count : %d",rowCount);
        if ((rowCount%2)==0) {
            self.isEvenAtCart = YES;
            return [self.userCart.userCart count]/2;
        }else{
            self.isEvenAtCart = NO;
            
            return [self.userCart.userCart count]/2+1;
        }
    }
};


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.userCart.userCart count]!=0){
        HMCartListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CART_CELL" forIndexPath:indexPath];
        if (indexPath.row * 2 + 1 == [self.userCart.userCart count]) {
            cell.oddParentCampaign = (SRCampaign*)[self.userCart.parentCampaigns objectAtIndex:indexPath.row*2];
            cell.oddParentMart = (SRMarket*)[self.userCart.parentMarts objectAtIndex:indexPath.row*2];
            HMUserCartItem *oddItem = (HMUserCartItem*)[self.userCart.userCart objectAtIndex:indexPath.row*2];
            SRGood *oddItemOfCart = [[SRGood alloc] initWithCartItem:oddItem];
            cell.oddItem = oddItemOfCart;
            
            if (oddItem.imageURL.length == 0) {
                [cell.oddImage setImage:[UIImage imageNamed:@"DefaultMartImage"]];
                cell.oddImage.contentMode = UIViewContentModeScaleAspectFill;
            }else{
                [cell.oddImage setImageWithURLCached:oddItem.imageURL placeholderImage:nil];
            }
            [cell.oddImage setImageWithURLCached:oddItem.imageURL placeholderImage:nil];
            cell.oddItemName.text = oddItem.itemName;
            cell.oddItemDescription.text = oddItem.itemDescription;
            
            if (cell.oddParentCampaign.isExpired) {
                cell.oddPrice.text = [NSString stringWithFormat:@"행사종료"];
            }else if(oddItem.itemPrice == 0){
                cell.oddPrice.hidden = YES;
            }else{
                NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
                decimalFormatter.numberStyle=NSNumberFormatterDecimalStyle;
                NSNumber *decimalNumber = [NSNumber numberWithInteger:oddItem.itemPrice];
                NSString *formattedNumberString = [decimalFormatter stringFromNumber:decimalNumber];
                cell.oddPrice.text = [NSString stringWithFormat:@"%@원",formattedNumberString];
            }

            cell.oddMartName.text = oddItem.martName;
            cell.oddUserCartItem = oddItem;
            [cell.oddDeleteButton setImage:[UIImage imageNamed:@"usercart_card_btn_cancel"] forState:UIControlStateNormal];

            cell.evenMasterView.alpha = 0;


            UITapGestureRecognizer *oddDeleteRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(oddDeleteTap:)];
            [cell.oddDeleteButton addGestureRecognizer:oddDeleteRecognizer];
            
            UITapGestureRecognizer *oddDetailRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(oddDetailTap:)];
            [cell.oddMasterView addGestureRecognizer:oddDetailRecognizer];
            // LOGGING HMLog(HMLogIgnorable, @"마지막 ROW");
        }else{
            cell.oddParentCampaign = (SRCampaign*)[self.userCart.parentCampaigns objectAtIndex:indexPath.row*2];
            cell.oddParentMart = (SRMarket*)[self.userCart.parentMarts objectAtIndex:indexPath.row*2];
            HMUserCartItem *oddItem = (HMUserCartItem*)[self.userCart.userCart objectAtIndex:indexPath.row*2];
            SRGood *oddItemOfCart = [[SRGood alloc] initWithCartItem:oddItem];
            cell.oddItem = oddItemOfCart;
            
            HMUserCartItem *evenItem = (HMUserCartItem*)[self.userCart.userCart objectAtIndex:indexPath.row*2+1];
            SRGood *evenItemOfCart = [[SRGood alloc] initWithCartItem:evenItem];
            cell.evenParentCampaign = (SRCampaign*)[self.userCart.parentCampaigns objectAtIndex:indexPath.row*2+1];
            cell.evenParentMart = (SRMarket*)[self.userCart.parentMarts objectAtIndex:indexPath.row*2+1];
            cell.evenItem = evenItemOfCart;
            
            if (oddItem.imageURL.length == 0) {
                [cell.oddImage setImage:[UIImage imageNamed:@"DefaultMartImage"]];
                cell.oddImage.contentMode = UIViewContentModeScaleAspectFill;
            }else{
                [cell.oddImage setImageWithURLCached:oddItem.imageURL completed:^(UIImage *image) {
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

            if (cell.oddParentCampaign.isExpired) {
                cell.oddPrice.text = [NSString stringWithFormat:@"행사종료"];
            }else if(oddItem.itemPrice == 0){
                cell.oddPrice.hidden = YES;
            }else{
                NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
                decimalFormatter.numberStyle=NSNumberFormatterDecimalStyle;
                NSNumber *decimalNumber = [NSNumber numberWithInteger:oddItem.itemPrice];
                NSString *formattedNumberString = [decimalFormatter stringFromNumber:decimalNumber];
                cell.oddPrice.text = [NSString stringWithFormat:@"%@원",formattedNumberString];
            }
            
            cell.oddMartName.text = oddItem.martName;
            
            if (evenItem.imageURL.length == 0) {
                [cell.evenImage setImage:[UIImage imageNamed:@"DefaultMartImage"]];
                cell.evenImage.contentMode = UIViewContentModeScaleAspectFill;
            }else{
                [cell.evenImage setImageWithURLCached:evenItem.imageURL completed:^(UIImage *image) {
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
            
            if (cell.evenParentCampaign.isExpired) {
                cell.evenPrice.text = [NSString stringWithFormat:@"행사종료"];
            }else if(evenItem.itemPrice == 0){
                cell.evenPrice.hidden = YES;
            }else{
                NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
                decimalFormatter.numberStyle=NSNumberFormatterDecimalStyle;
                NSNumber *decimalNumber = [NSNumber numberWithInteger:evenItem.itemPrice];
                NSString *formattedNumberString = [decimalFormatter stringFromNumber:decimalNumber];
                cell.evenPrice.text = [NSString stringWithFormat:@"%@원",formattedNumberString];
            }

            cell.evenMartName.text = evenItem.martName;

            cell.oddUserCartItem = oddItem;
            cell.evenUserCartItem = evenItem;

            [cell.oddDeleteButton setImage:[UIImage imageNamed:@"usercart_card_btn_cancel"] forState:UIControlStateNormal];
            [cell.evenDeleteButton setImage:[UIImage imageNamed:@"usercart_card_btn_cancel"] forState:UIControlStateNormal];
            UITapGestureRecognizer *oddDeleteRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(oddDeleteTap:)];
            [cell.oddDeleteButton addGestureRecognizer:oddDeleteRecognizer];
            UITapGestureRecognizer *evenDeleteRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(evenDeleteTap:)];
            [cell.evenDeleteButton addGestureRecognizer:evenDeleteRecognizer];
            
            UITapGestureRecognizer *oddDetailRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(oddDetailTap:)];
            [cell.oddMasterView addGestureRecognizer:oddDetailRecognizer];
            UITapGestureRecognizer *evenDetailRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(evenDetailTap:)];
            [cell.evenMasterView addGestureRecognizer:evenDetailRecognizer];
            cell.evenMasterView.alpha = 1;
        }
        return cell;
        // Configure the cell...
    }else{
        return nil;
    }
}

- (void)oddDetailTap:(UITapGestureRecognizer *)recognizer{
    HMCartListItemCell *cell = (HMCartListItemCell *)recognizer.view.superview.superview.superview;
    HMGoodsDetailViewController *goodsDetail = [[HMGoodsDetailViewController alloc] init];
    goodsDetail.clickedItem = cell.oddItem;
    goodsDetail.parentCampaign = cell.oddParentCampaign;
    goodsDetail.parentMart = cell.oddParentMart;
    [self.navigationController pushViewController:goodsDetail animated:YES];
}
- (void)evenDetailTap:(UITapGestureRecognizer *)recognizer{
    HMCartListItemCell *cell = (HMCartListItemCell *)recognizer.view.superview.superview.superview;
    HMGoodsDetailViewController *goodsDetail = [[HMGoodsDetailViewController alloc] init];
    goodsDetail.clickedItem = cell.evenItem;
    goodsDetail.parentCampaign = cell.evenParentCampaign;
    goodsDetail.parentMart = cell.evenParentMart;
    [self.navigationController pushViewController:goodsDetail animated:YES];
}
- (void)oddDeleteTap:(UITapGestureRecognizer *)recognizer{
    UIImage *confirmImage = [UIImage imageNamed:@"usercart_card_btn_trash"];
    NSData *confirmData = UIImagePNGRepresentation(confirmImage);
    UIButton *deleteButton=(UIButton *)recognizer.view;
    UIImage *deleteImage = deleteButton.imageView.image;
    NSData *deleteImageData = UIImagePNGRepresentation(deleteImage);
    
    if ([deleteImageData isEqualToData:confirmData]) {
        HMCartListItemCell *deletedCell = (HMCartListItemCell *)deleteButton.superview.superview.superview.superview;
        [[SRDatabase db] cancelNotificationForUserCartItem:deletedCell.oddUserCartItem];
        [[SRDatabase db] deleteUserCartItem:deletedCell.oddUserCartItem];
        HMUserCart *editedCart = [[SRDatabase db] fetchUserCart];
        self.userCart.userCart = editedCart.userCart;
        [deleteButton setImage:deleteImage forState:UIControlStateNormal];
        [self.tableView reloadData];
        [self sendDeletedUserCartItemKA:deletedCell.oddUserCartItem];

    }else{
        [deleteButton setImage:confirmImage forState:UIControlStateNormal];
    }

}
- (void)evenDeleteTap:(UITapGestureRecognizer *)recognizer{
    UIImage *confirmImage = [UIImage imageNamed:@"usercart_card_btn_trash"];
    NSData *confirmData = UIImagePNGRepresentation(confirmImage);
    UIButton *deleteButton=(UIButton *)recognizer.view;
    UIImage *deleteImage = deleteButton.imageView.image;
    NSData *deleteImageData = UIImagePNGRepresentation(deleteImage);
    
    if ([deleteImageData isEqualToData:confirmData]) {
        HMCartListItemCell *deletedCell = (HMCartListItemCell *)deleteButton.superview.superview.superview.superview;
        [[SRDatabase db] cancelNotificationForUserCartItem:deletedCell.evenUserCartItem];
        [[SRDatabase db] deleteUserCartItem:deletedCell.evenUserCartItem];
        HMUserCart *editedCart = [[SRDatabase db] fetchUserCart];
        self.userCart.userCart = editedCart.userCart;
        [self.tableView reloadData];
        [self sendDeletedUserCartItemKA:deletedCell.evenUserCartItem];
    }else{
        [deleteButton setImage:confirmImage forState:UIControlStateNormal];
    }

}

- (void)sendDeletedUserCartItemKA:(HMUserCartItem*)item {
    SET_KADATA = @{
                   @"삭제한 뷰":@"관심뷰",
                   @"앱 실행 횟수":[KA appLaunchCount],
                   @"가격":@(item.itemPrice),
                   @"캠페인 유형":item.campaignType == SRCampaignTypeTimeSale ? @"특가" : @"일반",
                   @"캠페인 남은 시간":@((int)([item.campaignEndDate timeIntervalSinceNow]) / 60 / 60)
                   };
    SEND_KA_ @"관심상품 삭제" _EVENT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSUInteger)rowForItemId:(NSUInteger)itemId{
    NSUInteger result = 0;
    BOOL isEven = false;
    for(HMUserCartItem *item in self.userCart.userCart){
        if(item.itemId == itemId){
            return result;
        }else{
            if(isEven){
                result ++;
                isEven = false;
            }else{
                isEven = true;
            }
        }
    }
    return result;
}

- (void)readyForOneDayLeftNotification{
    [[HMShareManager manager] oneDayLeftAction:^(NSUInteger userCartItemId) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self rowForItemId:userCartItemId] inSection:0];
        [[HMShareManager manager] clear];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        });
    }];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end