//
//  ToLeftBezelSwipeGestureRecognizer.m
//  SPad
//
//  Created by Cédric Foucault on 08/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ToLeftBezelSwipeGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

static const CGFloat BEZEL_TOLERANCE = 10;
static const CGFloat X_MAX_START = 180;
static const CGFloat X_MIN_START = 20;
static const CGFloat Y_MAX_SWIPE_DISTANCE = 55;

@interface ToLeftBezelSwipeGestureRecognizer ()

@property (nonatomic) CGPoint startPoint;

@end

@implementation ToLeftBezelSwipeGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.startPoint = [[touches anyObject] locationInView:self.view];
    if (![self pointIsNearLeftBezelStart:self.startPoint]) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    CGPoint newPoint = [[touches anyObject] locationInView:self.view];
    if ([self pointIsNearLeftBezelEndStraight:newPoint]) {
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

- (BOOL)pointIsNearLeftBezelEndStraight:(CGPoint)point {
//    NSLog(@"%f", fabs(point.y - self.startPoint.y));
    return fabs(point.x - self.view.bounds.origin.x) <= BEZEL_TOLERANCE &&
            fabs(point.y - self.startPoint.y) <= Y_MAX_SWIPE_DISTANCE;
}

- (BOOL)pointIsNearLeftBezelStart:(CGPoint)point {
    return fabs(point.x - self.view.bounds.origin.x) <= X_MAX_START &&
            fabs(point.x - self.view.bounds.origin.x) >= X_MIN_START;
}

@end
