//
//  SelectionLineView.h
//  SPad
//
//  Created by Cédric Foucault on 24/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionLineView : UIView

//- (id)initWithPoint:(CGPoint)point;
- (void)startSelectionLineWithPoint:(CGPoint)point;
- (void)updateSelectionLineWithPoint:(CGPoint)point;

@end
