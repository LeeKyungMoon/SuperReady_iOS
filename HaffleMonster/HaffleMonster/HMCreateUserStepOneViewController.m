//
//  HMCreateUserStepOneViewController.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 24..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMCreateUserStepOneViewController.h"

#define kHMColorCorrectGreen [UIColor colorWithRed:85/255.0 green:158/255.0 blue:0 alpha:1]
#define kHMColorErrorRed [UIColor redColor]

@interface HMCreateUserStepOneViewController ()

@end

@implementation HMCreateUserStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    stepOneView = [[HMCreateUserStepOneContentView alloc] init];
    [stepOneView.yearField becomeFirstResponder];
    state = HMCreateUserStepStateInput;
    stepOneView.inputView.layer.cornerRadius = 2.0;
    stepOneView.inputView.layer.masksToBounds = YES;
    stepOneView.finishButton.layer.cornerRadius = 2.0;
    stepOneView.finishButton.layer.masksToBounds = YES;
    [self.scrollView addSubview:stepOneView];
    [stepOneView.finishButton addTarget:self action:@selector(finishButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [stepOneView.genderSegment addTarget:self action:@selector(valueChangedForGenderSegment:) forControlEvents:UIControlEventValueChanged];
    [stepOneView.yearField addTarget:self action:@selector(valueChangedForYearField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[HMKinsightSession shared] tagScreen:@"사용자정보입력"];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //stepOneView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)validateYearValue:(NSUInteger)year{
    return (year >= 1910) && (year <= [[[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]] year] - 7);
}

- (HMUserGender)selectedUserGender{
    return (HMUserGender)(stepOneView.genderSegment.selectedSegmentIndex + 1);
}

- (IBAction)valueChangedForYearField:(id)sender{
    [self validateAndUpdateUI];
}

- (void)validateAndUpdateUI{
    NSCharacterSet *numerics = [NSCharacterSet decimalDigitCharacterSet];
    NSString *yearInput = [stepOneView.yearField text];
    NSCharacterSet *inputCharsets = [NSCharacterSet characterSetWithCharactersInString:yearInput];
    if([numerics isSupersetOfSet:inputCharsets]){
        if([yearInput length] == 4){
            if([self validateYearValue:[yearInput integerValue]]){
                if([self selectedUserGender] != HMUserGenderNotSelected){
                    [self UIStateSucccess];
                }else{
                    [self UIStateInput];
                }
                [stepOneView.yearField setTextColor:kHMColorCorrectGreen];
            }else{
                [self UIStateError];
                [stepOneView.yearField setTextColor:kHMColorErrorRed];
            }
        }else if([yearInput length] < 4){
            [self UIStateInput];
            [stepOneView.yearField setTextColor:[UIColor blackColor]];
        }else{
            [self UIStateError];
            [stepOneView.yearField setTextColor:kHMColorErrorRed];
        }
    }else{
        [self UIStateError];
        [stepOneView.yearField setTextColor:kHMColorErrorRed];
    }
}

- (IBAction)valueChangedForGenderSegment:(id)sender{
    [self validateAndUpdateUI];
}

- (void)UIStateInput{
    state = HMCreateUserStepStateInput;
}

- (void)UIStateError{
    state = HMCreateUserStepStateError;
}

- (void)UIStateSucccess{
    state = HMCreateUserStepStateSuccess;
}

- (IBAction)finishButtonPressed:(id)sender{
    NSString *alertMessage;
    switch(state){
        case HMCreateUserStepStateError:{
            alertMessage = @"생년을 올바르게 입력하셨는지 확인해주세요.";
            break;
        }
        case HMCreateUserStepStateInput:{
            alertMessage = @"생년과 성별을 모두 입력하셨나요?";
            break;
        }
        case HMCreateUserStepStateSuccess:{
            [self submitAction];
            return;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"잠깐!" message:alertMessage delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alert show];
}

- (void)submitAction{
    self.userBirthYear = (NSUInteger)[stepOneView.yearField.text integerValue];
    self.userGender = [self selectedUserGender];
    SRAPIManager *manager = [SRAPIManager manager];
    [manager submitUserInformationWithBirthYear:self.userBirthYear gender:self.userGender completion:^(BOOL success) {
        if(success){
            SET_KADATA = @{
                           @"지역":[KA userAddress],
                           @"사용자 나이":[KA userBirthYear],
                           @"사용자 성별":[KA userGenderString]
                           };
            SEND_KA_ @"사용자 정보 제출" _EVENT;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"이런!" message:@"서버문제!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
        }
    }];

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
