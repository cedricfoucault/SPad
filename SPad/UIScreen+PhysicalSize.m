//
//  UIScreen+PhysicalSize.m
//  Spad
//
//  Created by Cédric Foucault on 03/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "UIScreen+PhysicalSize.h"
#import "UIDevice+Hardware.h"

@implementation UIScreen (PhysicalSize)

- (CGFloat) mmFromPt:(CGFloat)pts {
    CGRect screenRect = [self applicationFrame];
    CGFloat displayDiagonalPt = sqrt(screenRect.size.width * screenRect.size.width + screenRect.size.height * screenRect.size.height);
    CGFloat displayDiagonalMm = [[UIDevice currentDevice] displayDiagonalMm];
    CGFloat ptMmSize = displayDiagonalMm / displayDiagonalPt;
    return pts * ptMmSize;
}

- (CGFloat)ptFromMm:(CGFloat)mms {
    CGRect screenRect = [self applicationFrame];
    CGFloat displayDiagonalPt = sqrt(screenRect.size.width * screenRect.size.width + screenRect.size.height * screenRect.size.height);
    CGFloat displayDiagonalMm = [[UIDevice currentDevice] displayDiagonalMm];
    CGFloat mmPtSize = displayDiagonalPt / displayDiagonalMm;
    return mms * mmPtSize;
}

@end
