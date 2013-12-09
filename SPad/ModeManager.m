//
//  ModeManager.m
//  Test
//
//  Created by Cédric Foucault on 21/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ModeManager.h"

@implementation ModeObject
@end

@interface TargetAction : NSObject

@property (weak, nonatomic) id target;
@property (nonatomic) SEL action;

@end

@implementation TargetAction
@end

@interface ModeStamp : NSObject

@property (nonatomic, getter = isActive) BOOL active;
@property (strong, nonatomic) NSDate *lastActivated;

@end

@implementation ModeStamp

-(id)init {
    self = [super init];
    if (self) {
        _active = NO;
    }
    return self;
}

- (void)setActive:(BOOL)active {
    _active = active;
    if (active) {
        self.lastActivated = [NSDate date];
    }
}

@end

@interface ModeManager ()

@property (strong, nonatomic) NSArray *modeStamps;
@property (nonatomic) Mode currentMode;
@property (strong, nonatomic) NSMutableSet *targetActions;

@end

@implementation ModeManager

+ (id)sharedManager {
    static ModeManager *sharedManager = nil;
    if (!sharedManager) {
        sharedManager = [[self alloc] init];
    }
    return sharedManager;
}

+ (Mode)modeWithTitle:(NSString *)title {
    if ([title isEqualToString:@"Copy"]) {
        return ModeCopy;
    } else if ([title isEqualToString:@"Paste"]) {
        return ModePaste;
    } else if ([title isEqualToString:@"Delete"]) {
        return ModeDelete;
    } else if ([title isEqualToString:@"Group"]) {
        return ModeGroup;
    } else if ([title isEqualToString:@"Move"]) {
        return ModeMove;
    } else if ([title isEqualToString:@"Transform"]) {
        return ModeTransform;
    } else if ([title isEqualToString:@"Color"]) {
        return ModeColor;
    } else if ([title isEqualToString:@"Stroke"]) {
        return ModeStroke;
    } else if ([title isEqualToString:@"Eyedropper"]) {
        return ModeEyedropper;
    } else if ([title isEqualToString:@"Shape"]) {
        return ModeShape;
    } else if ([title isEqualToString:@"Polygon"]) {
        return ModePolygon;
    } else if ([title isEqualToString:@"Line"]) {
        return ModeLine;
    }
    return ModeDefault;
}

- (id)init {
    self = [super init];
    if (self) {
        _currentMode = ModeDefault;
        _modeStamps = [[NSArray alloc] initWithObjects:
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init],
                          [[ModeStamp alloc] init], nil];
        _targetActions = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action {
    TargetAction *targetAction = [[TargetAction alloc] init];
    targetAction.target = target;
    targetAction.action = action;
    [self.targetActions addObject:targetAction];
}

- (void)setMode:(Mode)mode active:(BOOL)active {
    ModeStamp *stamp = [self.modeStamps objectAtIndex:mode];
    stamp.active = active;
    if (active) {
        self.currentMode = mode;
    } else {
        // reverse current mode to last mode that's still active or default mode if there is none
        ModeStamp *activeStamp = nil;
        Mode activeMode = ModeDefault;
        for (Mode mode = ModeDefault; mode < [self.modeStamps count]; mode++) {
            ModeStamp *stamp = [self.modeStamps objectAtIndex:mode];
            if (stamp.isActive) {
                if (!activeStamp) {
                    // set active stamp for the first time
                    activeStamp = stamp;
                    activeMode = mode;
                } else if ([stamp.lastActivated compare:activeStamp.lastActivated] == NSOrderedDescending) {
                    activeStamp = stamp;
                    activeMode = mode;
                }
            }
        }
        self.currentMode = activeMode;
    }
}

- (void)setCurrentMode:(Mode)currentMode {
    if (currentMode != _currentMode) {
        for (TargetAction *targetAction in self.targetActions) {
            ModeObject *fromMode = [[ModeObject alloc] init];
            fromMode.mode = _currentMode;
            ModeObject *toMode = [[ModeObject alloc] init];
            toMode.mode = currentMode;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [targetAction.target performSelector:targetAction.action withObject:fromMode withObject:toMode];
#pragma clang diagnostic pop
        }
        _currentMode = currentMode;
    }
}

@end
