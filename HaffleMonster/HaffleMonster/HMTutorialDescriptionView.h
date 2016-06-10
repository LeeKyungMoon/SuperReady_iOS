//
//  HMTutorialDescriptionView.h
//  SuperReady Tutorial
//
//  Created by Fermata on 2015. 6. 15..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMTutorialDescriptionView : UIView

@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UILabel *descriptionLabel;

- (id)initWithTitle:(NSString*)title description:(NSString*)description;

@end
