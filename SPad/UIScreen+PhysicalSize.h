//
//  UIScreen+PhysicalSize.h
//  Spad
//
//  Created by Cédric Foucault on 03/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (PhysicalSize)

- (CGFloat) mmFromPt:(CGFloat)pts;
- (CGFloat) ptFromMm:(CGFloat)mms;

@end
