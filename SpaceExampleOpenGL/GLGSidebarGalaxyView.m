//
//  GLGSidebarGalaxyView.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/3/13.
//
//

#import "GLGSidebarGalaxyView.h"

@implementation GLGSidebarGalaxyView

@synthesize selected;
@synthesize galaxy;

- (id)initWithFrame:(NSRect)frame delegate:(id) theDelegate andSystem:(GLGSolarSystem *) system {
    if (self = [super initWithFrame:frame]) {        
        galaxy = system;
        delegate = theDelegate;

        CGFloat height = frame.size.height;
        CGFloat heightOfLabels = 20.0f;
        CGFloat widthOfLabels = frame.size.width - 10;
        CGFloat numberOfLabels = 3.0f;
        CGFloat padding = (height - (heightOfLabels * numberOfLabels)) / (numberOfLabels + 1);
        CGFloat currentHeight = height - padding - heightOfLabels;
        
        NSRect galaxyRect = NSMakeRect(5, currentHeight, widthOfLabels, heightOfLabels);
        GLGLabel *galaxyName = [[GLGLabel alloc] initWithFrame:galaxyRect];
        [galaxyName setStringValue:[system name]];
        [self addSubview:galaxyName];
        [galaxyName release];
        
        currentHeight -= heightOfLabels + padding;
        
        NSRect starTypeRect = NSMakeRect(5, currentHeight, widthOfLabels, heightOfLabels);
        NSString *starType = [NSString stringWithFormat:@"Class %@ star", [[system star] spectralClassification]];
        GLGLabel *starTypeField = [[GLGLabel alloc] initWithFrame:starTypeRect];
        [starTypeField setStringValue:starType];
        [self addSubview:starTypeField];
        [starTypeField release];
        
        currentHeight -= heightOfLabels + padding;
        
        NSRect numPlanetsRect = NSMakeRect(5, currentHeight, widthOfLabels, heightOfLabels);
        GLGLabel *numPlanets = [[GLGLabel alloc] initWithFrame:numPlanetsRect];
        NSString *planetsString;
        if ([[system planetoids] count] > 1) {
            planetsString = @"planets";
        }
        else {
            planetsString = @"planet";
        }
        
        NSString *readablePlanets = [NSString stringWithFormat:@"%lu %@", [[system planetoids] count], planetsString];
        [numPlanets setStringValue:readablePlanets];
        [self addSubview:numPlanets];
        [numPlanets release];
    }
    
    return self;
}

- (void)drawRect:(NSRect) rect {
    NSRect frameRect = [self bounds];
    if (rect.size.height < frameRect.size.height) {
        return;
    }
    
    int borderSize = 2;
    NSRect newRect = NSMakeRect(rect.origin.x + borderSize, rect.origin.y + borderSize, rect.size.width - 4, rect.size.height - 4);

    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:10 yRadius:10];
    [borderPath setLineWidth:borderSize];
    
    NSColor *borderColor;
    if (selected) {
        borderColor = [NSColor colorWithDeviceRed:0.3f green:0.8f blue:0.1f alpha:1.0];
    }
    else {
        borderColor = [NSColor blackColor];
    }
    
    [borderColor set];
    [borderPath stroke];
}

- (void) mouseUp:(NSEvent *) event {
    if (!selected) {
        [delegate systemWasSelected: galaxy];
    }
}

@end
