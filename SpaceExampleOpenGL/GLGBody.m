//
//  GLGBody.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/1/13.
//
//

#import "GLGBody.h"

@implementation GLGBody

@synthesize age, mass, name, radius, color;

- (CGFloat) escapeVelocity {
    return sqrtf(2.0f * mass * universalGravitationConstant / radius);
}

- (CGFloat) gravityAtSurface {
    return universalGravitationConstant * self.mass / powf(self.radius, 2);
}

@end
