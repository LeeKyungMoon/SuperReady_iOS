//
//  UIAlertView+BlockExtension.h
//  AlertViewExamples
//
//  Created by Mango on 2015. 3. 18..
//  Copyright (c) 2015년 Mangofever. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewActionDispatcher.h"

@interface UIAlertView (BlockExtension)

@property (strong, nonatomic) AlertViewActionDispatcher *actionDispatcher;

+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message;

- (void)addButtonWithTitle:(NSString *)title actionBlock:(UIAlertActionBlock)actionBlock;
- (void)addCancelButtonWithTitle:(NSString *)title actionBlock:(UIAlertActionBlock)actionBlock;
- (void)addCancelActionBlock:(UIAlertActionBlock)actionBlock;

@end
