//
//  UIForLumberjack.h
//  UIForLumberjack
//
//  Created by Kamil Burczyk on 15.01.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

@interface UIForLumberjack : NSObject <UITableViewDataSource, UITableViewDelegate, DDLogger>

@property (nonatomic, strong) UITableView *tableView;

+ (UIForLumberjack*) sharedInstance;

- (void)showLogInView:(UIView*)view;
- (void)hideLog;

@end
