//
//  HMTutorialMainViewController.h
//  SuperReady Tutorial
//
//  Created by Fermata on 2015. 6. 12..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "HMTutorialDescriptionView.h"

typedef enum HMIDeviceType {
    HMIDeviceTypeExtraSmall,
    HMIDeviceTypeSmall,
    HMIDeviceTypeMiddle,
    HMIDeviceTypeLarge
} HMIDeviceType;

@interface HMTutorialMainViewController : UIViewController <UIScrollViewDelegate, UIPageViewControllerDelegate> {
    NSMutableArray *descriptionCards;
    IBOutlet UIScrollView *descriptionCardsView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *prevButton;
    IBOutlet UIImageView *phoneImageView;
    IBOutlet UIView *videoView;
    NSInteger currentPage;
    NSLayoutConstraint *nextButtonPosition;
    NSLayoutConstraint *videoFramePosition;
    AVPlayer *player;
}

@end
