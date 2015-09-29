//
//  UIForLumberjack.h
//  UIForLumberjack
//
//  Created by Kamil Burczyk on 15.01.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface UIForLumberjack : NSObject <DDLogger>

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) UITableView *tableView;

- (void)showLogInView:(UIView *)view;
- (void)hideLog;

@end
