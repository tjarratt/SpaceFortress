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

- (id)initWithFrame:(NSRect)frame delegate:(id) theDelegate andSystem:(GLGSolarSystem *) system {
    if (self = [super initWithFrame:frame]) {        
        galaxy = system;
        delegate = theDelegate;

        galaxyName = [[GLGLabel alloc] init];
        [galaxyName setStringValue:[galaxy name]];

        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.frame = self.frame;
        [[self layer] setCornerRadius:5.0];
        [[self layer] setBorderWidth:1.0];

        CGColorRef defaultColor = [[NSColor blackColor] CGColor];
        [[self layer] setBorderColor:defaultColor];

        NSString *starType = [NSString stringWithFormat:@"Class %@ star", [[galaxy star] spectralClassification]];
        starTypeField = [[GLGLabel alloc] init];
        [starTypeField setStringValue:starType];

        numPlanets = [[GLGLabel alloc] init];
        NSString *planetsString;
        if ([[galaxy planetoids] count] > 1) {
            planetsString = @"planets";
        }
        else {
            planetsString = @"planet";
        }

        NSString *readablePlanets = [NSString stringWithFormat:@"%lu %@", [[galaxy planetoids] count], planetsString];
        [numPlanets setStringValue:readablePlanets];

        planetDetailViews = [[NSMutableArray alloc] initWithCapacity:[[galaxy planetoids] count]];

        [[galaxy planetoids] enumerateObjectsUsingBlock:^(GLGPlanetoid *planet, NSUInteger index, BOOL *stop) {
            GLGSidebarPlanetDetail *planetView = [[GLGSidebarPlanetDetail alloc] initWithPlanet:planet];
            [planetView setDelegate:delegate];
            [planetDetailViews addObject:planetView];
            [planetView release];
        }];

        [self positionSubviews];
        [self addSubview:galaxyName];
        [self addSubview:starTypeField];
        [self addSubview:numPlanets];
        [planetDetailViews enumerateObjectsUsingBlock:^(GLGSidebarPlanetDetail *view, NSUInteger index, BOOL *stop) {
            [self addSubview:view];
        }];
    }

    return self;
}

- (BOOL) isFlipped {
    return YES;
}

- (CGFloat) positionSubviews {
    NSRect frame = [self frame];
    CGFloat height = frame.size.height;
    CGFloat heightOfLabels = 25.0f;
    CGFloat widthOfLabels = frame.size.width - 10;
    CGFloat numberOfLabels = 3.0f;

    if (selected) {
        numberOfLabels += [planetDetailViews count];
    }

    CGFloat padding = (height - (heightOfLabels * numberOfLabels)) / (numberOfLabels + 1);
    __block CGFloat currentHeight = padding;

    NSRect galaxyRect = NSMakeRect(5, currentHeight, widthOfLabels, heightOfLabels);
    [galaxyName setFrame:galaxyRect];

    currentHeight += heightOfLabels + padding;

    NSRect starTypeRect = NSMakeRect(5, currentHeight, widthOfLabels, heightOfLabels);
    [starTypeField setFrame:starTypeRect];

    currentHeight += heightOfLabels + padding;

    NSRect numPlanetsRect = NSMakeRect(5, currentHeight, widthOfLabels - 35, heightOfLabels);
    [numPlanets setFrame:numPlanetsRect];

    padding = 5;
    numberOfLabels = 20;
    CGFloat heightOfLabel = 25;
    CGFloat heightOfView = padding + (heightOfLabel + padding) * numberOfLabels;
    currentHeight -= padding;

    [planetDetailViews enumerateObjectsUsingBlock:^(GLGSidebarPlanetDetail *view, NSUInteger index, BOOL *stop) {
         NSRect planetFrame = NSMakeRect(0, currentHeight, frame.size.width, heightOfView);
        [view setFrame:planetFrame];
        [view bind:@"hidden" toObject:self withKeyPath:@"hidden" options:nil];
        currentHeight += heightOfLabel + padding;
    }];

    return heightOfView;
}

- (void) setFrame:(NSRect) frameRect {
    [super setFrame:frameRect];
    [numPlanets setHidden:selected];
    [self positionSubviews];
}

- (void) mouseUp:(NSEvent *) event {
    [delegate systemWasSelected: galaxy];
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

#pragma mark - planet viewing observer methods
- (BOOL) hidden {
    return !selected;
}

+ (NSSet *) keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    NSSet *affectedPaths = [[NSSet alloc] initWithArray:@[]];

    if ([affectedPaths containsObject:key]) {
        NSArray *otherPaths = @[@"activeSystemIndex"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:otherPaths];
    }

    [affectedPaths release];

    return keyPaths;
}

@end
