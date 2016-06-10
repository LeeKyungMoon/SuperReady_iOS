//
//  HMGoodsViewController.m
//  HaffleMonster
//
//  Created by LKM on 2015. 6. 5..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMGoodsViewController.h"

@interface HMGoodsViewController ()

@end

@implementation HMGoodsViewController
@synthesize goodsCollectionView = _goodsCollectionView;



- (void)setGoodsCollectionView:(UICollectionView *)goodsCollectionView{
    _goodsCollectionView = goodsCollectionView;
}
- (void)setInitialCondition{
    //네비게이션바
    UIImage *titleImage = [UIImage imageNamed:@"superreadynavigationlogonocart"];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleView;
    
    //콜렉션뷰
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.goodsCollectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:self.flowLayout];
    self.goodsCollectionView.dataSource = self;
    self.goodsCollectionView.delegate = self;
    UINib *bargainNib = [UINib nibWithNibName:@"HMGoodsCollectionViewCell" bundle:nil];
    UINib *generalNib = [UINib nibWithNibName:@"HMGoodsGeneralCollectionViewCell" bundle:nil];
    [self.goodsCollectionView registerNib:bargainNib forCellWithReuseIdentifier:@"GoodsCollectionViewCell"];
    [self.goodsCollectionView registerNib:generalNib forCellWithReuseIdentifier:@"GoodsGeneralCollectionViewCell"];
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 0;
    [self.view addSubview:self.goodsCollectionView];
    //[self.goodsCollectionView registerClass:[HMGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"GoodsCollectionViewCell"];

    //더미 데이터
    self.bargainItems = [[NSMutableArray alloc] init];
    self.generalItems = [[NSMutableArray alloc] init];
    for (int bargain_cnt = 0; 10 > bargain_cnt; bargain_cnt ++) {
        [self.bargainItems addObject:[NSString stringWithFormat:@"bargain %d",bargain_cnt]];
    }
    for (int general_cnt = 0; 7 > general_cnt; general_cnt ++) {
        [self.generalItems addObject:[NSString stringWithFormat:@"general %d",general_cnt]];
    }
}
- (void)updatingCampaginsFromServer{
    [[HMAPIRequestManager manager] loadCampaignsForMart:self.selectedMart action:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            HMLog(HMLogImportant, @"전단뷰 네트워크 에러 : %@",error);
        }else{
            self.bargainCampaigns = self.selectedMart.timesaleCampaigns;
            self.generalCampaigns = self.selectedMart.normalCampaigns;
            self.bargainItems =[[NSMutableArray alloc] init];
            self.generalItems = [[NSMutableArray alloc] init];
            for (NSInteger bar_cnt = 0 ; bar_cnt<[self.bargainCampaigns count];bar_cnt++) {
                SRCampaign *timesaleCampaign = (SRCampaign *)[self.bargainCampaigns objectAtIndex:bar_cnt];
                for (NSInteger item_cnt = 0; [timesaleCampaign.items count] > item_cnt; item_cnt++) {
                    SRGood *item = [timesaleCampaign itemAtIndex:item_cnt];
                    item.parentCampaign = timesaleCampaign;
                    [self.bargainItems addObject:item];
                }
            }
            for (NSInteger gen_cnt = 0 ; gen_cnt<[self.generalCampaigns count];gen_cnt++) {
                SRCampaign *normalsaleCampaign = (SRCampaign *)[self.generalCampaigns objectAtIndex:gen_cnt];
                for (NSInteger item_cnt = 0; [normalsaleCampaign.items count] > item_cnt; item_cnt++) {
                    SRGood *item = [normalsaleCampaign itemAtIndex:item_cnt];
                    item.parentCampaign = normalsaleCampaign;
                    [self.generalItems addObject:item];
                }
            }
            if ([self.bargainItems count] == 0 && [self.generalItems count] == 0) {
                self.isNoItem = YES;
            }
            
            [self.goodsCollectionView reloadData];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[SVProgressHUD show];

    HMLog(HMLogImportant, @"new Collection View Did Load");
    [self setInitialCondition];
    //[self updatingCampaginsFromServer];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger rowNumber;
    if (self.isNoItem) {
        NSLog(@"NoItem");
        return 1;
    }
    switch (section) {
        case 0:
           rowNumber = [self.bargainItems count];
            HMLog(HMLogImportant, @"특가상품 수 :%d",rowNumber);
            break;
        case 1:
            rowNumber = [self.generalItems count];
            HMLog(HMLogImportant, @"일반상품 수 :%d",rowNumber);
            break;
        default:
            HMLog(HMLogImportant, @"Unknown Error With Items");
            rowNumber = 0;
            break;
    }
    return rowNumber;
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isNoItem) {
        HMGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCollectionViewNoItemCell" forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.section == 0) {
        HMGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }else{
        HMGoodsGeneralCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsGeneralCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }
}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HMLog(HMLogImportant, @"아이템 선택됨");
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //([[UIScreen mainScreen] bounds].size.height - 72) / 2 --> 높이
    if (indexPath.section == 0) {
        return CGSizeMake([[UIScreen mainScreen] bounds].size.width, ([[UIScreen mainScreen] bounds].size.height-72) / 2);
    }else{
        return CGSizeMake(([[UIScreen mainScreen] bounds].size.width / 2) , 244);
    }
}
/*
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    // 셀간의 간격 설정
    return UIEdgeInsetsMake(8, 0, 8, 0);
}*/

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
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
