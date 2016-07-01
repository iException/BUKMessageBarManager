//
//  BUKMessageBar.m
//  Pods
//
//  Created by Monzy Zhang on 7/1/16.
//
//

#import "BUKMessageBar.h"
#import "UIControl+BlocksKit.h"

#define kStatusBarHeight 20.0
#define kButtonHeight 35.0

@interface BUKMessageBar ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *labelsContainerView;
@property (nonatomic, strong) UIView *buttonsContainerView;
@property (nonatomic, strong) NSArray<UIButton *> *buttons;

@end

@implementation BUKMessageBar

#pragma mark - lifecycle -

- (instancetype)initWithTitle:(NSString *)title 
                       detail:(NSString *)detail 
                         type:(BUKMessageBarType)type
{
    self = [super init];
    if (self) {
        self.type = type;        
        [self initUIWithTitle:title detail:detail];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title 
                       detail:(NSString *)detail 
                      buttons:(NSArray<UIButton *> *)buttons 
                      handler:(void (^)(UIButton *button, NSInteger buttonIndex))block
                         type:(BUKMessageBarType)type
{
    self = [super init];
    if (self) {
        self.buttons = buttons;
        self.type = type;
        [self initUIWithTitle:title detail:detail];
        [self setupButtonAction:block];
    }
    return self;
}

- (void)initUIWithTitle:(NSString *)title detail:(NSString *)detail
{
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
    [self addSubvews];
    [self setupFrame];
}

- (void)setupButtonAction:(void (^)(UIButton *button, NSInteger buttonIndex))block
{
    if (!block) {
        return;
    }
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj bk_addEventHandler:^(id sender) {
            block(obj, idx);
        } forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)showAnimated:(BOOL)animated completion:(void (^)())completion
{
    if (self.isShow) {
        return;
    }
    self.isShow = true;
    CGRect frame = self.bounds;
    [self setFrame:frame animated:animated completion:completion];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)())completion
{
    if (!self.isShow) {
        return;
    }
    self.isShow = false;
    CGRect frame = self.bounds;
    frame.origin.y -= CGRectGetHeight(frame);
    [self setFrame:frame animated:animated completion:completion];
}

- (void)setFrame:(CGRect)frame animated:(BOOL)animated completion:(void (^)())completion
{
    if (!animated) {
        self.frame = frame;
        if (completion) {
            completion();
        }
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - private -
- (void)addSubvews
{
    [self.labelsContainerView addSubview:self.titleLabel];
    [self.labelsContainerView addSubview:self.detailLabel];
    [self addSubview:self.labelsContainerView];
    if (self.buttons.count) {
        [self addSubview:self.buttonsContainerView];
        [self addButtons];
    }
}

- (void)addButtons
{
    for (UIButton *button in self.buttons) {
        [self.buttonsContainerView addSubview:button];
    }
}

- (void)setupFrame
{
    CGRect titleFrame = [self.titleLabel textRectForBounds:[UIScreen mainScreen].bounds limitedToNumberOfLines:0];
    titleFrame.origin.y = kStatusBarHeight;
    CGRect detailFrame = [self.detailLabel textRectForBounds:[UIScreen mainScreen].bounds limitedToNumberOfLines:0];
    detailFrame.origin.y = titleFrame.origin.y + CGRectGetHeight(titleFrame);
    CGFloat labelsHeight = kStatusBarHeight + CGRectGetHeight(titleFrame) + CGRectGetHeight(detailFrame);
    
    self.titleLabel.frame = titleFrame;
    self.detailLabel.frame = detailFrame;
    self.labelsContainerView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), labelsHeight);
    CGFloat height = CGRectGetHeight(self.labelsContainerView.frame); 
    if (self.buttons.count) {
        self.buttonsContainerView.frame = CGRectMake(0, labelsHeight, CGRectGetWidth([UIScreen mainScreen].bounds), kButtonHeight);
        height += CGRectGetHeight(self.buttonsContainerView.frame); 
        CGFloat buttonWidth = CGRectGetWidth([UIScreen mainScreen].bounds) / self.buttons.count;
        [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect buttonFrame = CGRectMake(idx * buttonWidth, 0, buttonWidth, kButtonHeight);
            obj.frame = buttonFrame;
        }];
    }
    self.frame = CGRectMake(0, -height, CGRectGetWidth([UIScreen mainScreen].bounds), height);
}

#pragma mark - getters -
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.font = [UIFont systemFontOfSize:11];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIView *)labelsContainerView
{
    if (!_labelsContainerView) {
        _labelsContainerView = [[UIView alloc] init];
        switch (self.type) {
            case BUKMessageBarTypeSuccess:
                _labelsContainerView.backgroundColor = [UIColor greenColor];
                break;
            case BUKMessageBarTypeFailed:
                _labelsContainerView.backgroundColor = [UIColor redColor];
                break;
            case BUKMessageBarTypeInfo:
                _labelsContainerView.backgroundColor = [UIColor magentaColor];
                break;
        }
    }
    return _labelsContainerView;
}

- (UIView *)buttonsContainerView
{
    if (!_buttonsContainerView) {
        _buttonsContainerView = [[UIView alloc] init];
    }
    return _buttonsContainerView;
}
@end
