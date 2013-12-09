//
//  LeftBezelSwipeGestureRecognizer.m
//  SPad
//
//  Created by Cédric Foucault on 08/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "FromLeftBezelSwipeGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

static const CGFloat BEZEL_TOLERANCE = 10;
static const CGFloat X_MIN_SWIPE_DISTANCE = 50;
static const CGFloat Y_MAX_SWIPE_DISTANCE = 20;

@interface FromLeftBezelSwipeGestureRecognizer ()

@property (nonatomic) CGPoint startPoint;

@end

@implementation FromLeftBezelSwipeGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.startPoint = [[touches anyObject] locationInView:self.view];
    if (![self pointIsNearLeftBezel:self.startPoint]) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    CGPoint newPoint = [[touches anyObject] locationInView:self.view];
    if ([self pointIsFarStraightRightOfBezel:newPoint]) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateFailed;
}

- (BOOL)pointIsNearLeftBezel:(CGPoint)point {
    return fabs(point.x - self.view.bounds.origin.x) <= BEZEL_TOLERANCE;
}

- (BOOL)pointIsFarStraightRightOfBezel:(CGPoint)point {
    return fabs(point.x - self.startPoint.x) >= X_MIN_SWIPE_DISTANCE && fabs(point.y - self.startPoint.y) <= Y_MAX_SWIPE_DISTANCE;
}

@end
