//
//  ShapePasteboard.m
//  Spad
//
//  Created by Cédric Foucault on 21/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ShapePasteboard.h"

@interface ShapePasteboard ()

@property (strong, nonatomic) NSMutableSet *_objects;

@end

@implementation ShapePasteboard

+ (id)sharedPasteboard {
    static ShapePasteboard *sharedPasteboard = nil;
    if (!sharedPasteboard) {
        sharedPasteboard = [[self alloc] init];
    }
    return sharedPasteboard;
}

- (id)init {
    self = [super init];
    if (self) {
        __objects = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addObject:(id)object {
    [self._objects addObject:object];
}

- (void)clear {
    [self._objects removeAllObjects];
}

- (NSSet *)objects {
    return (NSSet *)self._objects;
}

@end
