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
        
        NSString *systemName = [NameProperty randomName];
        [star setName:systemName];
        [self setName:systemName];
        
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
            
            NSString *numeral = [NameProperty numeralForDigit:i];
            NSString *planetName = [NSString stringWithFormat:@"%@ %@", systemName, numeral];
            [planet setName:planetName];
            
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
