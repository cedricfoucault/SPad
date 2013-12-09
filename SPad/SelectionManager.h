//
//  SelectionManager.h
//  Spad
//
//  Created by Cédric Foucault on 21/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectionManager : NSObject

+ (id)sharedManager;

- (void)addObject:(id)object;
- (void)removeObject:(id)object;

@end
