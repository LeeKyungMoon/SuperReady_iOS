//
//  HMTutorialDescriptionView.m
//  SuperReady Tutorial
//
//  Created by Fermata on 2015. 6. 15..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMTutorialDescriptionView.h"

@implementation HMTutorialDescriptionView

- (id)initWithTitle:(NSString*)title description:(NSString*)description{
    self = [[[NSBundle mainBundle] loadNibNamed:@"HMTutorialDescriptionView" owner:nil options:nil] firstObject];
    if(self != nil){
        self.titleLabel.text = title;
        self.descriptionLabel.text = description;
    }
    return self;
}

@end
