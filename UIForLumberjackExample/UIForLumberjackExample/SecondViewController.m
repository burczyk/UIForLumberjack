//
//  SecondViewController.m
//  UIForLumberjackExample
//
//  Created by Kamil Burczyk on 15.01.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import "SecondViewController.h"
#import "UIForLumberjack.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UIView *logView;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIForLumberjack sharedInstance] showLogInView:_logView];
}

- (IBAction)showLog:(id)sender {
    [[UIForLumberjack sharedInstance] showLogInView:_logView];
}

- (IBAction)addDebugLog:(id)sender {
    DDLogDebug(@"Debug log");
}

- (IBAction)addInfoLog:(id)sender {
    DDLogInfo(@"Info log");
    
    DDLogInfo(@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.");
}

- (IBAction)addVerboseLog:(id)sender {
    DDLogVerbose(@"Verbose log");
}

- (IBAction)addWarningLog:(id)sender {
    DDLogWarn(@"Warning Log");
}

- (IBAction)addErrorLog:(id)sender {
    DDLogError(@"Error log");
}

- (IBAction)fireAsyncLoop:(id)sender {
    for (int i=0; i<10; ++i) {
        double delayInSeconds = i/2.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            DDLogDebug(@"Async log no %d", i);
        });
    }
}

@end
