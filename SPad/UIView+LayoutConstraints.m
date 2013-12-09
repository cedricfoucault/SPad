//
//  UIView+LayoutConstraints.m
//  SPad
//
//  Created by Cédric Foucault on 08/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "UIView+LayoutConstraints.h"
#import <objc/runtime.h>

//static void *_leftConstraint;
//static void *_topConstraint;
//static void *_widthConstraint;
//static void *_heightConstraint;
NSString * const kLeftConstraint = @"kLeftConstraint";
NSString * const kTopConstraint = @"kTopConstraint";
NSString * const kWidthConstraint = @"kWidthConstraint";
NSString * const kHeightConstraint = @"kHeightConstraint";

@implementation UIView (LayoutConstraints)

- (NSLayoutConstraint *)leftConstraint {
    return objc_getAssociatedObject(self, (__bridge const void *)(kLeftConstraint));
}

- (NSLayoutConstraint *)topConstraint {
    return objc_getAssociatedObject(self, (__bridge const void *)(kTopConstraint));
}

- (NSLayoutConstraint *)widthConstraint {
    return objc_getAssociatedObject(self, (__bridge const void *)(kWidthConstraint));
}

- (NSLayoutConstraint *)heightConstraint {
    return objc_getAssociatedObject(self, (__bridge const void *)(kHeightConstraint));
}


- (void)initConstraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.superview attribute:NSLayoutAttributeLeft
                                                  multiplier:1 constant:x];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.superview attribute:NSLayoutAttributeTop
                                                 multiplier:1 constant:y];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                   multiplier:1 constant:width];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1 constant:height];
    
    objc_setAssociatedObject(self, (__bridge const void *)(kLeftConstraint), leftConstraint, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, (__bridge const void *)(kTopConstraint), topConstraint, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, (__bridge const void *)(kWidthConstraint), widthConstraint, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, (__bridge const void *)(kHeightConstraint), heightConstraint, OBJC_ASSOCIATION_ASSIGN);
    [self addConstraints:@[self.widthConstraint, self.heightConstraint]];
    [self.superview addConstraints:@[self.leftConstraint, self.topConstraint]];
}

- (CGPoint)centerPoint {
    return CGPointMake(self.leftConstraint.constant + self.widthConstraint.constant / 2,
                       self.topConstraint.constant + self.heightConstraint.constant / 2);
}

- (void)moveCenterX:(CGFloat)centerX Y:(CGFloat)centerY {
    self.leftConstraint.constant = centerX - self.widthConstraint.constant / 2;
    self.topConstraint.constant = centerY - self.heightConstraint.constant / 2;
}

- (void)translateX:(CGFloat)x Y:(CGFloat)y {
    self.leftConstraint.constant += x;
    self.topConstraint.constant += y;
}

@end
