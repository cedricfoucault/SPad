//
//  ZoomManager.m
//  PanTest
//
//  Created by Cédric Foucault on 07/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ZoomManager.h"

@interface ZoomManager ()

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ZoomManager

+ (id)sharedManager {
    static ZoomManager *sharedManager = nil;
    if (!sharedManager) {
        sharedManager = [[self alloc] init];
    }
    return sharedManager;
}

- (CGFloat)zoomScale {
    return self.scrollView.zoomScale;
}

@end
