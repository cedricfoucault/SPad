//
//  GuidelineManager.h
//  SPad
//
//  Created by Cédric Foucault on 09/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HorizontalGuideline.h"
#import "VerticalGuideline.h"

@interface GuidelineManager : NSObject

@property (weak, nonatomic) HorizontalGuideline *horizontalGuideline;
@property (weak, nonatomic) VerticalGuideline *verticalGuideline;

+ (id)sharedManager;

@end
