//
//  ConstrainedPanGestureRecognizer.m
//  PanTest
//
//  Created by Cédric Foucault on 03/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ConstrainedPanGestureRecognizer.h"
#import "ZoomManager.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

static const CGFloat TOUCH_ALIGNMENT_TOLERANCE_DEFAULT = 120.0;
static const NSUInteger MINIMUM_NUMBER_OF_TOUCHES = 2;
static const NSUInteger MAXIMUM_NUMBER_OF_TOUCHES = 2;

@interface ConstrainedPanGestureRecognizer ()

@property (nonatomic, readwrite) ConstrainedPanGestureRecognizerDirection direction;

@end

@implementation ConstrainedPanGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init {
    _touchAlignmentTolerance = TOUCH_ALIGNMENT_TOLERANCE_DEFAULT;
    self.minimumNumberOfTouches = MINIMUM_NUMBER_OF_TOUCHES;
    self.maximumNumberOfTouches = MAXIMUM_NUMBER_OF_TOUCHES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self checkConstraintWithTouches:touches event:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self checkConstraintWithTouches:touches event:event];
}

- (void)checkConstraintWithTouches:(NSSet *)touches event:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStatePossible && [touches count] >= self.minimumNumberOfTouches) {
        CGFloat zoomScale = [[ZoomManager sharedManager] zoomScale];
        
        NSArray *touchesArray = [touches allObjects];
        UITouch *touch1 = [touchesArray objectAtIndex:0];
        UITouch *touch2 = [touchesArray objectAtIndex:1];
        CGPoint touch1Location = [touch1 locationInView:self.view];
        CGPoint touch2Location = [touch2 locationInView:self.view];
        CGPoint deltaVector = CGPointMake((touch1Location.x - touch2Location.x) * zoomScale, (touch1Location.y - touch2Location.y) * zoomScale);
        
//        NSLog(@"delta: %f %f", deltaVector.x, deltaVector.y);
        if (fabs(deltaVector.x) <= TOUCH_ALIGNMENT_TOLERANCE_DEFAULT / 2) {
            // assign directional constraint
            self.direction = ConstrainedPanGestureRecognizerDirectionHorizontal;
//            if (self.alignmentDelegate) {
//                [self.alignmentDelegate constrainedPanGestureRecognizerDidAlignHorizontally:self];
//            }
        } else if (fabs(deltaVector.y) <= TOUCH_ALIGNMENT_TOLERANCE_DEFAULT / 2) {
            // assign directional constraint
            self.direction = ConstrainedPanGestureRecognizerDirectionVertical;
//            if (self.alignmentDelegate) {
//                [self.alignmentDelegate constrainedPanGestureRecognizerDidAlignVertically:self];
//            }
        } else {
            // cancel movement if constraint check was not passed
            self.state = UIGestureRecognizerStateCancelled;
        }
    }
}

- (CGPoint)translationInView:(UIView *)view {
    CGPoint translation = [super translationInView:view];
    switch (self.direction) {
        case ConstrainedPanGestureRecognizerDirectionHorizontal:
            translation.y = 0;
            break;
            
        case ConstrainedPanGestureRecognizerDirectionVertical:
            translation.x = 0;
            break;
    }
    return translation;
}


@end
