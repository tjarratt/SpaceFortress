//
//  GLGBody.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/1/13.
//
//

#import "GLGBody.h"

@implementation GLGBody

@synthesize age, mass, name, radius, color, escapeVelocity;

- (id) init {
    if (self = [super init]) {
        name = [NameProperty randomName];
        CGFloat earth_mass = 7.349e22; // kg
        CGFloat min_mass = earth_mass / 10000;
        mass = [RangeProperty randomValueWithMinimum:min_mass maximum:maximum_mass_before_nuclear_fusion];
        
        CGFloat min_radius = 1.5e6;
        CGFloat max_radius = 75e6;
        radius = [RangeProperty randomValueWithMinimum:min_radius maximum:max_radius];
        
        escapeVelocity = sqrtf(2 * mass * universalGravitationConstant / radius);

    }
    
    return self;
}

@end
