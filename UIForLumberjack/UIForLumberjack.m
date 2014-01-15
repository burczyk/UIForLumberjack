//
//  UIForLumberjack.m
//  UIForLumberjack
//
//  Created by Kamil Burczyk on 15.01.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import "UIForLumberjack.h"

@interface UIForLumberjack ()

@property (nonatomic, strong) id<DDLogFormatter> logFormatter;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation UIForLumberjack

+ (UIForLumberjack*) sharedInstance {
    static UIForLumberjack *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UIForLumberjack alloc] init];
        sharedInstance.messages = [@[] mutableCopy];
        
        sharedInstance.tableView = [[UITableView alloc] init];
        sharedInstance.tableView.delegate = sharedInstance;
        sharedInstance.tableView.dataSource = sharedInstance;
        [sharedInstance.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LogCell"];
        sharedInstance.tableView.backgroundColor = [UIColor blackColor];
        sharedInstance.tableView.alpha = 0.9f;
        sharedInstance.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        sharedInstance.dateFormatter = [[NSDateFormatter alloc] init];
        sharedInstance.dateFormatter.dateStyle = NSDateFormatterNoStyle;
        sharedInstance.dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    });
    return sharedInstance;
}

#pragma mark - DDLogger
- (void)logMessage:(DDLogMessage *)logMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_messages addObject:logMessage];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_messages.count-1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (id <DDLogFormatter>)logFormatter
{
    return self.logFormatter;
}

- (void)setLogFormatter:(id <DDLogFormatter>)formatter
{
    self.logFormatter = formatter;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogMessage *message = _messages[indexPath.row];
    
    NSString *prefix;
    switch (message->logFlag) {
        case LOG_FLAG_ERROR:
            cell.textLabel.textColor = [UIColor redColor];
            prefix = @"Ⓔ";
            break;
            
        case LOG_FLAG_WARN:
            cell.textLabel.textColor = [UIColor orangeColor];
            prefix = @"Ⓦ";
            break;
            
        case LOG_FLAG_DEBUG:
            cell.textLabel.textColor = [UIColor greenColor];
            prefix = @"Ⓓ";
            break;
            
        case LOG_FLAG_VERBOSE:
            cell.textLabel.textColor = [UIColor blueColor];
            prefix = @"Ⓥ";
            break;
            
        default:
            cell.textLabel.textColor = [UIColor whiteColor];
            prefix = @"Ⓘ";
            break;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@ %@", [_dateFormatter stringFromDate:message->timestamp], prefix, message->logMsg];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:9];
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"Hide Log" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor colorWithRed:59/255.0 green:209/255.0 blue:65/255.0 alpha:1];
    [closeButton addTarget:self action:@selector(hideLog) forControlEvents:UIControlEventTouchUpInside];
    return closeButton;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogMessage *message = _messages[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %s %d", [_dateFormatter stringFromDate:message->timestamp], message->function, message->lineNumber];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - public methods
- (void)showLogInView:(UIView*)view
{
    [view addSubview:self.tableView];
    UITableView *tv = self.tableView;
    tv.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tv]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tv)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tv]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tv)]];
}

- (void)hideLog
{
    [self.tableView removeFromSuperview];
}

@end
