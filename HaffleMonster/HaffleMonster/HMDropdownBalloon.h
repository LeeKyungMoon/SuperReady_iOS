//
//  HMDropdownBalloon.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 5. 20..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum HMDropdownBalloonAction {
    HMDropdownBalloonActionChangeLocation,
    HMDropdownBalloonActionSupport,
    HMDropdownBalloonActionMartRequest
} HMDropdownBalloonAction;

typedef struct HMDropdownBalloonPositions {
    CGRect background;
    CGRect divider;
    CGRect location;
    CGRect support;
    CGRect request;
} HMDropdownBalloonPositions;

@class HMDropdownBalloon;

@protocol HMDropdownBallonDelegate <NSObject>
@optional
- (void)balloon:(HMDropdownBalloon*)balloon didTouchDropdownButtonWithAction:(HMDropdownBalloonAction)actionType;
- (void)balloon:(HMDropdownBalloon*)balloon willShow:(BOOL)animated;
- (void)balloon:(HMDropdownBalloon*)balloon didShow:(BOOL)animated;
- (void)balloon:(HMDropdownBalloon*)balloon willDismiss:(BOOL)animated;
- (void)balloon:(HMDropdownBalloon*)balloon didDismiss:(BOOL)animated;
@end

@interface HMDropdownBalloon : UIView {
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIImageView *dividerImageView;
    IBOutlet UIButton *changeLocationButton;
    IBOutlet UIButton *supportButton;
    IBOutlet UIButton *martRequestButton;

    HMDropdownBalloonPositions positions;
}

@property (nonatomic, weak) id<HMDropdownBallonDelegate> delegate;
@property (nonatomic) BOOL displayState;

- (id)initWithPoint:(CGPoint)point;
- (void)prepareForAnimation;
- (void)showWithAnimation;
- (void)dismissWithAnimation;

@end
