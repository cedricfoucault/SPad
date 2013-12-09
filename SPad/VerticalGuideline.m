//
//  VerticalGuideline.m
//  PanTest
//
//  Created by Cédric Foucault on 03/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "VerticalGuideline.h"

static const CGFloat FRAME_WIDTH = 10;

@interface VerticalGuideline ()

@property (strong, nonatomic) NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;

@end

@implementation VerticalGuideline

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
    _leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.superview attribute:NSLayoutAttributeLeft
                                                     multiplier:1 constant:self.frame.origin.x];
    _widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1 constant:self.frame.size.width];
    [self addConstraint:_widthConstraint];
    [self.superview addConstraint:_leftConstraint];
}

- (void)moveCenterX:(CGFloat)centerX inView:(UIView *)view {
    CGFloat centerXSuperview = [self.superview convertPoint:CGPointMake(centerX, 0) fromView:view].x;
    self.leftConstraint.constant = centerXSuperview - self.widthConstraint.constant / 2;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGPoint startOfGuideline = CGPointMake(self.bounds.origin.x + self.widthConstraint.constant / 2, self.bounds.origin.y);
    CGPoint endOfGuideline = CGPointMake(self.bounds.origin.x + + self.widthConstraint.constant / 2, self.bounds.origin.y + self.bounds.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    [[UIColor orangeColor] setStroke];
    [path moveToPoint:startOfGuideline];
    [path addLineToPoint:endOfGuideline];
    [path stroke];
}

@end
