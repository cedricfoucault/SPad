//
//  DiagonalSwipeRecognizer.h
//  SPad
//
//  Created by Cédric Foucault on 07/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DiagonalSwipeGestureRecognizerDirection) {
    DiagonalSwipeGestureRecognizerDirectionUpLeft,
    DiagonalSwipeGestureRecognizerDirectionUpRight,
    DiagonalSwipeGestureRecognizerDirectionDownRight,
    DiagonalSwipeGestureRecognizerDirectionDownLeft
};

@interface DiagonalSwipeGestureRecognizer : UIGestureRecognizer

@property (nonatomic) DiagonalSwipeGestureRecognizerDirection direction;


@end

