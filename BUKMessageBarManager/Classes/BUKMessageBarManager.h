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
                                buttons:(NSArray<BUKMessageBarButton *> *)buttons                         
                                   type:(BUKMessageBarType)type 
                               expanded:(BOOL)expanded
                               duration:(NSTimeInterval)duration;

+ (BUKMessageBar *)showMessageWithTitle:(NSString *)title 
                                 detail:(NSString *)detail 
                                   type:(BUKMessageBarType)type 
                               expanded:(BOOL)expanded
                               duration:(NSTimeInterval)duration;

@end
