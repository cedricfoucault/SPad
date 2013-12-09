//
//  ShapePasteboard.h
//  Spad
//
//  Created by Cédric Foucault on 21/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShapePasteboard : NSObject

+ (id)sharedPasteboard;

- (NSSet *)objects;
- (void)addObject:(id)object;
- (void)clear;

@end
