//
//  SpadButton.h
//  SPad
//
//  Created by Cédric Foucault on 07/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeManager.h"

@interface ModeButton : UIControl

@property (nonatomic) Mode mode;

// button parameters
@property (nonatomic) CGPoint arcCenter;
@property (nonatomic) CGFloat radiusInner;
@property (nonatomic) CGFloat radiusOuter;
@property (nonatomic) CGFloat angleMin; // radians
@property (nonatomic) CGFloat angleMax; // radians
@property (copy, nonatomic) NSString *title;
@property (nonatomic) CGFloat titleFontSize;
@property (strong, nonatomic) UIColor *buttonColor;
@property (strong, nonatomic) UIColor *buttonHighlightedColor;


// readonly parameters
@property (readonly, nonatomic) CGFloat widthButton;
@property (readonly, nonatomic) CGFloat angleButton; //radians
@property (readonly, nonatomic) CGFloat xFrame;
@property (readonly, nonatomic) CGFloat yFrame;
@property (readonly, nonatomic) CGFloat widthFrame;
@property (readonly, nonatomic) CGFloat heightFrame;

- (id)initWithCenter:(CGPoint)center radiusInner:(CGFloat)radiusInner outer:(CGFloat)radiusOuter angleMin:(CGFloat)angleMin max:(CGFloat)angleMax;

- (void)initConstraints;

@end
