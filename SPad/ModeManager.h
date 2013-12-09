//
//  ModeManager.h
//  Test
//
//  Created by Cédric Foucault on 21/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSUInteger N_MODES = 13;

typedef NS_ENUM(NSUInteger, Mode) {
    ModeDefault,
    ModeCopy,
    ModePaste,
    ModeDelete,
    ModeGroup,
    ModeMove,
    ModeTransform,
    ModeColor,
    ModeStroke,
    ModeEyedropper,
    ModeShape,
    ModePolygon,
    ModeLine
};

@interface ModeObject : NSObject

@property (nonatomic) Mode mode;

@end

@interface ModeManager : NSObject

+ (id)sharedManager;
+ (Mode)modeWithTitle:(NSString *)title;

- (Mode)currentMode;
- (void)setMode:(Mode)mode active:(BOOL)active;
- (void)addTarget:(id)target action:(SEL)action;

@end
