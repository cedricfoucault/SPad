//
//  SelectionAreaView.h
//  SPad
//
//  Created by Cédric Foucault on 13/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionAreaView : UIView

- (void)startSelectionAreaWithPoints:(CGPoint)a :(CGPoint)b;
- (void)updateSelectionAreaWithPoints:(CGPoint)a :(CGPoint)b;

@end
