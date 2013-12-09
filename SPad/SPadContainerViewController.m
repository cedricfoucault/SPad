//
//  ViewController.m
//  SPad
//
//  Created by Cédric Foucault on 07/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "SPadContainerViewController.h"
#import "SPadView.h"
#import "FromLeftBezelSwipeGestureRecognizer.h"
#import "ToLeftBezelSwipeGestureRecognizer.h"



@interface SPadContainerViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) SPadView *spadView;

@end

@implementation SPadContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    self.spadView = [[SPadView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:self.spadView];
    [self.spadView initConstraints];
    
    FromLeftBezelSwipeGestureRecognizer *fromBezelSwipeGestureRecognizer = [[FromLeftBezelSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleFromBezelSwipe:)];
    [self.view addGestureRecognizer:fromBezelSwipeGestureRecognizer];
    ToLeftBezelSwipeGestureRecognizer *toBezelSwipeGestureRecognizer = [[ToLeftBezelSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleToBezelSwipe:)];
    toBezelSwipeGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:toBezelSwipeGestureRecognizer];
    
    // instantiate main view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self displayContentController:mainViewController];
}

- (void)displayContentController: (UIViewController*)content {
    [self addChildViewController:content];
    content.view.translatesAutoresizingMaskIntoConstraints = NO;
//    [content.view removeConstraints:content.view.constraints];
    UIView *contentView = content.view;
    [self.view insertSubview:content.view belowSubview:self.spadView];
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|"
                                                                                     options:0 metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(contentView)];
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|"
                                                                                     options:0 metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(contentView)];
    [self.view addConstraints:vConstraints];
    [self.view addConstraints:hConstraints];
    [content didMoveToParentViewController:self];
}

- (void)hideContentController: (UIViewController*)content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

- (BOOL)shouldAutomaticallyForwardRotationMethods {
    return YES;
}

- (void)handleFromBezelSwipe:(FromLeftBezelSwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        [self.spadView discloseWithTouchLocation:[gestureRecognizer locationInView:self.view]];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([self.spadView pointInside:[touch locationInView:self.spadView] withEvent:nil]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)handleToBezelSwipe:(FromLeftBezelSwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        [self.spadView close];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.spadView fitToInterfaceOrientation:toInterfaceOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
