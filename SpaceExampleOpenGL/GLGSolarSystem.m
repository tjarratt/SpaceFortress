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

        int capacity = 200;
        CGFloat maximum = 3000;
        starField = [[NSMutableArray alloc] initWithCapacity:capacity];
        for (int i = 0; i < capacity; ++i) {
            CGFloat x = (CGFloat) arc4random() / 0x100000000 * maximum;
            CGFloat y = (CGFloat) arc4random() / 0x100000000 * maximum;
            NSPoint point = NSMakePoint(x, y);
            [starField insertObject:[NSValue valueWithPoint:point] atIndex:i];
        }

        NSString *systemName = [GLGNameProperty randomName];
        [star setName:systemName];
        [self setName:systemName];
        
        for (i = 0; i < num_planetoids; ++i) {
            GLGPlanetoid *planet = [[GLGPlanetoid alloc] init];
            [planet setStar:star];
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
            
            NSString *numeral = [GLGNameProperty numeralForDigit:i];
            NSString *planetName = [NSString stringWithFormat:@"%@ %@", systemName, numeral];
            [planet setName:planetName];
            
            [planetoids addObject:planet];
            [planet release];
        }
    }
    
    return self;
}

- (id) initAsSol {
    if (self = [self init]) {
        [star initAsSol];
        [self setName:@"Home System"];

        [planetoids release];
        planetoids = [[NSMutableArray alloc] initWithCapacity:8];

        GLGPlanetoid *mercury = [[GLGPlanetoid alloc] initAsMercury];
        [planetoids addObject:mercury];
        [mercury release];

        GLGPlanetoid *venus = [[GLGPlanetoid alloc] initAsVenus];
        [planetoids addObject:venus];
        [venus release];

        GLGPlanetoid *mars = [[GLGPlanetoid alloc] initAsMars];
        [planetoids addObject:mars];
        [mars release];

        GLGPlanetoid *earth = [[GLGPlanetoid alloc] initAsEarth];
        [planetoids addObject:earth];
        [earth release];

        GLGPlanetoid *uranus = [[GLGPlanetoid alloc] initAsUranus];
        [planetoids addObject:uranus];
        [uranus release];

        GLGPlanetoid *saturn = [[GLGPlanetoid alloc] initAsSaturn];
        [planetoids addObject:saturn];
        [saturn release];

        GLGPlanetoid *neptune = [[GLGPlanetoid alloc] initAsNeptune];
        [planetoids addObject:neptune];
        [neptune release];

        GLGPlanetoid *jupiter = [[GLGPlanetoid alloc] initAsJupiter];
        [planetoids addObject:jupiter];
        [jupiter release];
        
        // TODO: asteroid belt
    }

    return self;
}

- (void) dealloc {
    [planetoids release];
    [star release];
    return [super dealloc];
}

- (NSMutableArray *) starField {
    return starField;
}

@end
