//
//  ShapeView.m
//  SPad
//
//  Created by Cédric Foucault on 20/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ShapeView.h"
#import "SelectionManager.h"
#import "ModeManager.h"
#import "TouchDownGestureRecognizer.h"
#import "ConstrainedPanGestureRecognizer.h"
#import "GuidelineManager.h"

@interface ShapeView ()

@property (nonatomic) CGFloat selectBorderWidth;
@property (strong, nonatomic) UIColor *selectBorderColor;
@property (nonatomic, getter = isSelected) BOOL selected;

@property (strong, nonatomic) NSArray *customGestureRecognizers;

@end

@implementation ShapeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _borderWidth = 3.0;
        _selectBorderWidth = 4.0;
        _size = CGSizeMake(frame.size.width - 2 * _borderWidth - 2 * _selectBorderWidth,
                           frame.size.height - 2 * _borderWidth - 2 * _selectBorderWidth);
        _borderColor = [UIColor blackColor];
        _selectBorderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0 alpha:1];
        _fillColor = [UIColor lightGrayColor];
        _selected = NO;
        
        // init gesture recognizers
        NSMutableArray *gestureRecognizers = [[NSMutableArray alloc] initWithCapacity:N_MODES];
        for (NSUInteger i = 0; i < N_MODES; i++) {
            [gestureRecognizers addObject:[[NSMutableArray alloc] init]];
        }
        // init copy gesture recognizers
        NSMutableArray *gestureRecognizersForCopyMode = [gestureRecognizers objectAtIndex:ModeCopy];
        TouchDownGestureRecognizer *copyGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(handleCopyGesture:)];
        copyGestureRecognizer.enabled = NO;
        [self addGestureRecognizer:copyGestureRecognizer];
        [gestureRecognizersForCopyMode addObject:copyGestureRecognizer];
        // init delete gesture recognizers
        NSMutableArray *gestureRecognizersForDeleteMode = [gestureRecognizers objectAtIndex:ModeDelete];
        UITapGestureRecognizer *deleteGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDeleteGesture:)];
        deleteGestureRecognizer.enabled = NO;
        [self addGestureRecognizer:deleteGestureRecognizer];
        [gestureRecognizersForDeleteMode addObject:deleteGestureRecognizer];
        // init move gesture recognizers
        NSMutableArray *gestureRecognizersForMoveMode = [gestureRecognizers objectAtIndex:ModeMove];
        UIPanGestureRecognizer *move1FingerGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove1Finger:)];
        move1FingerGestureRecognizer.maximumNumberOfTouches = 1;
        move1FingerGestureRecognizer.minimumNumberOfTouches = 1;
        move1FingerGestureRecognizer.enabled = NO;
        [self addGestureRecognizer:move1FingerGestureRecognizer];
        [gestureRecognizersForMoveMode addObject:move1FingerGestureRecognizer];
        ConstrainedPanGestureRecognizer *move2FingersGestureRecognizer = [[ConstrainedPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove2Fingers:)];
        move2FingersGestureRecognizer.maximumNumberOfTouches = 2;
        move2FingersGestureRecognizer.minimumNumberOfTouches = 2;
        move2FingersGestureRecognizer.enabled = NO;
        [self addGestureRecognizer:move2FingersGestureRecognizer];
        [gestureRecognizersForMoveMode addObject:move2FingersGestureRecognizer];
        // init transform gesture recognizers
        NSMutableArray *gestureRecognizersForTransformMode = [gestureRecognizers objectAtIndex:ModeTransform];
        UIPinchGestureRecognizer *transformPinchGestureRecgonizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleTransformPinch:)];
        transformPinchGestureRecgonizer.enabled = NO;
        [self addGestureRecognizer:transformPinchGestureRecgonizer];
        [gestureRecognizersForTransformMode addObject:transformPinchGestureRecgonizer];
        
        // keep all gesture recognizers in property
        _customGestureRecognizers = (NSArray *)gestureRecognizers;
        // init mode change target action
        ModeManager *manager = [ModeManager sharedManager];
        [manager addTarget:self action:@selector(modeChangedFromMode:toMode:)];
    }
    return self;
}

- (void)select {
    if (!self.isSelected) {
        self.selected = YES;
        [self setNeedsDisplay];
        [[SelectionManager sharedManager] addObject:self];
    }
}

- (void)deselect {
    if (self.isSelected) {
        self.selected = NO;
        [self setNeedsDisplay];
        [[SelectionManager sharedManager] removeObject:self];
    }
}

- (ShapeView *)copyShape {
    ShapeView *newShape = [[self.class alloc] initWithFrame:self.frame];
    newShape.borderWidth = self.borderWidth;
    newShape.size = CGSizeMake(self.size.width, self.size.height);
    newShape.borderColor = self.borderColor;
    newShape.fillColor = self.fillColor;
    return newShape;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat borderPadding = self.borderWidth + self.selectBorderWidth;
    CGSize size = [self size];
    CGRect rectShape = CGRectMake(self.bounds.origin.x + borderPadding,
                                  self.bounds.origin.y + borderPadding,
                                  size.width,
                                  size.height);
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:rectShape];
    rectPath.lineWidth = self.borderWidth;
    [self.borderColor setStroke];
    [self.fillColor setFill];
    [rectPath stroke];
    [rectPath fill];
    
    if (self.isSelected) {
        CGRect selectRect = CGRectMake(self.bounds.origin.x + self.selectBorderWidth,
                                       self.bounds.origin.y + self.selectBorderWidth,
                                       size.width + 2 * self.borderWidth,
                                       size.height + 2 * self.borderWidth);
        UIBezierPath *selectRectPath = [UIBezierPath bezierPathWithRect:selectRect];
        selectRectPath.lineWidth = self.selectBorderWidth;
        [self.selectBorderColor setStroke];
        [selectRectPath stroke];
    }
}

- (void)modeChangedFromMode:(ModeObject *)fromMode toMode:(ModeObject *)toMode {
//    NSLog(@"Mode changed from mode %u to mode %u", fromMode.mode, toMode.mode);
    NSArray *oldGestureRecognizers = [self.customGestureRecognizers objectAtIndex:fromMode.mode];
    NSArray *newGestureRecognizers = [self.customGestureRecognizers objectAtIndex:toMode.mode];
    for (UIGestureRecognizer *oldGestureRecognizer in oldGestureRecognizers) {
        oldGestureRecognizer.enabled = NO;
    }
    for (UIGestureRecognizer *newGestureRecognizer in newGestureRecognizers) {
        newGestureRecognizer.enabled = YES;
    }
}

- (void)handleCopyGesture:(TouchDownGestureRecognizer *)touchDownGestureRecognizer {
    if (touchDownGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self switchSelection];
    }
}

- (void)handleDeleteGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self removeFromSuperview];
    }
}

- (void)handleMove1Finger:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:sender.view];
        [self translateX:translation.x Y:translation.y];
        [sender setTranslation:CGPointZero inView:sender.view];
    }
}

- (void)handleMove2Fingers:(ConstrainedPanGestureRecognizer *)sender {
    GuidelineManager *guidelineManager = [GuidelineManager sharedManager];
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:sender.view];
        if (sender.direction == ConstrainedPanGestureRecognizerDirectionHorizontal) {
            [self translateX:translation.x Y:0];
            // show alignment guideline
            [guidelineManager.horizontalGuideline moveCenterY:(self.bounds.origin.y + self.heightConstraint.constant / 2) inView:sender.view];
            guidelineManager.horizontalGuideline.hidden = NO;
        } else if (sender.direction == ConstrainedPanGestureRecognizerDirectionVertical) {
            //            NSLog(@"VERTICAL translation: %f %f", translation.x, translation.y);
            [self translateX:0 Y:translation.y];
            // show alignment guideline
            [guidelineManager.verticalGuideline moveCenterX:(self.bounds.origin.x + self.widthConstraint.constant / 2) inView:sender.view];
            guidelineManager.verticalGuideline.hidden = NO;
        }
        [sender setTranslation:CGPointZero inView:sender.view];
    } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        // hide alignment guideline
        guidelineManager.horizontalGuideline.hidden = YES;
        guidelineManager.verticalGuideline.hidden = YES;
    }
}

- (void)handleTransformPinch:(UIPinchGestureRecognizer *)sender {
    GuidelineManager *guidelineManager = [GuidelineManager sharedManager];
    if (sender.state == UIGestureRecognizerStateChanged) {
        [self scale:sender.scale];
        sender.scale = 1;
        [self setNeedsDisplay];
        // show alignment guidelines
        [guidelineManager.horizontalGuideline moveCenterY:(self.bounds.origin.x + self.heightConstraint.constant / 2) inView:sender.view];
        guidelineManager.horizontalGuideline.hidden = NO;
        [guidelineManager.verticalGuideline moveCenterX:(self.bounds.origin.y + self.widthConstraint.constant / 2) inView:sender.view];
        guidelineManager.verticalGuideline.hidden = NO;
    } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        // hide alignment guidelines
        guidelineManager.horizontalGuideline.hidden = YES;
        guidelineManager.verticalGuideline.hidden = YES;
    }
}

- (void)scale:(CGFloat)scale {
    CGSize size = [self size];
    CGFloat deltaX = size.width * (1 - scale);
    CGFloat deltaY = size.height * (1 - scale);
    size.width *= scale;
    size.height *= scale;
    [self resize:size];
    [self translateX:(deltaX / 2) Y:(deltaY / 2)];
}


- (CGSize)size {
    CGFloat width = self.widthConstraint.constant - 2 * self.borderWidth - 2 * self.selectBorderWidth;
    CGFloat height = self.heightConstraint.constant - 2 * self.borderWidth - 2 * self.selectBorderWidth;
    return CGSizeMake(width, height);
}

- (void)resize:(CGSize)size {
    self.widthConstraint.constant = size.width + 2 * self.borderWidth + 2 * self.selectBorderWidth;
    self.heightConstraint.constant = size.height + 2 * self.borderWidth + 2 * self.selectBorderWidth;
}

- (void)switchSelection {
    if (self.isSelected) {
        [self deselect];
    } else {
        [self select];
    }
}

- (CGRect)shapeContainer {
    if ([self superview]) {
        return CGRectMake(self.leftConstraint.constant + self.selectBorderWidth,
                          self.topConstraint.constant + self.selectBorderWidth,
                          self.widthConstraint.constant - self.selectBorderWidth,
                          self.heightConstraint.constant - self.selectBorderWidth);
    } else {
        // constraints not set yet
        return CGRectMake(self.frame.origin.x + self.selectBorderWidth,
                          self.frame.origin.y + self.selectBorderWidth,
                          self.frame.size.width - self.selectBorderWidth,
                          self.frame.size.height - self.selectBorderWidth);
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect shapeContainer = CGRectMake(self.bounds.origin.x + self.selectBorderWidth,
                                       self.bounds.origin.y + self.selectBorderWidth,
                                       self.widthConstraint.constant - self.selectBorderWidth,
                                       self.heightConstraint.constant - self.selectBorderWidth);
    return CGRectContainsPoint(shapeContainer, point);
}

- (BOOL)isIntersectedBySegment:(CGPoint)p1 :(CGPoint)p2 {
    CGRect container = [self shapeContainer];
    CGPoint topLeft = container.origin;
    CGPoint topRight = CGPointMake(container.origin.x + container.size.width, container.origin.y);
    CGPoint bottomLeft = CGPointMake(container.origin.x, container.origin.y + container.size.height);
    CGPoint bottomRight = CGPointMake(container.origin.x + container.size.width, container.origin.y + container.size.height);
    return ([self checkLineIntersection:p1 :p2 :topLeft :topRight] ||
            [self checkLineIntersection:p1 :p2 :topLeft :bottomLeft] ||
            [self checkLineIntersection:p1 :p2 :bottomLeft :bottomRight] ||
            [self checkLineIntersection:p1 :p2 :topRight :bottomRight]);
}

-(BOOL)checkLineIntersection:(CGPoint)p1 :(CGPoint)p2 :(CGPoint)p3 :(CGPoint)p4 {
    CGFloat denominator = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y);
    CGFloat ua = (p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x);
    CGFloat ub = (p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x);
    if (denominator < 0) {
        ua = -ua; ub = -ub; denominator = -denominator;
    }
    return (ua > 0.0 && ua <= denominator && ub > 0.0 && ub <= denominator);
}

+ (CGPoint)centroidOfShapes:(NSSet *)shapes {
    NSUInteger count = [shapes count];
    CGPoint centroid = CGPointMake(0, 0);
    for (ShapeView *shape in shapes) {
        CGPoint center = shape.centerPoint;
        centroid.x += center.x;
        centroid.y += center.y;
    }
    centroid.x /= count;
    centroid.y /= count;
    return centroid;
}

+ (void)placeShapes:(NSSet *)shapes toCentroid:(CGPoint)centroid {
    CGPoint currentCentroid = [self centroidOfShapes:shapes];
    for (ShapeView *shape in shapes) {
        CGPoint oldCenter = shape.centerPoint;
        CGPoint dist = {oldCenter.x - currentCentroid.x, oldCenter.y - currentCentroid.y};
        [shape moveCenterX:(dist.x + centroid.x) Y:(dist.y + centroid.y)];
    }
}

@end
