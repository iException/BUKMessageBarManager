//
//  BUKMessageBar.m
//  Pods
//
//  Created by Monzy Zhang on 7/1/16.
//
//

#import "BUKMessageBar.h"
#import "UIColor+bukmbmhex.h"

#define kStatusBarHeight 20.0
#define kButtonContainerHeight 35.0
#define kPadding 10.0
#define kButtonSpace 10.0
#define kButtonTopPadding 6.0
#define kRadius 10.0

@interface BUKMessageBar ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *labelsContainerView;
@property (nonatomic, strong) UIView *buttonsContainerView;
@property (nonatomic, strong) NSArray<BUKMessageBarButton *> *buttons;
@property (nonatomic, strong) CAShapeLayer *titleBackgroundLayer;

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
                         type:(BUKMessageBarType)type
                      buttons:(NSArray<BUKMessageBarButton *> *)buttons
{
    self = [super init];
    if (self) {
        self.buttons = buttons;
        self.type = type;
        [self initUIWithTitle:title detail:detail];
    }
    return self;    
}

- (void)initUIWithTitle:(NSString *)title detail:(NSString *)detail
{
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
    self.backgroundColor = [UIColor buk_messageBar_background];
    self.layer.cornerRadius = kRadius;
    [self addSubvews];
    [self setupFrame];
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
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * kPadding;
    CGRect textBoundRect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 4 * kPadding, CGRectGetHeight([UIScreen mainScreen].bounds));
    CGPoint origin = CGPointMake(kPadding, kPadding + kStatusBarHeight);
    CGRect titleFrame = [self.titleLabel textRectForBounds:textBoundRect limitedToNumberOfLines:0];
    titleFrame.origin.y = kPadding;
    titleFrame.origin.x = kPadding;
    CGRect detailFrame = [self.detailLabel textRectForBounds:textBoundRect limitedToNumberOfLines:0];
    detailFrame.origin.y = titleFrame.origin.y + CGRectGetHeight(titleFrame) + kPadding;
    detailFrame.origin.x = kPadding;
    CGFloat labelsHeight = kStatusBarHeight + kPadding + CGRectGetHeight(titleFrame) + CGRectGetHeight(detailFrame);
    
    self.titleLabel.frame = titleFrame;
    self.detailLabel.frame = detailFrame;
    self.labelsContainerView.frame = CGRectMake(0, 0, width, labelsHeight);
        
    CGRect titleBackgroundFrame = CGRectMake(0, 0, width, CGRectGetHeight(titleFrame) + 1.5 * kPadding);
    [self setupTitleBackgroundLayerWithFrame:titleBackgroundFrame];
        
    CGFloat height = CGRectGetHeight(self.labelsContainerView.frame);
    
    if (self.buttons.count) {
        self.buttonsContainerView.frame = CGRectMake(0, labelsHeight, width, kButtonContainerHeight);
        height += CGRectGetHeight(self.buttonsContainerView.frame); 
        CGFloat buttonWidth = (width - kButtonSpace * (self.buttons.count + 1)) / self.buttons.count;
        [self.buttons enumerateObjectsUsingBlock:^(BUKMessageBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect buttonFrame = CGRectMake(idx * buttonWidth + kButtonSpace * (idx + 1), kButtonTopPadding, buttonWidth, kButtonContainerHeight - kButtonTopPadding * 2);
            obj.bar = self;
            obj.frame = buttonFrame;
        }];
    }
    self.frame = CGRectMake(kPadding, -height, width, height);
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
    [_labelsContainerView.layer insertSublayer:_titleBackgroundLayer atIndex:0];
}

#pragma mark - getters -
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

- (UIView *)labelsContainerView
{
    if (!_labelsContainerView) {
        _labelsContainerView = [[UIView alloc] init];
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
