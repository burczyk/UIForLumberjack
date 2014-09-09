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
@property (nonatomic, strong) NSMutableSet *messagesExpanded;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation UIForLumberjack

+ (UIForLumberjack*) sharedInstance {
    static UIForLumberjack *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UIForLumberjack alloc] init];
        sharedInstance.messages = [NSMutableArray array];
        sharedInstance.messagesExpanded = [NSMutableSet set];
        
        sharedInstance.tableView = [[UITableView alloc] init];
        sharedInstance.tableView.delegate = sharedInstance;
        sharedInstance.tableView.dataSource = sharedInstance;
        [sharedInstance.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LogCell"];
        sharedInstance.tableView.backgroundColor = [UIColor blackColor];
        sharedInstance.tableView.alpha = 0.8f;
        sharedInstance.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        sharedInstance.dateFormatter = [[NSDateFormatter alloc] init];
        [sharedInstance.dateFormatter setDateFormat:@"HH:mm:ss:SSS"];
    });
    return sharedInstance;
}

#pragma mark - DDLogger
- (void)logMessage:(DDLogMessage *)logMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_messages addObject:logMessage];
        
        BOOL scroll = NO;
        if(_tableView.contentOffset.y + _tableView.bounds.size.height >= _tableView.contentSize.height)
            scroll = YES;
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_messages.count-1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        if(scroll) {
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
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
    
    switch (message->logFlag) {
        case LOG_FLAG_ERROR:
            cell.textLabel.textColor = [UIColor redColor];
            break;
            
        case LOG_FLAG_WARN:
            cell.textLabel.textColor = [UIColor orangeColor];
            break;
            
        case LOG_FLAG_DEBUG:
            cell.textLabel.textColor = [UIColor greenColor];
            break;
            
        case LOG_FLAG_VERBOSE:
            cell.textLabel.textColor = [UIColor blueColor];
            break;
            
        default:
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
    }
    
    cell.textLabel.text = [self textOfMessageForIndexPath:indexPath];
    cell.textLabel.font = [self fontOfMessage];
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = [UIColor clearColor];
}

- (NSString*)textOfMessageForIndexPath:(NSIndexPath*)indexPath
{
    DDLogMessage *message = _messages[indexPath.row];
    if ([_messagesExpanded containsObject:@(indexPath.row)]) {
        return [NSString stringWithFormat:@"[%@] %s:%d [%s]", [_dateFormatter stringFromDate:message->timestamp], message->file, message->lineNumber, message->function];
    } else {
        return [NSString stringWithFormat:@"[%@] %@", [_dateFormatter stringFromDate:message->timestamp], message->logMsg];
    }
}

- (UIFont*)fontOfMessage
{
    return [UIFont boldSystemFontOfSize:9];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *messageText = [self textOfMessageForIndexPath:indexPath];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    return [messageText sizeWithFont:[self fontOfMessage] constrainedToSize:CGSizeMake(self.tableView.bounds.size.width - 30, FLT_MAX)].height + kSPUILoggerMessageMargin;
#else
    return ceil([messageText boundingRectWithSize:CGSizeMake(self.tableView.bounds.size.width - 30, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[self fontOfMessage]} context:nil].size.height + kSPUILoggerMessageMargin);
#endif
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
    NSNumber *index = @(indexPath.row);
    if ([_messagesExpanded containsObject:index]) {
        [_messagesExpanded removeObject:index];
    } else {
        [_messagesExpanded addObject:index];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
