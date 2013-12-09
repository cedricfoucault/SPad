//
//  UITouchDownGestureRecognizer.m
//  SPad
//
//  Created by Cédric Foucault on 24/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "TouchDownGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation TouchDownGestureRecognizer
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateFailed;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateFailed;
}


@end
