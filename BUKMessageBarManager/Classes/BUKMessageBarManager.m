//
//  BUKMessageBarManager.m
//  Pods
//
//  Created by Monzy Zhang on 7/1/16.
//
//

#import "BUKMessageBarManager.h"

@implementation UIWindow (BUKMessageBarManagerMainWindow)

+ (UIView *)mainWindow
{
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
    
    for (UIWindow *window in frontToBackWindows)
        if (window.windowLevel == UIWindowLevelNormal) {
            return window;
        }
    return nil;
}

@end

@implementation BUKMessageBarManager

+ (BUKMessageBar *)showMessageWithTitle:(NSString *)title 
                                 detail:(NSString *)detail 
                                buttons:(NSArray<UIButton *> *)buttons 
                                handler:(void (^)(UIButton *button, NSInteger buttonIndex))block 
                                   type:(BUKMessageBarType)type
                               duration:(NSTimeInterval)duration
{
    BUKMessageBar *bar = [[BUKMessageBar alloc] initWithTitle:title detail:detail buttons:buttons handler:block type:type];
    [self showBar:bar duration:duration];
    return bar;
}

+ (BUKMessageBar *)showMessageWithTitle:(NSString *)title 
                                 detail:(NSString *)detail
                                   type:(BUKMessageBarType)type
                               duration:(NSTimeInterval)duration
{
    BUKMessageBar *bar = [[BUKMessageBar alloc] initWithTitle:title detail:detail type:type];
    [self showBar:bar duration:duration];
    return bar;
}

+ (void)showBar:(BUKMessageBar *)bar duration:(NSTimeInterval)duration
{
    [[UIWindow mainWindow] addSubview:bar];
    [bar showAnimated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [bar dismissAnimated:YES completion:^{
            [bar removeFromSuperview]; 
        }];
    });    
}

@end
