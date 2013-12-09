//
//  SPadSwipeView.m
//  SPad
//
//  Created by Cédric Foucault on 07/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "SPadSwipeView.h"

@interface SPadSwipeView ()

//@property (strong, nonatomic) NSLayoutConstraint *leftConstraint;
//@property (strong, nonatomic) NSLayoutConstraint *topConstraint;
//@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
//@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

//@property (strong, nonatomic) NSLayoutConstraint *leftConstraintSWArrow;
//@property (strong, nonatomic) NSLayoutConstraint *topConstraintSWArrow;
//@property (strong, nonatomic) NSLayoutConstraint *widthConstraintSWArrow;
//@property (strong, nonatomic) NSLayoutConstraint *heightConstraintSWArrow;

@property (strong, nonatomic) UIImageView *SWArrow;
@property (strong, nonatomic) UIImageView *NEArrow;
@property (strong, nonatomic) UIImageView *NWArrow;
@property (strong, nonatomic) UIImageView *SEArrow;

@property (nonatomic) CGFloat arrowLength;

@end

@implementation SPadSwipeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init {
    self.backgroundColor = [UIColor clearColor];
    
    self.SWArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SWArrow"]];
    self.SWArrow.highlightedImage = [UIImage imageNamed:@"SWArrowHighlighted"];
    self.arrowLength = self.SWArrow.frame.size.width * sqrt(2);
    [self addSubview:self.SWArrow];
    [self.SWArrow initConstraints];
    self.NEArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NEArrow"]];
    self.NEArrow.highlightedImage = [UIImage imageNamed:@"NEArrowHighlighted"];
    [self addSubview:self.NEArrow];
    [self.NEArrow initConstraints];
    self.NWArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NWArrow"]];
    self.NWArrow.highlightedImage = [UIImage imageNamed:@"NWArrowHighlighted"];
    [self addSubview:self.NWArrow];
    [self.NWArrow initConstraints];
    self.SEArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEArrow"]];
    self.SEArrow.highlightedImage = [UIImage imageNamed:@"SEArrowHighlighted"];
    [self addSubview:self.SEArrow];
    [self.SEArrow initConstraints];
}

- (void)_updateConstraints {
    self.leftConstraint.constant = self.jointCenter.x + self.xFromJoint;
    self.topConstraint.constant = self.jointCenter.y + self.yFromJoint;
    self.widthConstraint.constant = self.widthFrame;
    self.heightConstraint.constant = self.heightFrame;
    
    CGPoint innerMidPoint = [self innerMidPoint];
    self.SWArrow.leftConstraint.constant = self.arrowOffset / sqrt(2);
    self.SWArrow.topConstraint.constant = innerMidPoint.x + innerMidPoint.y - self.arrowOffset / sqrt(2) - self.SWArrow.heightConstraint.constant;
    self.NEArrow.leftConstraint.constant = innerMidPoint.x - self.arrowOffset / sqrt(2) - self.NEArrow.widthConstraint.constant;
    self.NEArrow.topConstraint.constant = innerMidPoint.y + self.arrowOffset / sqrt(2);
    self.NWArrow.leftConstraint.constant = self.arrowOffset / sqrt(2);
    self.NWArrow.topConstraint.constant = innerMidPoint.y + self.arrowOffset / sqrt(2);
    self.SEArrow.leftConstraint.constant = innerMidPoint.x - self.arrowOffset / sqrt(2) - self.SEArrow.widthConstraint.constant;
    self.SEArrow.topConstraint.constant = innerMidPoint.x + innerMidPoint.y - self.arrowOffset / sqrt(2) - self.SEArrow.heightConstraint.constant;
}

- (CGFloat)arrowOffset {
    return (sqrt(2) * [self innerMidPoint].x - 2 * self.arrowLength) / 4;
}

- (void)setJointCenter:(CGPoint)jointCenter {
    _jointCenter = jointCenter;
    [self _updateConstraints];
}

- (void)setRadiusInner:(CGFloat)radiusInner {
    _radiusInner = radiusInner;
    [self _updateConstraints];
}

- (void)setRadiusOuter:(CGFloat)radiusOuter {
    _radiusOuter = radiusOuter;
    [self _updateConstraints];
}

- (void)setAngleMin:(CGFloat)angleMin {
    _angleMin = angleMin;
    [self _updateConstraints];
}

- (void)setAngleMax:(CGFloat)angleMax {
    _angleMax = angleMax;
    [self _updateConstraints];
}

- (CGPoint)innerMidPoint {
    CGFloat angleMid = (self.angleMax + self.angleMin) / 2;
    CGFloat xInnerMidFromJoint = self.radiusInner * cos(angleMid);
    CGFloat yInnerMidFromJoint = - self.radiusInner * sin(angleMid);
    CGFloat xInnerMid = xInnerMidFromJoint - self.xFromJoint;
    CGFloat yInnerMid = yInnerMidFromJoint - self.yFromJoint;
    return CGPointMake(xInnerMid, yInnerMid);
}

- (CGFloat)yFromJoint {
    return - self.radiusInner * sin(self.angleMax);
}

- (CGFloat)widthFrame {
    return self.radiusInner * cos(self.angleMin) - self.xFromJoint;
}

- (CGFloat)heightFrame {
    return (- self.xFromJoint * tan(self.angleMin)) - self.yFromJoint;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self isInside:point];
}

- (BOOL)isInside:(CGPoint)p {
    // get location in (r, teta) coordinate system
    CGFloat xpFromJoint = self.xFromJoint + p.x;
    CGFloat ypFromJoint = self.yFromJoint + p.y;
    CGFloat r = sqrt((xpFromJoint * xpFromJoint + ypFromJoint * ypFromJoint));
    CGFloat teta = acos(xpFromJoint / r);
    return p.x >= 0.0 && r <= self.radiusInner && teta >= self.angleMin && teta <= self.angleMax;
}

@end
