//
//  HMTutorialMainViewController.m
//  SuperReady Tutorial
//
//  Created by Fermata on 2015. 6. 12..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMTutorialMainViewController.h"
#import <sys/utsname.h>

#define kHMTutorialBoxHeightLarge 234
#define kHMTutorialBoxHeightMiddle 210
#define kHMTutorialBoxHeightSmall 180

#define kHMTutorialOutlineOffsetTopSmall -65
#define kHMTutorialOutlineOffsetTopMiddle -36

@interface HMTutorialMainViewController ()

@end

@implementation HMTutorialMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    descriptionCards = [@[] mutableCopy];
    [self addCard:[[HMTutorialDescriptionView alloc] initWithTitle:@"안녕하세요!" description:@"슈퍼레디를 설치해주셔서 감사합니다."]];
    [self addCard:[[HMTutorialDescriptionView alloc] initWithTitle:@"“어머, 이건 꼭 사야해!”" description:@"마음에 드는 상품, 가격을 발견하셨나요?\n관심상품에 추가하시면 행사 마감 전날\n스마트폰으로 알림을 보내드립니다!"]];
    [self addCard:[[HMTutorialDescriptionView alloc] initWithTitle:@"헤헤헷" description:@"하 쓸 내용없다."]];
    for(NSLayoutConstraint *constraint in [nextButton.superview constraints]){
        if(constraint.secondAttribute == NSLayoutAttributeCenterX && (int)constraint.constant == -38){
            nextButtonPosition = constraint;
        }
        if((int)constraint.constant == 278){
            videoFramePosition = constraint;
        }
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    // [self drawContent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNextButton:NO];
    videoFramePosition.constant = [phoneImageView frame].size.width - 28 * 2;
    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    player = [AVPlayer playerWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AppDemo" ofType:@"mov"]]];
    AVPlayerLayer *layer = [[AVPlayerLayer alloc] init];
    [layer setPlayer:player];
    [layer setFrame:CGRectMake(0, 0, videoView.frame.size.width, videoView.frame.size.height)];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoView.layer addSublayer:layer];
    [player play];
}

- (void)showNextButton:(BOOL)animate{
    nextButtonPosition.constant = 0;
    if(animate){
        int delayLayout = prevButton.alpha == 1;
        int delayAlpha = prevButton.alpha != 1;
        [UIView animateWithDuration:0.3 delay:0.3 * delayLayout options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        [UIView animateWithDuration:0.3 delay:0.3 * delayAlpha options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            prevButton.alpha = 0;
            nextButton.alpha = 1;
        } completion:nil];
    }else{
        prevButton.alpha = 0;
        nextButton.alpha = 1;
        [self.view layoutIfNeeded];
    }
}

- (void)showFinishButton:(BOOL)animate{
    nextButtonPosition.constant = -38;
    if(animate){
        int delayLayout = prevButton.alpha == 1;
        int delayAlpha = prevButton.alpha != 1;
        [UIView animateWithDuration:0.3 delay:0.3 * delayLayout options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        [UIView animateWithDuration:0.3 delay:0.3 * delayAlpha options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            prevButton.alpha = 1;
            nextButton.alpha = 1;
        } completion:^(BOOL finished){
            nextButton.titleLabel.text = @"완료";
        }];
    }else{
        prevButton.alpha = 1;
        nextButton.alpha = 1;
        [self.view layoutIfNeeded];
        nextButton.titleLabel.text = @"완료";
    }
}

- (void)showRegularButton:(BOOL)animate{
    nextButtonPosition.constant = -38;
    if(animate){
        int delayLayout = prevButton.alpha == 1;
        int delayAlpha = prevButton.alpha != 1;
        [UIView animateWithDuration:0.3 delay:0.3 * delayLayout options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        [UIView animateWithDuration:0.3 delay:0.3 * delayAlpha options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            prevButton.alpha = 1;
            nextButton.alpha = 1;
        } completion:^(BOOL finished){
            nextButton.titleLabel.text = @"다음";
        }];
    }else{
        prevButton.alpha = 1;
        nextButton.alpha = 1;
        [self.view layoutIfNeeded];
        nextButton.titleLabel.text = @"다음";
    }
}

- (IBAction)nextButtonPressed{
    if(currentPage < descriptionCards.count - 1){
        [descriptionCardsView setContentOffset:CGPointMake(descriptionCardsView.frame.size.width * (currentPage + 1),0) animated:YES];
        HMTutorialDescriptionView *view1 = descriptionCards[currentPage];
        HMTutorialDescriptionView *view2 = descriptionCards[currentPage + 1];
        view1.alpha = 1;
        view2.alpha = 0;
        [UIView animateWithDuration:0.05 animations:^{
            view1.alpha = 0;
            view2.alpha = 1;
        }];
    }
    if(currentPage == descriptionCards.count - 1){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)prevButtonPressed{
    if(currentPage > 0){
        [descriptionCardsView setContentOffset:CGPointMake(descriptionCardsView.frame.size.width * (currentPage - 1),0) animated:YES];
        HMTutorialDescriptionView *view1 = descriptionCards[currentPage];
        HMTutorialDescriptionView *view2 = descriptionCards[currentPage - 1];
        view1.alpha = 1;
        view2.alpha = 0;
        [UIView animateWithDuration:0.05 animations:^{
            view1.alpha = 0;
            view2.alpha = 1;
        }];
    }
}


- (void)setPage:(NSUInteger)page{
    if(page != currentPage){
        currentPage = page;
        if(page == 0){
            [self showNextButton:YES];
        }else if(page == descriptionCards.count - 1){
            [self showFinishButton:YES];
        }else{
            [self showRegularButton:YES];
        }
        [pageControl setCurrentPage:page];
    }
}

- (void)addCard:(HMTutorialDescriptionView*)descriptionCard {
    [descriptionCards addObject:descriptionCard];
    [descriptionCardsView addSubview:descriptionCard];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutCards];
}

- (void)layoutCards {
    NSInteger cardIndex = 0;
    CGSize cardSize = descriptionCardsView.frame.size;
    CGSize contentSize = CGSizeMake(cardSize.width * descriptionCards.count, cardSize.height);
    pageControl.numberOfPages = descriptionCards.count;
    [descriptionCardsView setContentSize:contentSize];
    for(HMTutorialDescriptionView *descriptionCard in descriptionCards){
        CGRect cardFrame = CGRectMake(cardIndex * cardSize.width, 0, cardSize.width, cardSize.height);
        [descriptionCard setFrame:cardFrame];
        cardIndex++;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == descriptionCardsView){
        CGFloat scrollOffsetX = scrollView.contentOffset.x;
        NSInteger page = (NSInteger)((scrollOffsetX / scrollView.frame.size.width) + 0.5);
        if(page > descriptionCards.count - 1) page = descriptionCards.count - 1;
        if(page < 0) page = 0;
        [self setPage:page];
        page = (int)scrollOffsetX / (int)scrollView.frame.size.width;
        if(scrollOffsetX > scrollView.frame.size.width * (descriptionCards.count - 1)) return;
        CGFloat opacity = (float)((int)scrollOffsetX % (int)scrollView.frame.size.width) / scrollView.frame.size.width;
        HMTutorialDescriptionView *view2 = descriptionCards[page];
        view2.alpha =  pow(0.0002, opacity);
        if(page < descriptionCards.count - 1){
            HMTutorialDescriptionView *view3 = descriptionCards[page + 1];
            view3.alpha =  pow(0.0002, 1 - opacity);
        }
    }
}

- (void)setVideoTimestamp:(NSUInteger)videoTimeIndex {
    NSArray *timeArray = @[@(3), @(10), @(16), @(24)];
    //CMTime plackbackCursorPosition = CMTime
}


- (BOOL)prefersStatusBarHidden {
    return YES;
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

- (HMIDeviceType)deviceType{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if(screenSize.width == 320.0f){
        if(screenSize.height > 480.0f){
            return HMIDeviceTypeExtraSmall;
        }else{
            return HMIDeviceTypeSmall;
        }
    }else if(screenSize.width >= 400.0f){
        return HMIDeviceTypeLarge;
    }else{
        return HMIDeviceTypeMiddle;
    }
}


@end
