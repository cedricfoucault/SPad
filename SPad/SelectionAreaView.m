//
//  SelectionAreaView.m
//  SPad
//
//  Created by Cédric Foucault on 13/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "SelectionAreaView.h"
#import "UIView+LayoutConstraints.h"
#import "Geometry.h"
#import "ZoomManager.h"

static const CGFloat STROKE_WIDTH = 2;

@interface SelectionAreaView ()

@property (strong, nonatomic) UIColor *strokeColor;
@property (strong, nonatomic) UIColor *fillColor;
@property CGFloat strokeWidth;

@property (strong, nonatomic) UIBezierPath *startPath;
@property (strong, nonatomic) UIBezierPath *endPathReversed;

- (UIBezierPath *)path;

@end

@implementation SelectionAreaView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // init selection line
        _startPath = [[UIBezierPath alloc] init];
        _endPathReversed = [[UIBezierPath alloc] init];
        _strokeWidth = STROKE_WIDTH;
        _strokeColor = [UIColor colorWithRed:1.0 green:0.8 blue:0 alpha:1];
        _fillColor = [UIColor colorWithRed:1.0 green:0.8 blue:0 alpha:0.5];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIBezierPath *)path {
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGPathApply(self.startPath.CGPath, cgPath, _addLineOrMoveElementToPath);
//    UIBezierPath *path = [self.startPath copy];
    CGPathAddLineToPoint(cgPath, nil, self.endPathReversed.currentPoint.x, self.endPathReversed.currentPoint.y);
    CGPathApply([self.endPathReversed bezierPathByReversingPath].CGPath, cgPath, _addLineElementToPath);
    CGPathCloseSubpath(cgPath);
//    [path addLineToPoint:self.endPathReversed.currentPoint];
//    [path appendPath:[self.endPathReversed bezierPathByReversingPath]];
//    [path closePath];
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:cgPath];
//    NSLog(@"%@", path);
    CGPathRelease(cgPath);
    return path;
}

void _addLineElementToPath (void *path, const CGPathElement *elem) {
    switch (elem->type) {
        case kCGPathElementAddLineToPoint:
            CGPathAddLineToPoint(path, nil, elem->points[0].x, elem->points[0].y);
            break;
        default:
            break;
    }
}

void _addLineOrMoveElementToPath (void *path, const CGPathElement *elem) {
    switch (elem->type) {
        case kCGPathElementMoveToPoint:
            CGPathMoveToPoint(path, nil, elem->points[0].x, elem->points[0].y);
            break;
        case kCGPathElementAddLineToPoint:
            CGPathAddLineToPoint(path, nil, elem->points[0].x, elem->points[0].y);
            break;
        default:
            break;
    }
}

- (void)updateConstraintsWithCurrentPath {
    UIBezierPath *path = [self path];
    self.leftConstraint.constant = path.bounds.origin.x - self.strokeWidth / 2;
    self.topConstraint.constant = path.bounds.origin.y - self.strokeWidth / 2;
    self.widthConstraint.constant = path.bounds.size.width + self.strokeWidth;
    self.heightConstraint.constant = path.bounds.size.height + self.strokeWidth;
}

- (void)startSelectionAreaWithPoints:(CGPoint)a :(CGPoint)b {
//    CGFloat xMin = (a.x < b.x) ? a.x : b.x;
//    CGFloat xMax = (a.x > b.x) ? a.x : b.x;
//    CGFloat yMin = (a.y < b.y) ? a.y : b.y;
//    CGFloat yMax = (a.y > b.y) ? a.y : b.y;
//    self.leftConstraint.constant = xMin - self.strokeWidth / 2;
//    self.widthConstraint.constant = xMax - xMin + self.strokeWidth;
//    self.topConstraint.constant = yMin - self.strokeWidth / 2;
//    self.topConstraint.constant = yMax - yMin + self.strokeWidth;
    [self.startPath moveToPoint:a];
    [self.endPathReversed moveToPoint:b];
    [self updateConstraintsWithCurrentPath];
    [self setNeedsDisplay];
}

- (void)updateSelectionAreaWithPoints:(CGPoint)a :(CGPoint)b {
    // detect which point belongs to the start part end which point belongs to the end path
    CGPoint vA = CGPointSubtract(self.startPath.currentPoint, a);
    CGPoint vB = CGPointSubtract(self.startPath.currentPoint, b);
    CGFloat dA = vA.x * vA.x + vA.y * vA.y;
    CGFloat dB = vB.x * vB.x + vB.y * vB.y;
    if (dA < dB) {
        // a belongs to the start path, b to the end path
        [self.startPath addLineToPoint:a];
        [self.endPathReversed addLineToPoint:b];
    } else {
        // b belongs to the start path, a to the end path
        [self.startPath addLineToPoint:b];
        [self.endPathReversed addLineToPoint:a];
    }
    [self updateConstraintsWithCurrentPath];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Draw current path
    UIBezierPath *path = [self path];
    if (path) {
//        NSLog(@"%f %f %f %f", self.leftConstraint.constant, self.topConstraint.constant, self.widthConstraint.constant, self.heightConstraint.constant);
//        NSLog(@"%@", self.startPath);
//        NSLog(@"%@", self.endPathReversed);
//        NSLog(@"%@", path);
        path.lineWidth = self.strokeWidth / [[ZoomManager sharedManager] zoomScale];
        [self.strokeColor setStroke];
        [self.fillColor setFill];
        [path stroke];
        [path fill];
    }
}

@end
