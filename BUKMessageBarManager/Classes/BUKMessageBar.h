//
//  BUKMessageBar.h
//  Pods
//
//  Created by Monzy Zhang on 7/1/16.
//
//

#import <UIKit/UIKit.h>
#import "BUKMessageBarButton.h"

typedef NS_ENUM(NSInteger, BUKMessageBarType) {
    BUKMessageBarTypeSuccess,
    BUKMessageBarTypeFailed,
    BUKMessageBarTypeInfo
};

@interface BUKMessageBar : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BUKMessageBarType type;

- (instancetype)initWithTitle:(NSString *)title 
                       detail:(NSString *)detail 
                         type:(BUKMessageBarType)type 
                   tapHandler:(void(^)(BUKMessageBar *bar))tapHandler
                     expanded:(BOOL)expanded;

- (instancetype)initWithTitle:(NSString *)title 
                       detail:(NSString *)detail 
                         type:(BUKMessageBarType)type
                      buttons:(NSArray<BUKMessageBarButton *> *)buttons 
                   tapHandler:(void(^)(BUKMessageBar *bar))tapHandler
                      expanded:(BOOL)expanded;

- (void)showAnimated:(BOOL)animated completion:(void (^)())completion;
- (void)dismissAnimated:(BOOL)animated completion:(void (^)())completion;

@end
