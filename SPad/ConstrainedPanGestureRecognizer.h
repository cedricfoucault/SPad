//
//  ConstrainedPanGestureRecognizer.h
//  PanTest
//
//  Created by Cédric Foucault on 03/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ConstrainedPanGestureRecognizerDirection) {
    ConstrainedPanGestureRecognizerDirectionHorizontal,
    ConstrainedPanGestureRecognizerDirectionVertical
};

//@protocol AlignmentDelegate;

@interface ConstrainedPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic) CGFloat touchAlignmentTolerance;
@property (nonatomic, readonly) ConstrainedPanGestureRecognizerDirection direction;
//@property (weak, nonatomic) NSObject<AlignmentDelegate> *alignmentDelegate;

@end

//@protocol AlignmentDelegate <NSObject>
//
//- (void)constrainedPanGestureRecognizerDidAlignHorizontally:(ConstrainedPanGestureRecognizer *)gestureRecognizer;
//- (void)constrainedPanGestureRecognizerDidAlignVertically:(ConstrainedPanGestureRecognizer *)gestureRecognizer;
//
//@end
