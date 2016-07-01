//
//  BUKMessageBarManager.h
//  Pods
//
//  Created by Monzy Zhang on 7/1/16.
//
//

#import <Foundation/Foundation.h>
#import "BUKMessageBar.h"


@interface BUKMessageBarManager : NSObject

+ (BUKMessageBar *)showMessageWithTitle:(NSString *)title 
                      detail:(NSString *)detail 
                                buttons:(NSArray<UIButton *> *)buttons 
                                handler:(void (^)(UIButton *button, NSInteger buttonIndex))block
                                   type:(BUKMessageBarType)type
                               duration:(NSTimeInterval)duration;

+ (BUKMessageBar *)showMessageWithTitle:(NSString *)title 
                                 detail:(NSString *)detail 
                                   type:(BUKMessageBarType)type
                               duration:(NSTimeInterval)duration;

@end
