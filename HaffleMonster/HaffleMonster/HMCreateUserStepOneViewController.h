//
//  HMCreateUserStepOneViewController.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 24..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRLoads.h"
#import "HMCreateUserStepOneContentView.h"

typedef enum HMCreateUserStepState{
    HMCreateUserStepStateError,
    HMCreateUserStepStateInput,
    HMCreateUserStepStateSuccess
} HMCreateUserStepState;

@interface HMCreateUserStepOneViewController : UIViewController {
    HMCreateUserStepState state;
    HMCreateUserStepOneContentView *stepOneView;
}
@property (nonatomic) NSUInteger userBirthYear;
@property (nonatomic) HMUserGender userGender;

@property (nonatomic) IBOutlet UIScrollView *scrollView;

@end
