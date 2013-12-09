//
//  SelectionManager.m
//  Spad
//
//  Created by Cédric Foucault on 21/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "SelectionManager.h"
#import "ModeManager.h"
#import "ShapePasteboard.h"
#import "ShapeView.h"

@interface SelectionManager ()

@property (strong, nonatomic) NSMutableSet *objects;

@end

@implementation SelectionManager

+ (id)sharedManager {
    static SelectionManager *sharedManager = nil;
    if (!sharedManager) {
        sharedManager = [[self alloc] init];
    }
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        _objects = [[NSMutableSet alloc] init];
        ModeManager *modeManager = [ModeManager sharedManager];
        [modeManager addTarget:self action:@selector(modeChangedFromMode:toMode:)];
    }
    return self;
}

- (void)addObject:(id)object {
    [self.objects addObject:object];
}

- (void)removeObject:(id)object {
    [self.objects removeObject:object];
}

- (void)modeChangedFromMode:(ModeObject *)fromMode toMode:(ModeObject *)toMode {
    if (fromMode.mode == ModeCopy) {
        // copy selected object to pasteboard and deselect them
        ShapePasteboard *pasteboard = [ShapePasteboard sharedPasteboard];
        [pasteboard clear];
        NSSet *objects = [NSSet setWithSet:self.objects];
        for (ShapeView *shapeView in objects) {
            [pasteboard addObject:shapeView];
            [shapeView deselect];
        }
        // remove all objects
        [self.objects removeAllObjects];
    }
}

@end
