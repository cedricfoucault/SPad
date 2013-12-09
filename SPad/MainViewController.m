//
//  MainViewController.m
//  SPad
//
//  Created by Cédric Foucault on 08/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "MainViewController.h"
#import "CanvasView.h"
#import "ShapeView.h"
#import "ModeManager.h"
#import "ShapePasteboard.h"
#import "SelectionLineView.h"
#import "ZoomManager.h"
#import "GuidelineManager.h"

@interface MainViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet CanvasView *canvas;
@property (strong, nonatomic) SelectionLineView *selectionLineView;

@property (strong, nonatomic) NSArray *canvasGestureRecognizers;
@property (strong, nonatomic) NSArray *scrollviewGestureRecognizers;

@property (strong, nonatomic) NSMutableSet *shapesToPaste;
@property (strong, nonatomic) NSMutableArray *shapesIntersected; // shapes intersected by current selection line
@property (nonatomic) CGPoint lastSelectionLinePoint;

@end

@implementation MainViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init {
    _shapesToPaste = [[NSMutableSet alloc] init];
    _shapesIntersected = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // scrollView parameters
    self.mainView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.canvas.translatesAutoresizingMaskIntoConstraints = NO;
    self.canvas.clipsToBounds = NO;
    self.scrollView.contentSize = self.canvas.frame.size;
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=3.0;
    self.scrollView.delegate = self;
    
    // Set scroll view for zoom manager
    ZoomManager *zoomManager = [ZoomManager sharedManager];
    [zoomManager setScrollView:self.scrollView];
    
    // init guidelines
    VerticalGuideline *verticalGuideline = [[VerticalGuideline alloc]
                                            initWithFrame:CGRectMake(self.canvas.frame.size.width / 2 - 5, 0, 10, self.canvas.frame.size.height)];
    [self.canvas addSubview:verticalGuideline];
    [verticalGuideline initConstraints];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[verticalGuideline]|" options:0 metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(verticalGuideline)];
    [self.canvas addConstraints:verticalConstraints];
    HorizontalGuideline *horizontalGuideline = [[HorizontalGuideline alloc]
                                            initWithFrame:CGRectMake(0, self.canvas.frame.size.height / 2 - 5, self.canvas.frame.size.width, 10)];
    [self.canvas addSubview:horizontalGuideline];
    [horizontalGuideline initConstraints];
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[horizontalGuideline]|" options:0 metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(horizontalGuideline)];
    [self.canvas addConstraints:horizontalConstraints];
    // set guidelines for guideline manager
    GuidelineManager *guidelineManager = [GuidelineManager sharedManager];
    guidelineManager.verticalGuideline = verticalGuideline;
    guidelineManager.horizontalGuideline = horizontalGuideline;
    
    // init shapes in canvas
    ShapeView *rectangle1 = [[ShapeView alloc] initWithFrame:CGRectMake((self.canvas.bounds.size.width - 120) / 2, 200, 120., 120.)];
    ShapeView *rectangle2 = [[ShapeView alloc] initWithFrame:CGRectMake((self.canvas.bounds.size.width - 120) / 2, 500, 120., 120.)];
    rectangle2.fillColor = [UIColor redColor];
    rectangle1.fillColor = [UIColor blueColor];
    [self.canvas insertSubview:rectangle1 belowSubview:verticalGuideline];
    [self.canvas insertSubview:rectangle2 belowSubview:verticalGuideline];
    [rectangle1 initConstraints];
    [rectangle2 initConstraints];
    
    // init scroll view gesture recognizers
    NSMutableArray *scrollViewGestureRecognizers = [[NSMutableArray alloc] initWithCapacity:N_MODES];
    for (NSUInteger i = 0; i < N_MODES; i++) {
        [scrollViewGestureRecognizers addObject:[[NSMutableArray alloc] init]];
    }
    NSMutableArray *scrollViewRecognizersForDefaultMode = [scrollViewGestureRecognizers objectAtIndex:ModeDefault];
    [scrollViewRecognizersForDefaultMode addObjectsFromArray:self.scrollView.gestureRecognizers];
    _scrollviewGestureRecognizers = (NSArray *)scrollViewGestureRecognizers;
    
    // init canvas gesture recognizers
    // paste gesture recognizer
    UILongPressGestureRecognizer *pasteGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePasteGesture:)];
    pasteGestureRecognizer.minimumPressDuration = 0;
    pasteGestureRecognizer.enabled = NO;
    [self.canvas addGestureRecognizer:pasteGestureRecognizer];
    // selection line gesture recognizer
    UIPanGestureRecognizer *selectionLineGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectionLineGesture:)];
    selectionLineGestureRecognizer.enabled = NO;
    [self.canvas addGestureRecognizer:selectionLineGestureRecognizer];
    NSMutableArray *canvasGestureRecognizers = [[NSMutableArray alloc] initWithCapacity:N_MODES];
    for (NSUInteger i = 0; i < N_MODES; i++) {
        [canvasGestureRecognizers addObject:[[NSMutableArray alloc] init]];
    }
    NSMutableArray *gestureRecognizersForCopyMode = [canvasGestureRecognizers objectAtIndex:ModeCopy];
    [gestureRecognizersForCopyMode addObject:selectionLineGestureRecognizer];
    NSMutableArray *gestureRecognizersForPasteMode = [canvasGestureRecognizers objectAtIndex:ModePaste];
    [gestureRecognizersForPasteMode addObject:pasteGestureRecognizer];
    _canvasGestureRecognizers = (NSArray *) canvasGestureRecognizers;
    
    ModeManager *manager = [ModeManager sharedManager];
    [manager addTarget:self action:@selector(modeChangedFromMode:toMode:)];
}

- (void)modeChangedFromMode:(ModeObject *)fromMode toMode:(ModeObject *)toMode {
    NSArray *oldScrollViewGestureRecognizers = [self.scrollviewGestureRecognizers objectAtIndex:fromMode.mode];
    NSArray *newScrollViewGestureRecognizers = [self.scrollviewGestureRecognizers objectAtIndex:toMode.mode];
    NSArray *oldCanvasGestureRecognizers = [self.canvasGestureRecognizers objectAtIndex:fromMode.mode];
    NSArray *newCanvasGestureRecognizers = [self.canvasGestureRecognizers objectAtIndex:toMode.mode];
    // disable gesture recognizers of previous mode
    for (UIGestureRecognizer *oldGestureRecognizer in oldCanvasGestureRecognizers) {
        oldGestureRecognizer.enabled = NO;
    }
    for (UIGestureRecognizer *oldGestureRecognizer in oldScrollViewGestureRecognizers) {
        oldGestureRecognizer.enabled = NO;
    }
    // enable gesture recognizers of new mode
    for (UIGestureRecognizer *newGestureRecognizer in newCanvasGestureRecognizers) {
        newGestureRecognizer.enabled = YES;
    }
    for (UIGestureRecognizer *newGestureRecognizer in newScrollViewGestureRecognizers) {
        newGestureRecognizer.enabled = YES;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.canvas;
}

- (void)handlePasteGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            GuidelineManager *guidelineManager = [GuidelineManager sharedManager];
            // begin to paste
            ShapePasteboard *pasteboard = [ShapePasteboard sharedPasteboard];
            for (ShapeView *shape in [pasteboard objects]) {
                ShapeView *shapeCopy = [shape copyShape];
                shapeCopy.alpha = 0.5;
                [self.shapesToPaste addObject:shapeCopy];
                [self.canvas insertSubview:shapeCopy belowSubview:guidelineManager.verticalGuideline];
                [shapeCopy initConstraints];
            }
            [ShapeView placeShapes:self.shapesToPaste toCentroid:[gestureRecognizer locationInView:gestureRecognizer.view]];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            // move shapes
            [ShapeView placeShapes:self.shapesToPaste toCentroid:[gestureRecognizer locationInView:gestureRecognizer.view]];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            // commit paste
            for (ShapeView *shape in self.shapesToPaste) {
                shape.alpha = 1;
            }
            [self.shapesToPaste removeAllObjects];
            break;
        }
        default:
            break;
    }
}

- (void)handleSelectionLineGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.lastSelectionLinePoint = [gestureRecognizer locationInView:gestureRecognizer.view];
            self.selectionLineView = [[SelectionLineView alloc] initWithFrame:CGRectZero];
            [self.selectionLineView startSelectionLineWithPoint:self.lastSelectionLinePoint];
            [self.canvas addSubview:self.selectionLineView];
            [self.selectionLineView initConstraints];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint newLinePoint = [gestureRecognizer locationInView:gestureRecognizer.view];
            [self.selectionLineView updateSelectionLineWithPoint:newLinePoint];
            [self checkIntersectionsWithSegment:self.lastSelectionLinePoint :newLinePoint];
            self.lastSelectionLinePoint = newLinePoint;
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            [self.shapesIntersected removeAllObjects];
            [self.selectionLineView removeFromSuperview];
            self.selectionLineView = nil;
            break;
        }
        default:
            break;
    }
}

- (void)checkIntersectionsWithSegment:(CGPoint)p1 :(CGPoint)p2 {
    for (ShapeView *shape in self.canvas.shapeSubviews) {
        // do not check the same shape more than once
        if (![self.shapesIntersected containsObject:shape]) {
            if ([shape isIntersectedBySegment:p1 :p2]) {
                [shape switchSelection];
                [self.shapesIntersected addObject:shape];
            }
        }
    }
}

@end
