//
//  GLGSolarSystem.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "GLGSolarSystem.h"

@implementation GLGSolarSystem

@synthesize planetoids, star;

- (id) init {
    if (self = [super init]) {
        int i;
        int num_planetoids = arc4random() % 7;
        
        star = [[GLGSolarStar alloc] init];
        for (i = 0; i < num_planetoids; ++i) {
            GLGPlanetoid *planet = [[GLGPlanetoid alloc] initWithAge:[star age]];
            [planetoids addObject:planet];
            [planet release];
        }
    }
    
    return self;
}

- (void) dealloc {
    [planetoids release];
    [star release];
    return [super dealloc];
}

@end
