//
//  HMCreateUserStepOneContentView.h
//  HaffleMonster
//
//  Created by 이경문 on 2015. 5. 15..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMCreateUserStepOneContentView : UIView
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIView *inputView;

@end
