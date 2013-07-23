//
//  GLGSidebarGalaxyView.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/3/13.
//
//

#import "GLGSidebarGalaxyView.h"

@implementation GLGSidebarGalaxyView

@synthesize selected, open;
@synthesize galaxy;

const CGFloat heightOfLabels = 25.0f;

- (id)initWithFrame:(NSRect)frame delegate:(id) _delegate andSystem:(GLGSolarSystem *) system {
    if (self = [super initWithFrame:frame]) {        
        galaxy = system;
        delegate = _delegate;

        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.frame = self.frame;
        [[self layer] setCornerRadius:5.0];
        [[self layer] setBorderWidth:1.0];

        CGColorRef defaultColor = [[NSColor blackColor] CGColor];
        [[self layer] setBorderColor:defaultColor];

        CGFloat height = frame.size.height;
        CGFloat widthOfLabels = frame.size.width - 10;
        CGFloat numberOfLabels = 11;
        CGFloat padding = (height - (heightOfLabels * numberOfLabels)) / (numberOfLabels + 1);
        assert( padding > 0 );

        __block CGFloat currentHeight = padding;
        __block NSRect labelRect = NSMakeRect(5, currentHeight, widthOfLabels, heightOfLabels);

        void (^updateBlock)(void) = ^(void) {
            currentHeight += heightOfLabels + padding;
            labelRect = NSMakeRect(5, currentHeight, widthOfLabels, heightOfLabels);
        };

        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:2];
        [formatter setRoundingMode:NSNumberFormatterRoundDown];
        [formatter setNumberStyle:NSNumberFormatterScientificStyle];

        galaxyName = [[GLGLabel alloc] initWithFrame:labelRect];
        [galaxyName setStringValue:[galaxy name]];
        [self addSubview:galaxyName];
        updateBlock();

        NSString *starType = [NSString stringWithFormat:@"Class %@ star", [[galaxy star] spectralClassification]];
        starTypeField = [[GLGLabel alloc] initWithFrame:labelRect];
        [starTypeField setStringValue:starType];
        [self addSubview:starTypeField];
        updateBlock();

        NSString *metallicityValue = [@"Metallicity: " stringByAppendingString:[formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.metallicity]]];
        metallicity = [[GLGLabel alloc] initWithFrame:labelRect];
        [metallicity setStringValue:metallicityValue];
        [self addSubview:metallicity];
        updateBlock();

        NSString *magnitudeValue = [@"Apparent Magnitude: " stringByAppendingString:[formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.apparentMagnitude]]];
        apparentMagnitude = [[GLGLabel alloc] initWithFrame:labelRect];
        [apparentMagnitude setStringValue:magnitudeValue];
        [self addSubview:apparentMagnitude];
        updateBlock();
        
        NSString *luminosityValue = [NSString stringWithFormat:@"Luminosity: %@ lumens", [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.luminosity]]];
        luminosity = [[GLGLabel alloc] initWithFrame:labelRect];
        [luminosity setStringValue:luminosityValue];
        [self addSubview:luminosity];
        updateBlock();

        NSString *temperatureValue = [NSString stringWithFormat:@"Surface Temp: %@K", [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.surfaceTemperature]]];
        surfaceTemperature = [[GLGLabel alloc] initWithFrame:labelRect];
        [surfaceTemperature setStringValue:temperatureValue];
        [self addSubview:surfaceTemperature];
        updateBlock();

        NSString *rotationValue = [NSString stringWithFormat:@"Rotation period: %@ secs", [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.rotationRate]]];
        rotationRate = [[GLGLabel alloc] initWithFrame:labelRect];
        [rotationRate setStringValue:rotationValue];
        [self addSubview:rotationRate];
        updateBlock();

        NSString *radiusValue = [NSString stringWithFormat:@"Radius: %@ meters", [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.radius]]];
        radius = [[GLGLabel alloc] initWithFrame:labelRect];
        [radius setStringValue:radiusValue];
        [self addSubview:radius];
        updateBlock();

        NSString *massValue = [NSString stringWithFormat:@"Mass: %@ kilograms", [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.mass]]];
        mass = [[GLGLabel alloc] initWithFrame:labelRect];
        [mass setStringValue:massValue];
        [self addSubview:mass];
        updateBlock();

        NSString *habitableZoneValue = [NSString stringWithFormat:@"Habitable Zone: %@ m", galaxy.star.habitableZoneRange];
        habitableZone = [[GLGLabel alloc] initWithFrame:labelRect];
        [habitableZone setStringValue:habitableZoneValue];
        [self addSubview:habitableZone];
        updateBlock();

        numPlanets = [[GLGLabel alloc] initWithFrame:labelRect];
        NSString *planetsString;
        if ([[galaxy planetoids] count] > 1) {
            planetsString = @"planets";
        }
        else {
            planetsString = @"planet";
        }

        NSString *readablePlanets = [NSString stringWithFormat:@"%lu %@", [[galaxy planetoids] count], planetsString];
        [numPlanets setStringValue:readablePlanets];
        [self addSubview:numPlanets];

        planetDetailViews = [[NSMutableArray alloc] initWithCapacity:[[galaxy planetoids] count]];

        [[galaxy planetoids] enumerateObjectsUsingBlock:^(GLGPlanetoid *planet, NSUInteger index, BOOL *stop) {
            GLGSidebarPlanetDetail *planetView = [[GLGSidebarPlanetDetail alloc] initWithPlanet:planet];
            [planetView setDelegate:delegate];
            [planetView setFrame:NSMakeRect(widthOfLabels + 5, currentHeight, widthOfLabels, heightOfLabels + 5)];
            [planetDetailViews addObject:planetView];
            [planetView release];
            [self addSubview:planetView];

            currentHeight += heightOfLabels + padding;
        }];

        [formatter release];
    }

    return self;
}

- (BOOL) isFlipped {
    return YES;
}

- (void) animateToFrame:(NSRect) frameRect {
    [[self animator] setFrame:frameRect];
    NSRect frame = [numPlanets frame];
    if (selected) {
        NSRect newFrame = NSMakeRect(-200, frame.origin.y, frame.size.width, frame.size.height);
        [[numPlanets animator] setFrame:newFrame];

        [planetDetailViews enumerateObjectsUsingBlock:^(GLGSidebarPlanetDetail *view, NSUInteger index, BOOL *stop) {
            NSRect frame = [view frame];
            [[view animator] setFrame:NSMakeRect(5, frame.origin.y, frame.size.width, frame.size.height)];
        }];
    }
    else {
        NSRect newFrame = NSMakeRect(5, frame.origin.y, frame.size.width, frame.size.height);
        [[numPlanets animator] setFrame:newFrame];
        [planetDetailViews enumerateObjectsUsingBlock:^(GLGSidebarPlanetDetail *view, NSUInteger index, BOOL *stop) {
            NSRect frame = [view frame];
            [[view animator] setFrame:NSMakeRect(frame.size.width + 5, frame.origin.y, frame.size.width, frame.size.height)];
        }];
    }
}

- (void) mouseUp:(NSEvent *) event {
    if (selected) {
        [delegate systemWasSelected:nil];
    }
    else {
        [delegate systemWasSelected: galaxy];
    }
}

- (void) setSelected:(BOOL) _selected {
    selected = _selected;

    if ([self selected]) {
        CGColorRef selectedColor = [[NSColor colorWithDeviceRed:0.3f green:0.8f blue:0.1f alpha:1.0] CGColor];
        [[self layer] setBorderColor:selectedColor];
    }
    else {
        CGColorRef defaultColor = [[NSColor blackColor] CGColor];
        [[self layer] setBorderColor:defaultColor];
    }
}

- (void) handlePlanetDisclosure {
    
}

@end
