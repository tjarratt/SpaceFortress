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

- (id) init {
    if (self = [super init]) {
        CGFloat earth_mass = 7.349e22; // kg
        CGFloat min_mass = earth_mass / 10000;
        mass = [RangeProperty randomValueWithMinimum:min_mass maximum:maximumMassBeforeNuclearFusion];
        
        CGFloat min_radius = 1.5e6;
        CGFloat max_radius = 75e6;
        radius = [RangeProperty randomValueWithMinimum:min_radius maximum:max_radius];

    }
    
    return self;
}

- (CGFloat) escapeVelocity {
    return sqrtf(2.0f * mass * universalGravitationConstant / radius);
}

- (CGFloat) gravityAtSurface {
    return universalGravitationConstant * self.mass / powf(self.radius, 2);
}

@end
