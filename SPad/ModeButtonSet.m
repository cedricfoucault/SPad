//
//  SpadButtonSet.m
//  SPadTestSwipes
//
//  Created by Cédric Foucault on 02/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ModeButtonSet.h"
#import "ModeButton.h"

@interface ModeButtonSet ()

@property (nonatomic) NSUInteger numberOfButtons;
@property (strong, nonatomic) NSMutableArray *buttons;

@property (strong, nonatomic) NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation ModeButtonSet

- (id)initWithNumberOfButtons:(NSUInteger)count {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _numberOfButtons = count;
        [self _init];
    }
    
    return self;
}

- (void)_init {
    // Configure frame view
    self.backgroundColor = [UIColor clearColor];
    // Configure radial buttons
    _buttons = [[NSMutableArray alloc] initWithCapacity:self.numberOfButtons];
    for (NSUInteger i = 0; i < self.numberOfButtons; i++) {
        ModeButton *ithButton = [[ModeButton alloc] initWithFrame:CGRectZero];
        [self addSubview:ithButton];
        [ithButton initConstraints];
        [_buttons addObject:ithButton];
    }
}

- (void)initConstraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
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
    
    [self addConstraints:@[_widthConstraint, _heightConstraint]];
    [self.superview addConstraints:@[_leftConstraint, _topConstraint]];
}

- (void)moveOriginX:(CGFloat)originX Y:(CGFloat)originY {
    self.leftConstraint.constant = originX;
    self.topConstraint.constant = originY;
}

- (void)moveCenterX:(CGFloat)centerX Y:(CGFloat)centerY {
    self.leftConstraint.constant = centerX - self.widthConstraint.constant / 2;
    self.topConstraint.constant = centerY - self.heightConstraint.constant / 2;
}

- (void)setTitle:(NSString *)title atIndex:(NSUInteger)i {
    ModeButton *ithButton = [self.buttons objectAtIndex:i];
    ithButton.title = title;
}

- (void)setMode:(Mode)mode atIndex:(NSUInteger)i {
    ModeButton *ithButton = [self.buttons objectAtIndex:i];
    ithButton.mode = mode;
}

- (void)setRadiusOuter:(CGFloat)radiusOuter radiusInner:(CGFloat)radiusInner {
//    CGRect bounds = self.bounds;
//    bounds.size = CGSizeMake(radiusOuter, radiusOuter);
//    self.bounds = bounds;
    self.widthConstraint.constant = radiusOuter;
    self.heightConstraint.constant = radiusInner;
    CGPoint arcCenter = CGPointMake(0, radiusOuter);
    for (ModeButton *ithButton in self.buttons) {
        ithButton.arcCenter = arcCenter;
        ithButton.radiusOuter = radiusOuter;
        ithButton.radiusInner = radiusInner;
    }
}

- (void)setAngleMax:(CGFloat)angleMax angleMin:(CGFloat)angleMin {
    CGFloat angleStep = (angleMax - angleMin) / self.numberOfButtons;
    CGFloat angle = angleMax;
    for (ModeButton *ithButton in self.buttons) {
        ithButton.angleMax = angle;
        ithButton.angleMin = angle - angleStep;
        angle -= angleStep;
    }
}

- (void)setColor:(UIColor *)color {
    _color = color;
    for (ModeButton *ithButton in self.buttons) {
        ithButton.buttonColor = color;
    }
}

- (void)setHighlightedColor:(UIColor *)highlightedColor {
    _highlightedColor = highlightedColor;
    for (ModeButton *ithButton in self.buttons) {
        ithButton.buttonHighlightedColor = highlightedColor;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (ModeButton *ithButton in self.buttons) {
        if ([ithButton pointInside:[self convertPoint:point toView:ithButton] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}

//- (void)setTitleFontSize:(CGFloat)titleFontSize; {
//    _titleFontSize = titleFontSize;
//    for (RadialButton *ithButton in self.buttons) {
//        ithButton.titleFontSize = titleFontSize;
//    }
//}

@end
