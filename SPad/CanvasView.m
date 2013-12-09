//
//  CanvasView.m
//  SPad
//
//  Created by Cédric Foucault on 24/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "CanvasView.h"
#import "ShapeView.h"

@interface CanvasView ()

//@property (strong, nonatomic) NSMutableArray *shapes;

@end

@implementation CanvasView

- (NSArray *)shapeSubviews {
    NSMutableArray *shapeSubviews = [[NSMutableArray alloc] initWithCapacity:[self.subviews count]];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[ShapeView class]]) {
            [shapeSubviews addObject:subview];
        }
    }
    return (NSArray *)shapeSubviews;
}

@end
