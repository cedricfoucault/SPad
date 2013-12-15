//
//  Geometry.h
//  SPad
//
//  Created by Cédric Foucault on 13/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

// Acknowledgement: credit to https://gist.github.com/jon/292330

#import <Foundation/Foundation.h>

extern CGPoint CGPointScale(CGPoint A, double b);
extern CGPoint CGPointAdd(CGPoint a, CGPoint b);
extern CGPoint CGPointSubtract(CGPoint a, CGPoint b);
extern double CGPointCross(CGPoint a, CGPoint b);
extern double CGPointDot(CGPoint a, CGPoint b);
extern double CGPointMagnitude(CGPoint pt);
extern CGPoint CGPointNormalize(CGPoint pt);

extern BOOL LineSegmentsIntersect(CGPoint a1, CGPoint a2, CGPoint b1, CGPoint b2);
