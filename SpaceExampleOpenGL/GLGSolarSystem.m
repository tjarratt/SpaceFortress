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

#pragma mark - lifecycle
- (id) init {
    if (self = [super init]) {
        int i;
        int num_planetoids = arc4random() % 4 + 1;
        planetoids = [[NSMutableArray alloc] initWithCapacity:num_planetoids];
        
        star = [[GLGSolarStar alloc] init];
        for (i = 0; i < num_planetoids; ++i) {
            GLGPlanetoid *planet = [[GLGPlanetoid alloc] initWithStar: star];
            switch (i) {
                case 0:
                    [planet setColor:[NSColor colorWithDeviceRed:0.9 green:0.35 blue:0.35 alpha:1.0]];
                    break;
                case 1:
                    [planet setColor: [NSColor colorWithDeviceRed:0.35 green:0.9 blue:0.35 alpha:1.0]];
                    break;
                case 2:
                    [planet setColor: [NSColor colorWithDeviceRed:0.35 green:0.35 blue:0.9 alpha:1.0]];
                    break;
                case 3:
                    [planet setColor:[NSColor colorWithDeviceRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
                    break;
                    
            }
            
            [planetoids addObject:planet];
            [planet release];
        }
    }
    
    [self describeSelf];
    
    return self;
}

- (void) dealloc {
    [planetoids release];
    [star release];
    return [super dealloc];
}

#pragma mark - UI description
- (void) describeSelf {
    NSLog(@"%@", [NSString stringWithFormat: @"a description of a solar system with %lu planets", [planetoids count]]);
    [star describe];
    [planetoids enumerateObjectsUsingBlock:^(GLGPlanetoid *p, NSUInteger index, BOOL *stop) {
        [p describe];
    }];
}

@end
