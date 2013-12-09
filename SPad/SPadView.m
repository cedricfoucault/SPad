//
//  SPadView.m
//  SPad
//
//  Created by Cédric Foucault on 07/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "SPadView.h"
#import "SPadSwipeView.h"
#import "ModeManager.h"
#import "ModeButtonSet.h"
#import "DiagonalSwipeRecognizer.h"
#import "UIDevice+Hardware.h"
#import "UIScreen+PhysicalSize.h"
#import <AudioToolbox/AudioToolbox.h>
//#import "ModeButton.h"
//#import "SPadContainerView.h"
//#import "SPadView.h"

#define DEGREES_TO_RADIANS(degrees) ((degrees) * (M_PI / 180.0))
#define RADIANS_TO_DEGREES(degrees) ((degrees) * (180.0 / M_PI))

static const NSUInteger RADIUS_OUTER_MM = 110;
static const NSUInteger RADIUS_INNER_MM = 90;
static const CGFloat THUMB_JOINT_MM_FROM_BEZEL = 21.11;
static const CGFloat BUTTON_SET_GAP_X = 150;
static const CGFloat BUTTON_SET_GAP_Y = 150;

static const NSTimeInterval ARROW_HIGHLIGHT_DURATION = 0.2;
static const NSTimeInterval ANIMATION_DURATION = 0.33;
static const NSUInteger NUMBER_OF_BUTTONS = 3;

//static const CGFloat DISCLOSE_GAP_X = 150;
static const NSTimeInterval DISCLOSE_ANIMATION_DURATION = 0.33;

@interface SPadView ()

@property (nonatomic, getter = isClosed) BOOL closed;

@property (strong, nonatomic) SPadSwipeView *swipeView;
@property (strong, nonatomic) ModeButtonSet *currentButtonSet;
@property (strong, nonatomic) ModeButtonSet *buttonSetNW;
@property (strong, nonatomic) ModeButtonSet *buttonSetNE;
@property (strong, nonatomic) ModeButtonSet *buttonSetSE;
@property (strong, nonatomic) ModeButtonSet *buttonSetSW;

@property (nonatomic) NSUInteger numberOfButtons;
@property (nonatomic) CGFloat radiusOuter;
@property (nonatomic) CGFloat radiusInner;
@property (nonatomic) CGFloat angleMax;
@property (nonatomic) CGFloat angleMin;
@property (nonatomic) CGPoint jointCenterAbs; // absolute pos of thumb joint

@property (nonatomic) SystemSoundID switchSoundEffect;

@end

@implementation SPadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _init];
    }
    return self;
}

- (void)_init {
    _numberOfButtons = 3;
    _closed = NO;
    NSURL *pathURL = [[NSBundle mainBundle] URLForResource: @"SwitchSoundEffect@330ms" withExtension: @"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &_switchSoundEffect);
    // Get sizes
    UIDevice *device = [UIDevice currentDevice];
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat radiusOuter = [screen ptFromMm:RADIUS_OUTER_MM];
    CGFloat radiusInner = [screen ptFromMm:RADIUS_INNER_MM];
    CGFloat jointCenterAbsX = - [screen ptFromMm:(THUMB_JOINT_MM_FROM_BEZEL + [device bezelWidthMmWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation])]; // absolute pos of thumb joint
    CGFloat jointCenterAbsY = self.frame.origin.y + BUTTON_SET_GAP_Y + radiusOuter; // absolute pos of thumb joint
    CGFloat angleMinDeg = 29.5;
    CGFloat angleMinRad = DEGREES_TO_RADIANS(angleMinDeg);
    CGFloat angleMaxRad = acos(- jointCenterAbsX / radiusInner);
    
    // init properties
    _radiusOuter = radiusOuter;
    _radiusInner = radiusInner;
    _angleMax = angleMaxRad;
    _angleMin = angleMinRad;
    _jointCenterAbs = CGPointMake(jointCenterAbsX, jointCenterAbsY);
    
    // init frame view
    self.backgroundColor = [UIColor clearColor];
    [self fitView];
    
    // init swipe view
    self.swipeView = [[SPadSwipeView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.swipeView];
    [self.swipeView initConstraints];
    [self fitSwipeView];
    
    // add gestures to swipe view
    DiagonalSwipeGestureRecognizer *upLeftRecognizer = [[DiagonalSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    DiagonalSwipeGestureRecognizer *upRightRecognizer = [[DiagonalSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    DiagonalSwipeGestureRecognizer *downRightRecognizer = [[DiagonalSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    DiagonalSwipeGestureRecognizer *downLeftRecognizer = [[DiagonalSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    upLeftRecognizer.direction = DiagonalSwipeGestureRecognizerDirectionUpLeft;
    upRightRecognizer.direction = DiagonalSwipeGestureRecognizerDirectionUpRight;
    downRightRecognizer.direction = DiagonalSwipeGestureRecognizerDirectionDownRight;
    downLeftRecognizer.direction = DiagonalSwipeGestureRecognizerDirectionDownLeft;
    [self.swipeView addGestureRecognizer:upLeftRecognizer];
    [self.swipeView addGestureRecognizer:upRightRecognizer];
    [self.swipeView addGestureRecognizer:downRightRecognizer];
    [self.swipeView addGestureRecognizer:downLeftRecognizer];
    
    // init button sets
    self.buttonSetNW = [self genButtonSetNW];
    self.buttonSetNE = [self genButtonSetNE];
    self.buttonSetSE = [self genButtonSetSE];
    self.buttonSetSW = [self genButtonSetSW];
    self.currentButtonSet = [self genButtonSetSW];
    self.currentButtonSet.hidden = NO;
    self.currentButtonSet.alpha = 1;
    [self.currentButtonSet moveOriginX:BUTTON_SET_GAP_X Y:BUTTON_SET_GAP_Y];
}

- (void)dealloc {
    AudioServicesDisposeSystemSoundID(self.switchSoundEffect);
}

- (ModeButtonSet *)genButtonSetWithOrigin:(CGPoint)origin titles:(NSArray *)titles
                                      color:(UIColor *)color highlightedColor:(UIColor *)highlightedColor {
    ModeButtonSet *buttonSetCopy = [[ModeButtonSet alloc] initWithNumberOfButtons:self.numberOfButtons];
    [self insertSubview:buttonSetCopy belowSubview:self.swipeView];
    [buttonSetCopy initConstraints];
    
    buttonSetCopy.hidden = YES;
    buttonSetCopy.alpha = 0;
    buttonSetCopy.color = color;
    buttonSetCopy.highlightedColor = highlightedColor;
    
    [self fitButtonSet:buttonSetCopy];
    for (NSUInteger i = 0; i < self.numberOfButtons; i++) {
        // set titles
        NSString *title = [titles objectAtIndex:i];
        [buttonSetCopy setTitle:title atIndex:i];
        // set modes
        Mode mode = [ModeManager modeWithTitle:title];
        [buttonSetCopy setMode:mode atIndex:i];
    }
    [buttonSetCopy moveOriginX:origin.x Y:origin.y];
    return buttonSetCopy;
}

- (ModeButtonSet *)genButtonSetSW {
    CGPoint origin = CGPointMake(0, 2 * BUTTON_SET_GAP_Y);
    NSArray *titles = @[@"Copy", @"Paste", @"Delete"];
    UIColor *color = [UIColor colorWithRed:90/255.0 green:200/255.0 blue:250/255.0 alpha:1.0];
    UIColor *highlightedColor = [UIColor colorWithRed:45/255.0 green:100/255.0 blue:125/255.0 alpha:1.0];
    return [self genButtonSetWithOrigin:origin titles:titles color:color highlightedColor:highlightedColor];
}

- (ModeButtonSet *)genButtonSetNE {
    CGPoint origin = CGPointMake(2 * BUTTON_SET_GAP_X, 0);
    NSArray *titles = @[@"Group", @"Move", @"Transform"];
    UIColor *color = [UIColor colorWithRed:1 green:45/255.0 blue:85/255.0 alpha:1.0];
    UIColor *highlightedColor = [UIColor colorWithRed:0.5 green:22.5/255.0 blue:42.2/255.0 alpha:1.0];
    return [self genButtonSetWithOrigin:origin titles:titles color:color highlightedColor:highlightedColor];
}

- (ModeButtonSet *)genButtonSetNW {
    CGPoint origin = CGPointMake(0, 0);
    NSArray *titles = @[@"Color", @"Stroke", @"Eyedropper"];
    UIColor *color = [UIColor colorWithRed:1 green:204/255.0 blue:0 alpha:1.0];
    UIColor *highlightedColor = [UIColor colorWithRed:0.5 green:102/255.0 blue:0 alpha:1.0];
    return [self genButtonSetWithOrigin:origin titles:titles color:color highlightedColor:highlightedColor];
}

- (ModeButtonSet *)genButtonSetSE {
    CGPoint origin = CGPointMake(2 * BUTTON_SET_GAP_X, 2 * BUTTON_SET_GAP_Y);
    NSArray *titles = @[@"Shape", @"Polygon", @"Line"];
    UIColor *color = [UIColor colorWithRed:88/255.0 green:86/255.0 blue:214/255.0 alpha:1.0];
    UIColor *highlightedColor = [UIColor colorWithRed:44/255.0 green:43/255.0 blue:107/255.0 alpha:1.0];
    return [self genButtonSetWithOrigin:origin titles:titles color:color highlightedColor:highlightedColor];
}


//- (Mode)modeWithTitle:(NSString *)title {
//    if ([title isEqualToString:@"Copy"]) {
//        return ModeCopy;
//    } else if ([title isEqualToString:@"Paste"]) {
//        return ModePaste;
//    } else if ([title isEqualToString:@"Delete"]) {
//        return ModeDelete;
//    } else if ([title isEqualToString:@"Group"]) {
//        return ModeGroup;
//    } else if ([title isEqualToString:@"Move"]) {
//        return ModeMove;
//    } else if ([title isEqualToString:@"Transform"]) {
//        return ModeTransform;
//    } else if ([title isEqualToString:@"Color"]) {
//        return ModeColor;
//    } else if ([title isEqualToString:@"Stroke"]) {
//        return ModeStroke;
//    } else if ([title isEqualToString:@"Eyedropper"]) {
//        return ModeEyedropper;
//    } else if ([title isEqualToString:@"Shape"]) {
//        return ModeShape;
//    } else if ([title isEqualToString:@"Polygon"]) {
//        return ModePolygon;
//    } else if ([title isEqualToString:@"Line"]) {
//        return ModeLine;
//    }
//    return ModeDefault;
//}

- (void)handleSwipe:(DiagonalSwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        __block ModeButtonSet *oldButtonSetMain = self.currentButtonSet;
        __block SPadView *blockSelf = self;
        
        // get direction information
        __block UIImageView *arrowToHighlight;
        switch ([gestureRecognizer direction]) {
            case DiagonalSwipeGestureRecognizerDirectionDownRight:
                self.currentButtonSet = self.buttonSetNW;
                self.buttonSetNW = [self genButtonSetNW];
                arrowToHighlight = self.swipeView.NWArrow;
                break;
            case DiagonalSwipeGestureRecognizerDirectionDownLeft:
                self.currentButtonSet = self.buttonSetNE;
                self.buttonSetNE = [self genButtonSetNE];
                arrowToHighlight = self.swipeView.NEArrow;
                break;
            case DiagonalSwipeGestureRecognizerDirectionUpRight:
                self.currentButtonSet = self.buttonSetSW;
                self.buttonSetSW = [self genButtonSetSW];
                arrowToHighlight = self.swipeView.SWArrow;
                break;
            case DiagonalSwipeGestureRecognizerDirectionUpLeft:
                self.currentButtonSet = self.buttonSetSE;
                self.buttonSetSE = [self genButtonSetSE];
                arrowToHighlight = self.swipeView.SEArrow;
                break;
        }
        
        // Button set move animation
        self.currentButtonSet.hidden = NO;
        [self.currentButtonSet moveOriginX:BUTTON_SET_GAP_X Y:BUTTON_SET_GAP_Y];
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            oldButtonSetMain.alpha = 0;
            blockSelf.currentButtonSet.alpha = 1;
            [blockSelf layoutIfNeeded];
        } completion:^(BOOL finished) {
            [oldButtonSetMain removeFromSuperview];
            oldButtonSetMain = nil;
            arrowToHighlight.highlighted = NO;
        }];
        
        // Arrow highlight blink
        arrowToHighlight.highlighted = YES;
        [NSTimer scheduledTimerWithTimeInterval:ARROW_HIGHLIGHT_DURATION target:self selector:@selector(dehighlightArrowWithTimer:) userInfo:arrowToHighlight repeats:NO];
        
        // Play sound effect
        AudioServicesPlaySystemSound(self.switchSoundEffect);
    }
}

- (void)dehighlightArrowWithTimer:(NSTimer *)timer {
    UIImageView *arrowToHighlight = timer.userInfo;
    arrowToHighlight.highlighted = NO;
}

- (void)fitToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // Get sizes
    UIDevice *device = [UIDevice currentDevice];
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat jointCenterAbsX = - [screen ptFromMm:(THUMB_JOINT_MM_FROM_BEZEL + [device bezelWidthMmWithInterfaceOrientation:toInterfaceOrientation])]; // absolute pos of thumb joint
    CGFloat jointCenterAbsY = self.topConstraint.constant + BUTTON_SET_GAP_Y + self.radiusOuter; // absolute pos of thumb joint
    CGFloat angleMaxRad = acos(- jointCenterAbsX / self.radiusInner);
    self.angleMax = angleMaxRad;
    self.jointCenterAbs = CGPointMake(jointCenterAbsX, jointCenterAbsY);
    
    // Fit self view
    [self fitViews];
    if (self.isClosed) {
        [self closeGapX];
    }
}

- (void)fitViews {
    // Fit self view
    [self fitView];
    // fit subviews
    [self fitSubviews];
}

- (void)fitView {
    CGFloat frame_x = self.jointCenterAbs.x - BUTTON_SET_GAP_X;
    CGFloat width = self.radiusOuter + 2 * BUTTON_SET_GAP_X;
    CGFloat height = self.radiusOuter + 2 * BUTTON_SET_GAP_Y;
    if (self.superview) {
        self.leftConstraint.constant = frame_x;
        self.widthConstraint.constant = width;
        self.heightConstraint.constant = height;
    } else {
        // constraints are not set yet; use frame instead
        self.frame = CGRectMake(frame_x, self.frame.origin.y, width, height);
    }
}

- (void)fitSubviews {
    // Fit button sets
    [self fitButtonSets];
    // Fit swipe view
    [self fitSwipeView];
}

- (void)fitButtonSets {
    [self fitButtonSet:self.currentButtonSet];
    [self fitButtonSet:self.buttonSetNE];
    [self fitButtonSet:self.buttonSetNW];
    [self fitButtonSet:self.buttonSetSW];
    [self fitButtonSet:self.buttonSetSE];
}

- (void)fitButtonSet:(ModeButtonSet *)buttonSet {
    [buttonSet setRadiusOuter:self.radiusOuter radiusInner:self.radiusInner];
    [buttonSet setAngleMax:self.angleMax angleMin:self.angleMin];
}

- (void)fitSwipeView {
    CGPoint jointCenterRel;// relative position of thumb joint
    if (self.superview) {
        jointCenterRel = CGPointMake(self.jointCenterAbs.x - self.leftConstraint.constant,
                    self.jointCenterAbs.y - self.topConstraint.constant);
    } else {
        // constraints are not set yet; use frame instead
        jointCenterRel = CGPointMake(self.jointCenterAbs.x - self.frame.origin.x,
                    self.jointCenterAbs.y - self.frame.origin.y);
    }
    self.swipeView.jointCenter = jointCenterRel;
    self.swipeView.xFromJoint = - self.jointCenterAbs.x;
    self.swipeView.angleMin = self.angleMin;
    self.swipeView.angleMax = self.angleMax;
    self.swipeView.radiusInner = self.radiusInner;
    self.swipeView.radiusOuter = self.radiusOuter;
}

- (void)close {
    if (!self.isClosed) {
        self.closed = YES;
        [self closeGapXAnimated];
    }
}

- (void)discloseWithTouchLocation:(CGPoint)location {
    [self moveYToLocation:location];
    if (self.isClosed) {
        self.closed = NO;
//        self.hidden = NO;
        [self performSelector:@selector(discloseGapXAnimated) withObject:nil afterDelay:1e-3];
    } else {
        self.leftConstraint.constant -= self.radiusOuter;
        [self discloseGapXAnimated];
//        [self performSelector:@selector(discloseGapXAnimated) withObject:nil afterDelay:1e-3];
    }
}

- (void)discloseGapXAnimated {
    self.leftConstraint.constant += self.radiusOuter;
    [UIView animateWithDuration:DISCLOSE_ANIMATION_DURATION animations:^{
        [self.superview layoutIfNeeded];
    }];
}

- (void)closeGapXAnimated {
    self.leftConstraint.constant -= self.radiusOuter;
    [UIView animateWithDuration:DISCLOSE_ANIMATION_DURATION animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
//        self.hidden = YES;
    }];
}

- (void)closeGapX {
    self.leftConstraint.constant -= self.radiusOuter;
}


- (void)moveYToLocation:(CGPoint)location {
    CGFloat radiusTouch = (self.radiusOuter + self.radiusInner) / 2.;
    CGFloat angleTouch = self.angleMax - (self.angleMax - self.angleMin) / 6;
    
    if ([self superview]) {
        CGFloat yTouch = location.y - self.heightConstraint.constant + radiusTouch * sin(angleTouch) + BUTTON_SET_GAP_Y;
        self.topConstraint.constant = yTouch;
    } else {
        CGFloat yTouch = location.y - self.view.frame.size.height + radiusTouch * sin(angleTouch) + BUTTON_SET_GAP_Y;
        self.view.frame = CGRectMake(self.view.frame.origin.x, yTouch, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return ([self.swipeView pointInside:[self convertPoint:point toView:self.swipeView] withEvent:event] ||
            [self.currentButtonSet pointInside:[self convertPoint:point toView:self.currentButtonSet] withEvent:event]);
}

@end
