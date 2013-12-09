//
//  HorizontalGuideline.h
//  PanTest
//
//  Created by Cédric Foucault on 03/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LayoutConstraints.h"

@interface HorizontalGuideline : UIView

- (void)moveCenterY:(CGFloat)centerY inView:(UIView *)view;

@end
