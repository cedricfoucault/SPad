//
//  SpadButton.m
//  Spad
//
//  Created by Cédric Foucault on 10/18/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ModeButton.h"

static const CGFloat BORDER_WIDTH = 0.0;
static const CGFloat TITLE_FONTSIZE_PT = 14.0;
//static const CGFloat TITLE_RADIUS_OFFSET_PT = 10.0;
//static const CGFloat LABEL_MAX_WIDTH_PT = 100.0;
static const CGFloat WIDTH_FRAME = 100;
static const CGFloat HEIGHT_FRAME = 100;

@interface ModeButton ()

//- (NSAttributedString *)attributedTitle;
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@property (strong, nonatomic) NSLayoutConstraint *titleLeftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *titleTopConstraint;
@property (strong, nonatomic) NSLayoutConstraint *titleWidthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *titleHeightConstraint;

@end

@implementation ModeButton

- (id)initWithCenter:(CGPoint)center radiusInner:(CGFloat)radiusInner outer:(CGFloat)radiusOuter angleMin:(CGFloat)angleMin max:(CGFloat)angleMax {
    // Init the view's frame
    self = [self initWithFrame:CGRectZero];
    if (self) {
        // Init parameters
        _arcCenter = center;
        _radiusInner = radiusInner;
        _radiusOuter = radiusOuter;
        _angleMin = angleMin;
        _angleMax = angleMax;
        [self _init];
        
//        [self _updateFrame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
    // init title label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleFontSize = TITLE_FONTSIZE_PT;
    [self addSubview:_titleLabel];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"highlighted"]) {
        [[ModeManager sharedManager] setMode:self.mode active:self.isHighlighted];
        [self updateViewToCurrentState];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"highlighted"];
}

- (void)initConstraints {
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat x = self.arcCenter.x + self.xFrame;
    CGFloat y = self.arcCenter.y - self.yFrame;
    CGFloat width = self.widthFrame;
    CGFloat height = self.heightFrame;
    _leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.superview attribute:NSLayoutAttributeLeft
                                                     multiplier:1 constant:x];
    _topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.superview attribute:NSLayoutAttributeTop
                                                     multiplier:1 constant:y];
    _widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                   multiplier:1 constant:width];
    _heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                   multiplier:1 constant:height];
    
    CGFloat radiusText = (self.radiusOuter + self.radiusInner) / 2;
    CGFloat angleMid = (self.angleMin + self.angleMax) / 2;
    CGSize textSize = [self.titleLabel.attributedText size];
    CGFloat xTextCenter = radiusText * cos(angleMid) - self.xFrame;
    CGFloat yTextCenter = self.yFrame - (radiusText * sin(angleMid));
    _titleLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self attribute:NSLayoutAttributeLeft
                                                  multiplier:1 constant:(xTextCenter - textSize.width / 2)];
    _titleTopConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self attribute:NSLayoutAttributeTop
                                                 multiplier:1 constant:(yTextCenter - textSize.height / 2)];
    _titleWidthConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                   multiplier:1 constant:textSize.width];
    _titleHeightConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1 constant:textSize.height];
    
    [self.titleLabel addConstraints:@[_titleWidthConstraint, _titleHeightConstraint]];
    [self addConstraints:@[_widthConstraint, _heightConstraint, _titleLeftConstraint, _titleTopConstraint]];
    [self.superview addConstraints:@[_leftConstraint, _topConstraint]];
}

- (void)_updateConstraints {
    self.leftConstraint.constant = self.arcCenter.x + self.xFrame;
    self.topConstraint.constant = self.arcCenter.y - self.yFrame;
    self.widthConstraint.constant = self.widthFrame;
    self.heightConstraint.constant = self.heightFrame;
    
    CGFloat radiusText = (self.radiusOuter + self.radiusInner) / 2;
    CGFloat angleMid = (self.angleMin + self.angleMax) / 2;
    CGSize textSize = [self.titleLabel.attributedText size];
    CGFloat xTextCenter = radiusText * cos(angleMid) - self.xFrame;
    CGFloat yTextCenter = self.yFrame - (radiusText * sin(angleMid));
    
    self.titleLeftConstraint.constant = xTextCenter - textSize.width / 2;
    self.titleTopConstraint.constant = yTextCenter - textSize.height / 2;
    self.titleWidthConstraint.constant = textSize.width + 1;
    self.titleHeightConstraint.constant = textSize.height;
    
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title {
    //    _title = [[NSString alloc] initWithString:title];
    //    [self setNeedsDisplay];
    self.titleLabel.attributedText = [self attributedTitleWithText:title state:self.state];
    [self _updateConstraints];
    //    CGSize titleSize = [self.titleLabel.attributedText size];
    //    CGFloat angleMid = (self.angleMin + self.angleMax) / 2;
    //    CGFloat radiusMid = (self.radiusInner + self.radiusOuter) / 2;
    //    CGFloat xmid = radiusMid * cos(angleMid) - self.xFrame;
    //    CGFloat ymid = self.yFrame - (radiusMid * sin(angleMid));
    //    self.titleLabel.frame = CGRectMake(xmid - titleSize.width / 2, ymid - titleSize.height / 2, titleSize.width, titleSize.height);
    //    [self.titleLabel setNeedsDisplay];
}

- (void)setTitleFontSize:(CGFloat)titleFontSize {
    _titleFontSize = titleFontSize;
    [self setNeedsDisplay];
}

- (void)updateViewToCurrentState {
    self.titleLabel.attributedText = [self attributedTitleWithText:self.titleLabel.text state:self.state];
    [self _updateConstraints];
}

- (UIColor *)fillColorWithState:(UIControlState)state {
    switch (state) {
        case UIControlStateHighlighted:
            return self.buttonHighlightedColor;
            
        default:
            return self.buttonColor;
    }
}

- (NSAttributedString *)attributedTitleWithText:(NSString *)text state:(UIControlState)state {
    NSDictionary *attributes;
    switch (state) {
        case UIControlStateHighlighted:
            attributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [UIFont boldSystemFontOfSize:self.titleFontSize], NSFontAttributeName,
                          [UIColor whiteColor], NSForegroundColorAttributeName, nil];
            break;
            
        default:
            attributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [UIFont systemFontOfSize:self.titleFontSize], NSFontAttributeName,
                          [UIColor whiteColor], NSForegroundColorAttributeName, nil];
            break;
    }
    //    return [[NSAttributedString alloc] initWithString:self.title attributes:attributes];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}

- (void)setArcCenter:(CGPoint)arcCenter {
    _arcCenter = arcCenter;
    [self _updateConstraints];
}

- (void)setAngleMax:(CGFloat)angleMax {
    _angleMax = angleMax;
    [self _updateConstraints];
}

- (void)setAngleMin:(CGFloat)angleMin {
    _angleMin = angleMin;
    [self _updateConstraints];
}

- (void)setRadiusOuter:(CGFloat)radiusOuter {
    _radiusOuter = radiusOuter;
    [self _updateConstraints];
}

- (void)setRadiusInner:(CGFloat)radiusInner {
    _radiusInner = radiusInner;
    [self _updateConstraints];
}

- (CGFloat)widthButton {
    return (self.radiusOuter - self.radiusInner);
}

- (CGFloat)angleButton {
    return (self.angleMax - self.angleMin);
}

- (CGFloat)xFrame {
    return (self.radiusInner * cos(self.angleMax));
}

- (CGFloat)yFrame {
    //    return (self.radiusInner * sin(self.angleMin));
    return (self.radiusOuter * sin(self.angleMax));
}

- (CGFloat)widthFrame {
    return (self.radiusOuter * cos(self.angleMin) - self.xFrame);
}

- (CGFloat)heightFrame {
    //    return (self.radiusOuter * sin(self.angleMax) - self.yFrame);
    return (self.yFrame - self.radiusInner * sin(self.angleMin));
}

- (UIBezierPath *)drawPathUI {
    UIBezierPath *drawPath = [UIBezierPath bezierPath];
    drawPath.lineWidth = BORDER_WIDTH;
    CGFloat xInnerMax = self.radiusInner * cos(self.angleMin) - self.xFrame;
    [drawPath moveToPoint:CGPointMake(xInnerMax, self.heightFrame)];
    CGFloat angleStart = - self.angleMin;
    CGFloat angleEnd = - self.angleMax;
    [drawPath addArcWithCenter:CGPointMake(-self.xFrame, self.yFrame) radius:self.radiusInner startAngle:angleStart endAngle:angleEnd clockwise:NO];
    [drawPath addArcWithCenter:CGPointMake(-self.xFrame, self.yFrame) radius:self.radiusOuter startAngle:angleEnd endAngle:angleStart clockwise:YES];
    [drawPath closePath];
    return  drawPath;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0); // black stroke
    //    CGContextSetRGBFillColor(context, 1.0, 0.5, 0.0, 1.0); // orange fill
    CGContextSetFillColorWithColor(context, [self fillColorWithState:self.state].CGColor);
    UIBezierPath *drawPath = [self drawPathUI];
    [drawPath stroke];
    [drawPath fill];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self isInside:point];
}

- (BOOL)isInside:(CGPoint)p {
    // get location in (r, teta) coordinate system
    CGFloat xp = self.xFrame + p.x;
    CGFloat yp = self.yFrame - p.y;
    CGFloat r = sqrt((xp * xp + yp * yp));
    CGFloat teta = acos(xp / r);
    return r >= self.radiusInner && r <= self.radiusOuter && teta >= self.angleMin && teta <= self.angleMax;
}

@end
