//
//  AlertViewActionDispatcher.m
//  AlertViewExamples
//
//  Created by Mango on 2015. 3. 18..
//  Copyright (c) 2015년 Mangofever. All rights reserved.
//

#import "AlertViewActionDispatcher.h"

@interface AlertViewActionDispatcher ()

@property (nonatomic, strong) NSMutableDictionary *actionBlockDictionary;

@end

@implementation AlertViewActionDispatcher

- (id)init {
    self = [super init];
    if (self) {
        self.actionBlockDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addActionBlock:(UIAlertActionBlock)actionBlock withButtonIndex:(NSInteger)buttonIndex {
    [self.actionBlockDictionary setObject:actionBlock forKey:@(buttonIndex)];
}

- (void)addCancelActionBlock:(UIAlertActionBlock)actionBlock {
    [self.actionBlockDictionary setObject:actionBlock forKey:@(ActionByCancel)];
}

- (BOOL)excuteActionBlockForAlertView:(UIAlertView *)alertView buttonIndex:(NSInteger)buttonIndex {
    UIAlertActionBlock actionBlock = [self.actionBlockDictionary objectForKey:@(buttonIndex)];
    if (actionBlock) {
        actionBlock(alertView, buttonIndex);
        return YES;
    }
    return NO;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self excuteActionBlockForAlertView:alertView buttonIndex:buttonIndex];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    if ([self excuteActionBlockForAlertView:alertView buttonIndex:ActionByCancel] == NO) {
        [self excuteActionBlockForAlertView:alertView buttonIndex:alertView.cancelButtonIndex];
    }
}

@end
