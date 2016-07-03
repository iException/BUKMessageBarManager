//
//  BUKMessageBarButton.h
//  Pods
//
//  Created by Monzy Zhang on 7/3/16.
//
//

#import <UIKit/UIKit.h>
@class BUKMessageBar;
typedef NS_ENUM(NSInteger, BUKMessageBarButtonType) {
    BUKMessageBarButtonTypeDefault,
    BUKMessageBarButtonTypeOk,
    BUKMessageBarButtonTypeDestructive
};

@interface BUKMessageBarButton : UIButton
@property (nonatomic, weak) BUKMessageBar* bar;

+ (BUKMessageBarButton *)buttonWithTitle:(NSString *)title 
                                    type:(BUKMessageBarButtonType)type 
                                 handler:(void (^)(BUKMessageBarButton *button))block;

@end
