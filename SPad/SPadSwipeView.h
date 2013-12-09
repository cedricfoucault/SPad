//
//  SPadSwipeView.h
//  SPad
//
//  Created by Cédric Foucault on 07/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LayoutConstraints.h"

@interface SPadSwipeView : UIView

@property (nonatomic) CGPoint jointCenter;
@property (nonatomic) CGFloat radiusInner;
@property (nonatomic) CGFloat radiusOuter;
@property (nonatomic) CGFloat angleMin; // radians
@property (nonatomic) CGFloat angleMax; // radians
@property (nonatomic) CGFloat xFromJoint;

@property (strong, nonatomic, readonly) UIImageView *SWArrow;
@property (strong, nonatomic, readonly) UIImageView *NEArrow;
@property (strong, nonatomic, readonly) UIImageView *NWArrow;
@property (strong, nonatomic, readonly) UIImageView *SEArrow;
//- (void)initConstraints;

@end
