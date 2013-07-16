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
        CGFloat numberOfLabels = 3.0f;
        CGFloat padding = (height - (heightOfLabels * numberOfLabels)) / (numberOfLabels + 1);
        __block CGFloat currentHeight = padding;

        galaxyName = [[GLGLabel alloc] initWithFrame:NSMakeRect(5, currentHeight, widthOfLabels, heightOfLabels)];
        [galaxyName setStringValue:[galaxy name]];
        [self addSubview:galaxyName];

        currentHeight += heightOfLabels + padding;

        NSString *starType = [NSString stringWithFormat:@"Class %@ star", [[galaxy star] spectralClassification]];
        starTypeField = [[GLGLabel alloc] initWithFrame:NSMakeRect(5, currentHeight, widthOfLabels, heightOfLabels)];
        [starTypeField setStringValue:starType];
        [self addSubview:starTypeField];

        currentHeight += heightOfLabels + padding;

        numPlanets = [[GLGLabel alloc] initWithFrame:NSMakeRect(5, currentHeight, widthOfLabels, heightOfLabels)];
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

@end
