//
//  BUKMessageBar.m
//  Pods
//
//  Created by Monzy Zhang on 7/1/16.
//
//

#import "BUKMessageBar.h"
#import "UIColor+bukmbmhex.h"
#import "UIControl+Blockskit.h"
#import "UIGestureRecognizer+Blockskit.h"

#define kStatusBarHeight 20.0
#define kButtonContainerHeight 35.0
#define kPadding 10.0
#define kButtonSpace 10.0
#define kButtonTopPadding 6.0
#define kRadius 10.0

#define kTopButtonWidth 30.0
#define kExpandButtonTitle @"展开"
#define kFoldButtonTitle @"折叠"

@interface BUKMessageBar ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *titleContainerView;
@property (nonatomic, strong) UIView *buttonsContainerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray<BUKMessageBarButton *> *buttons;
@property (nonatomic, strong) CAShapeLayer *titleBackgroundLayer;
@property (nonatomic, strong) UIButton *toggleButton;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, assign) BOOL expanded;

@end

@implementation BUKMessageBar

#pragma mark - lifecycle -

- (instancetype)initWithTitle:(NSString *)title 
                       detail:(NSString *)detail 
                         type:(BUKMessageBarType)type 
                   tapHandler:(void(^)(BUKMessageBar *bar))tapHandler
                     expanded:(BOOL)expanded
{
    self = [super init];
    if (self) {
        self.type = type;
        self.expanded = expanded;
        [self setupWithTitle:title detail:detail tapHandler:tapHandler];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title 
                       detail:(NSString *)detail 
                         type:(BUKMessageBarType)type
                      buttons:(NSArray<BUKMessageBarButton *> *)buttons 
                   tapHandler:(void(^)(BUKMessageBar *bar))tapHandler
                     expanded:(BOOL)expanded
{
    self = [super init];
    if (self) {
        self.buttons = buttons;
        self.type = type;
        self.expanded = expanded;
        [self setupWithTitle:title detail:detail tapHandler:tapHandler];
    }
    return self;
}

- (void)showAnimated:(BOOL)animated completion:(void (^)())completion
{
    if (self.isShow) {
        return;
    }
    self.isShow = true;
    CGRect frame = self.bounds;
    frame.origin.y += kStatusBarHeight;
    frame.origin.x += kPadding;
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
    frame.origin.x += kPadding;
    [self setFrame:frame animated:animated completion:^{
        if (completion) {
            completion();
        }
        [self removeFromSuperview];
    }];
}

#pragma mark - private -

- (void)setupWithTitle:(NSString *)title detail:(NSString *)detail tapHandler:(void(^)(BUKMessageBar *bar))tapHandler
{
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = kRadius;
    [self addSubvews];
    [self setupFrame];
    [self addGestureRecognizer:[UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if (tapHandler) {
            tapHandler(self);
        }
    }]];
}

- (void)expandAnimated:(BOOL)animated expand:(BOOL)expand
{
    if (self.expanded == expand) {
        return;
    }
    CGRect newFrame = self.frame;
    CATransform3D contentViewTransform;
    if (expand) {
        //expand
        newFrame.size.height = CGRectGetHeight(self.titleContainerView.frame) + CGRectGetHeight(self.contentView.frame);
    } else {
        //fold
        newFrame.size.height = CGRectGetHeight(self.titleContainerView.frame);
    }
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = newFrame;
        } completion:nil];
    } else {
        self.frame = newFrame;
    }
    self.expanded = expand;
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

- (void)addSubvews
{
    [self.titleContainerView addSubview:self.titleLabel];
    [self.titleContainerView addSubview:self.toggleButton];
    [self.titleContainerView addSubview:self.dismissButton];    
    [self.contentView addSubview:self.detailLabel];
    
    [self addSubview:self.titleContainerView];
    [self addSubview:self.contentView];
    
    if (self.buttons.count) {
        [self.contentView addSubview:self.buttonsContainerView];
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
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * kPadding;
    
    CGRect titleBoundRect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 4 * kPadding - kTopButtonWidth * 2, CGRectGetHeight([UIScreen mainScreen].bounds));
    CGRect textBoundRect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 4 * kPadding, CGRectGetHeight([UIScreen mainScreen].bounds));
    CGPoint origin = CGPointMake(kPadding, kPadding + kStatusBarHeight);
    CGRect titleFrame = [self.titleLabel textRectForBounds:titleBoundRect limitedToNumberOfLines:0];    
    titleFrame.origin.y = CGRectGetHeight(titleFrame) / 4;
    titleFrame.origin.x = kPadding;
    
    self.titleLabel.frame = titleFrame;
    self.toggleButton.frame = CGRectMake(width - kTopButtonWidth * 2 - kPadding, CGRectGetHeight(titleFrame) / 4, kTopButtonWidth, CGRectGetHeight(titleFrame));
    self.dismissButton.frame = CGRectMake(width - kTopButtonWidth - kPadding, CGRectGetHeight(titleFrame) / 4, kTopButtonWidth, CGRectGetHeight(titleFrame));
    CGRect titleContainerFrame = CGRectMake(0, 0, width, CGRectGetHeight(titleFrame) * 1.5);
    self.titleContainerView.frame = titleContainerFrame;
    [self setupTitleBackgroundLayerWithFrame:titleContainerFrame];
    
    
    CGRect detailFrame = [self.detailLabel textRectForBounds:textBoundRect limitedToNumberOfLines:0];
    detailFrame.origin.y = kPadding / 2;
    detailFrame.origin.x = kPadding;    
    self.detailLabel.frame = detailFrame;
    
    CGFloat contentViewHeight = CGRectGetHeight(detailFrame) + kPadding;
    if (self.buttons.count) {
        self.buttonsContainerView.frame = CGRectMake(0, CGRectGetMaxY(detailFrame) + kPadding / 2, width, kButtonContainerHeight);
        contentViewHeight += CGRectGetHeight(self.buttonsContainerView.frame); 
        CGFloat buttonWidth = (width - kButtonSpace * (self.buttons.count + 1)) / self.buttons.count;
        [self.buttons enumerateObjectsUsingBlock:^(BUKMessageBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect buttonFrame = CGRectMake(idx * buttonWidth + kButtonSpace * (idx + 1), kButtonTopPadding, buttonWidth, kButtonContainerHeight - kButtonTopPadding * 2);
            obj.bar = self;
            obj.frame = buttonFrame;
        }];
    }
    
    
    CGFloat height = CGRectGetHeight(titleContainerFrame) + contentViewHeight;
    self.contentView.frame = CGRectMake(0, CGRectGetHeight(titleContainerFrame), width, contentViewHeight);
    self.frame = CGRectMake(kPadding, -height, width, height);
    
    if (!self.expanded) {
        self.expanded = YES;
        [self expandAnimated:NO expand:NO];
    }
}

- (void)setupTitleBackgroundLayerWithFrame:(CGRect)frame
{
    if (!_titleBackgroundLayer) {
        _titleBackgroundLayer = [CAShapeLayer layer];
    }
    _titleBackgroundLayer.frame = frame;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame 
                                               byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight 
                                                     cornerRadii:CGSizeMake(kRadius, kRadius)];
    _titleBackgroundLayer.path = path.CGPath;
    switch (self.type) {
        case BUKMessageBarTypeSuccess:
            _titleBackgroundLayer.fillColor = [UIColor buk_tb_successColor].CGColor;
            break;
        case BUKMessageBarTypeFailed:
            _titleBackgroundLayer.fillColor = [UIColor buk_tb_failedColor].CGColor;
            break;
        case BUKMessageBarTypeInfo:
            _titleBackgroundLayer.fillColor = [UIColor buk_tb_infoColor].CGColor;
            break;
    }
    [self.layer insertSublayer:_titleBackgroundLayer atIndex:0];
}
#pragma mark - getters & setters -
#pragma mark - setters
- (void)setExpanded:(BOOL)expanded
{
    _expanded = expanded;
    if (_expanded) {
        [self.toggleButton setTitle:kFoldButtonTitle forState:UIControlStateNormal];
    } else {
        [self.toggleButton setTitle:kExpandButtonTitle forState:UIControlStateNormal];
    }
}
#pragma mark - getters
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:14];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.font = [UIFont fontWithName:@"Avenir-Light" size:11];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIView *)titleContainerView
{
    if (!_titleContainerView) {
        _titleContainerView = [[UIView alloc] init];
    }
    return _titleContainerView;
}

- (UIView *)buttonsContainerView
{
    if (!_buttonsContainerView) {
        _buttonsContainerView = [[UIView alloc] init];
    }
    return _buttonsContainerView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor buk_messageBar_background];
    }
    return _contentView;
}

- (UIButton *)toggleButton
{
    if (!_toggleButton) {
        _toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_toggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _toggleButton.titleLabel.font = [UIFont systemFontOfSize:10];
        
        __weak typeof(self) weakSelf = self;
        [_toggleButton bk_addEventHandler:^(id sender) {
            [self expandAnimated:YES expand:!self.expanded];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _toggleButton;
}

- (UIButton *)dismissButton
{
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dismissButton setTitle:@"关闭" forState:UIControlStateNormal];
        _dismissButton.titleLabel.font = [UIFont systemFontOfSize:10];
        
        __weak typeof(self) weakSelf = self;
        [_dismissButton bk_addEventHandler:^(id sender) {
            [weakSelf dismissAnimated:YES completion:nil];            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}
@end
