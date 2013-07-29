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

        galaxyName = [[GLGAttributedTextField alloc] initWithFrame:labelRect];
        [galaxyName setStringValue:[galaxy name]];
        [self addSubview:galaxyName];
        updateBlock();

        NSString *starType = [NSString stringWithFormat:@"Class %@ star", [[galaxy star] spectralClassification]];
        starTypeField = [[GLGAttributedTextField alloc] initWithFrame:labelRect];
        [starTypeField setStringValue:starType];
        [self addSubview:starTypeField];
        updateBlock();

        NSString *metallicityValue = [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.metallicity]];
        metallicity = [[GLGAttributedTextField alloc] initWithFrame:labelRect label:@"Metallicity:" value:metallicityValue units:@""];
        [self addSubview:metallicity];
        updateBlock();

        NSString *magnitudeValue = [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.apparentMagnitude]];
        apparentMagnitude = [[GLGAttributedTextField alloc] initWithFrame:labelRect label:@"Apparent Magnitude:" value:magnitudeValue units:@""];
        [self addSubview:apparentMagnitude];
        updateBlock();
        
        NSString *luminosityValue = [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.luminosity]];
        luminosity = [[GLGAttributedTextField alloc] initWithFrame:labelRect label:@"Luminosity" value:luminosityValue units:@"lumens"];
        [self addSubview:luminosity];
        updateBlock();

        NSString *temperatureValue = [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.surfaceTemperature]];
        surfaceTemperature = [[GLGAttributedTextField alloc] initWithFrame:labelRect label:@"Surface Temp" value:temperatureValue units:@"K"];
        [self addSubview:surfaceTemperature];
        updateBlock();

        NSString *rotationValue = [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.rotationRate]];
        rotationRate = [[GLGAttributedTextField alloc] initWithFrame:labelRect label:@"Rotation period:" value:rotationValue units:@"secs"];
        [self addSubview:rotationRate];
        updateBlock();

        NSString *radiusValue = [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.radius]];
        radius = [[GLGAttributedTextField alloc] initWithFrame:labelRect label:@"Radius:" value:radiusValue units:@"m"];
        [self addSubview:radius];
        updateBlock();

        NSString *massValue = [formatter stringFromNumber:[NSNumber numberWithFloat:galaxy.star.mass]];
        mass = [[GLGAttributedTextField alloc] initWithFrame:labelRect label:@"Mass:" value:massValue units:@"grams"];
        [self addSubview:mass];
        updateBlock();

        habitableZone = [[GLGAttributedTextField alloc] initWithFrame:labelRect label:@"Habitable Zone:" value:galaxy.star.habitableZoneRange units:@"m"];
        [self addSubview:habitableZone];
        updateBlock();

        numPlanets = [[GLGAttributedTextField alloc] initWithFrame:labelRect];
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
