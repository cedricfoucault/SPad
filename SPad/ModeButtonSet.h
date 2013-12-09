//
//  SpadButtonSet.h
//
//  Created by Cédric Foucault on 02/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeManager.h"

@interface ModeButtonSet : UIView

@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *highlightedColor;
//@property (nonatomic) CGFloat titleFontSize;

- (id)initWithNumberOfButtons:(NSUInteger)count;
- (void)initConstraints;

- (void)setTitle:(NSString *)title atIndex:(NSUInteger)i;
- (void)setMode:(Mode)mode atIndex:(NSUInteger)i;
- (void)setAngleMax:(CGFloat)angleMax angleMin:(CGFloat)angleMin;
- (void)setRadiusOuter:(CGFloat)radiusOuter radiusInner:(CGFloat)radiusInner;

- (void)moveOriginX:(CGFloat)originX Y:(CGFloat)originY;
- (void)moveCenterX:(CGFloat)centerX Y:(CGFloat)centerY;

@end
