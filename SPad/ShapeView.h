//
//  ShapeView.h
//  SPad
//
//  Created by Cédric Foucault on 20/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LayoutConstraints.h"

@interface ShapeView : UIView

@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) UIColor *borderColor;
@property (nonatomic) UIColor *fillColor;

- (void)switchSelection;
- (void)select;
- (void)deselect;
- (ShapeView *)copyShape;
- (BOOL)isIntersectedBySegment:(CGPoint)p1 :(CGPoint)p2;

+ (CGPoint)centroidOfShapes:(NSSet *)shapes;
+ (void)placeShapes:(NSSet *)shapes toCentroid:(CGPoint)centroid;

@end
