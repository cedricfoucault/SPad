//
//  UIView+LayoutConstraints.h
//  SPad
//
//  Created by Cédric Foucault on 08/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LayoutConstraints)

@property (assign, nonatomic, readonly) NSLayoutConstraint *leftConstraint;
@property (assign, nonatomic, readonly) NSLayoutConstraint *topConstraint;
@property (assign, nonatomic, readonly) NSLayoutConstraint *widthConstraint;
@property (assign, nonatomic, readonly) NSLayoutConstraint *heightConstraint;

-(void)initConstraints;
- (CGPoint)centerPoint;
- (void)moveCenterX:(CGFloat)centerX Y:(CGFloat)centerY;
- (void)translateX:(CGFloat)x Y:(CGFloat)y;

@end
