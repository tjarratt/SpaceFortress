//
//  GLGBody.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/1/13.
//
//
#import "constants.h"
#import "RangeProperty.h"
#import <Foundation/Foundation.h>

@interface GLGBody : NSObject

@property CGFloat age;
@property CGFloat mass;
@property CGFloat radius;
@property (retain) NSString *name;
@property (retain) NSColor *color;

- (CGFloat) gravityAtSurface;
- (CGFloat) escapeVelocity;

@end
