//
//  HorizontalGuideline.m
//  PanTest
//
//  Created by Cédric Foucault on 03/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "HorizontalGuideline.h"

@interface HorizontalGuideline ()

@property (strong, nonatomic) NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation HorizontalGuideline

- (id)init {
    self = [super init];
    if (self) {
        [self _init];
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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init {
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
}

- (void)initConstraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.superview attribute:NSLayoutAttributeTop
                                                  multiplier:1 constant:self.frame.origin.y];
    _heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                   multiplier:1 constant:self.frame.size.height];
    [self addConstraint:_heightConstraint];
    [self.superview addConstraint:_topConstraint];
}

- (void)moveCenterY:(CGFloat)centerY inView:(UIView *)view {
    CGFloat centerYSuperview = [self.superview convertPoint:CGPointMake(0, centerY) fromView:view].y;
    self.topConstraint.constant = centerYSuperview - self.heightConstraint.constant / 2;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGPoint startOfGuideline = CGPointMake(self.bounds.origin.x, self.bounds.origin.y + self.heightConstraint.constant / 2);
    CGPoint endOfGuideline = CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y + self.heightConstraint.constant / 2);

    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    [[UIColor orangeColor] setStroke];
    [path moveToPoint:startOfGuideline];
    [path addLineToPoint:endOfGuideline];
    [path stroke];
}

@end
