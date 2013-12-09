//
//  DiagonalSwipeRecognizer.m
//  SPad
//
//  Created by Cédric Foucault on 07/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "DiagonalSwipeRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

static const CGFloat TOUCH_MOVE_EFFECT_DIST = 30;

@interface DiagonalSwipeGestureRecognizer ()

@property (nonatomic) CGPoint touchStartPoint;

@end

@implementation DiagonalSwipeGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.touchStartPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchEndPoint = [touch locationInView:self.view];
    
    CGPoint deltaVector = CGPointMake(touchEndPoint.x - self.touchStartPoint.x, touchEndPoint.y - self.touchStartPoint.y);
    if (self.state == UIGestureRecognizerStatePossible) {
        switch (self.direction) {
            case DiagonalSwipeGestureRecognizerDirectionUpLeft:
                if (deltaVector.x < -TOUCH_MOVE_EFFECT_DIST && deltaVector.y < -TOUCH_MOVE_EFFECT_DIST) {
                    self.state = UIGestureRecognizerStateRecognized;
                }
                break;
            case DiagonalSwipeGestureRecognizerDirectionUpRight:
                if (deltaVector.x > TOUCH_MOVE_EFFECT_DIST && deltaVector.y < -TOUCH_MOVE_EFFECT_DIST) {
                    self.state = UIGestureRecognizerStateRecognized;
                }
                break;
            case DiagonalSwipeGestureRecognizerDirectionDownRight:
                if (deltaVector.x > TOUCH_MOVE_EFFECT_DIST && deltaVector.y > TOUCH_MOVE_EFFECT_DIST) {
                    self.state = UIGestureRecognizerStateRecognized;
                }
                break;
            case DiagonalSwipeGestureRecognizerDirectionDownLeft:
                if (deltaVector.x < -TOUCH_MOVE_EFFECT_DIST && deltaVector.y > TOUCH_MOVE_EFFECT_DIST) {
                    self.state = UIGestureRecognizerStateRecognized;
                }
                break;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchEndPoint = [touch locationInView:self.view];
    
    CGPoint deltaVector = CGPointMake(touchEndPoint.x - self.touchStartPoint.x, touchEndPoint.y - self.touchStartPoint.y);
    if (self.state == UIGestureRecognizerStatePossible) {
        switch (self.direction) {
            case DiagonalSwipeGestureRecognizerDirectionUpLeft:
                if (deltaVector.x < -TOUCH_MOVE_EFFECT_DIST && deltaVector.y < -TOUCH_MOVE_EFFECT_DIST) {
                    self.state = UIGestureRecognizerStateRecognized;
                } else {
                    self.state = UIGestureRecognizerStateFailed;
                }
                break;
            case DiagonalSwipeGestureRecognizerDirectionUpRight:
                if (deltaVector.x > TOUCH_MOVE_EFFECT_DIST && deltaVector.y < -TOUCH_MOVE_EFFECT_DIST) {
                    self.state = UIGestureRecognizerStateRecognized;
                } else {
                    self.state = UIGestureRecognizerStateFailed;
                }
                break;
            case DiagonalSwipeGestureRecognizerDirectionDownRight:
                if (deltaVector.x > TOUCH_MOVE_EFFECT_DIST && deltaVector.y > TOUCH_MOVE_EFFECT_DIST) {
                    self.state = UIGestureRecognizerStateRecognized;
                } else {
                    self.state = UIGestureRecognizerStateFailed;
                }
                break;
            case DiagonalSwipeGestureRecognizerDirectionDownLeft:
                if (deltaVector.x < -TOUCH_MOVE_EFFECT_DIST && deltaVector.y > TOUCH_MOVE_EFFECT_DIST) {
                    self.state = UIGestureRecognizerStateRecognized;
                } else {
                    self.state = UIGestureRecognizerStateFailed;
                }
                break;
        }
    }
}


@end
