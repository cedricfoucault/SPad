//
//  SPadView.h
//  SPad
//
//  Created by Cédric Foucault on 07/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LayoutConstraints.h"

@interface SPadView : UIView

@property (weak, nonatomic) UIView *view;

- (void)fitToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)close;
- (void)discloseWithTouchLocation:(CGPoint)location;

@end
