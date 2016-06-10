//
//  HMGoodsDetailTableViewController.m
//  HaffleMonster
//
//  Created by 이경문 on 2015. 4. 8..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMGoodsDetailTableViewController.h"

@interface HMGoodsDetailTableViewController ()

@end

@implementation HMGoodsDetailTableViewController
- (IBAction)insertItemAtCart:(id)sender {
}
- (IBAction)shareItem:(id)sender {
}

-(void)detailToCartlist:(UIBarButtonItem *)sender{
    
    //perform your action
    
    HMCartListTableViewController *cartList = [[HMCartListTableViewController alloc] init];
    [self presentViewController:cartList animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];    
    NSLog(@"%@",self.clickedItem.itemDescription);
    NSLog(@"%@",self.clickedItem.itemName);
    NSLog(@"%@",self.clickedItem.imageURLString);
    NSLog(@"%lu",(unsigned long)self.clickedItem.price);
    UIImage *btnImage = [UIImage imageNamed:@"backButton"];
    self.navigationItem.leftBarButtonItem.image = btnImage;
    //[self.navigationItem.leftBarButtonItem setImage:btnImage];
    self.navigationItem.title = @"상세정보"; // 상세정보 뷰컨트롤러의 타이틀 텍스트
    /*UIBarButtonItem *cartButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"장바구니"
                                   style:nil
                                   target:self
                                   action:@selector(detailToCartlist:)];
    *///self.navigationItem.rightBarButtonItem = cartButton;

    //self.navigationItem.rightBarButtonItem =
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section==0) {
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0) {
        NSLog(@"section 0");
        //static NSString *CellIdentifier = @"detailUpperCell";
        HMBargainDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailUpperCell" forIndexPath:indexPath];
        //HMBargainDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        NSURL *imageURL = [NSURL URLWithString:self.clickedItem.imageURLString];
        [cell.itemImage setImageWithURL:imageURL];
        cell.itemName.text = self.clickedItem.itemName;
        cell.itemDescription.text = self.clickedItem.itemDescription;
        cell.itemPrice.text = [NSString stringWithFormat:@"%lu원",(unsigned long)self.clickedItem.price];
        
        return cell;
    }else{
        NSLog(@"section 1");

        static NSString *CellIdentifier = @"detailSubCell";
        //HMSubDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        HMSubDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    // Configure the cell...
    
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
