//
//  GuidelineManager.m
//  SPad
//
//  Created by Cédric Foucault on 09/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "GuidelineManager.h"


@implementation GuidelineManager

+ (id)sharedManager {
    static GuidelineManager *sharedManager = nil;
    if (!sharedManager) {
        sharedManager = [[self alloc] init];
    }
    return sharedManager;
}

@end
