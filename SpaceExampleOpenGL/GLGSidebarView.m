//
//  GLGSidebarView.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/25/13.
//
//

#import "GLGSidebarView.h"

@implementation GLGSidebarView

- (id)initWithFrame:(NSRect)frame system: (GLGSolarSystem *) system andDelegate: (id) delegate {
    if (self = [super initWithFrame:frame]) {
        NSTextField *framerateValue = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
        [framerateValue setEditable:NO];
        [framerateValue bind:@"value" toObject:delegate withKeyPath:@"framerate" options:nil];
        [self addSubview:framerateValue];
        [framerateValue release];
        
        NSTextField *framerateLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 20, 100, 30)];
        [framerateLabel setEditable:NO];
        [framerateLabel setStringValue:@"Framerate"];
        [framerateLabel setBezeled:NO];
        [framerateLabel setSelectable:NO];
        [framerateLabel setBackgroundColor:[NSColor clearColor]];
        [self addSubview:framerateLabel];
        [framerateLabel release];
        
        NSTextField *radiusLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 100, 100, 40)];
        [radiusLabel setEditable:NO];
        [radiusLabel setStringValue:@"Percentage Solar Radius"];
        [radiusLabel setBezeled:NO];
        [radiusLabel setSelectable:NO];
        [radiusLabel setBackgroundColor:[NSColor clearColor]];
        [self addSubview:radiusLabel];
        [radiusLabel release];
        
        NSTextField *radiusValue = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 75, 100, 30)];
        [radiusValue setEditable:NO];
        NSString *radius_string = [NSString stringWithFormat:@"%f", system.star.radiusComparison];
        [radiusValue setStringValue: radius_string];
        [self addSubview:radiusValue];
        [radiusValue release];
        
        NSTextField *massLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 205, 100, 30)];
        [massLabel setEditable:NO];
        [massLabel setStringValue:@"Percentage Solar Mass"];
        [massLabel setBezeled:NO];
        [massLabel setSelectable:NO];
        [massLabel setBackgroundColor:[NSColor clearColor]];
        [self addSubview:massLabel];
        [massLabel release];
        
        NSString *massString = [NSString stringWithFormat:@"%f", system.star.massComparison];
        NSTextField *massValue = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 170, 100, 30)];
        [massValue setEditable:NO];
        [massValue setStringValue:massString];
        [self addSubview:massValue];
        [massValue release];
        
        NSTextField *surfaceTemperatureLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 305, 100, 30)];
        [surfaceTemperatureLabel setEditable:NO];
        [surfaceTemperatureLabel setStringValue:@"Percentage Solar Surface Temperature"];
        [surfaceTemperatureLabel setBezeled:NO];
        [surfaceTemperatureLabel setSelectable:NO];
        [surfaceTemperatureLabel setBackgroundColor:[NSColor clearColor]];
        [self addSubview:surfaceTemperatureLabel];
        [surfaceTemperatureLabel release];
        
        NSString *surfaceTemperatureString = [NSString stringWithFormat:@"%f", system.star.surfaceTemperatureComparison];
        NSTextField *surfaceTemperatureValue = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 270, 100, 30)];
        [surfaceTemperatureValue setEditable:NO];
        [surfaceTemperatureValue setStringValue:surfaceTemperatureString];
        [self addSubview:surfaceTemperatureValue];
        [surfaceTemperatureValue release];
        
        NSTextField *metallicityLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 405, 100, 35)];
        [metallicityLabel setEditable:NO];
        [metallicityLabel setStringValue:@"Percentage Solar Metallicity"];
        [metallicityLabel setBezeled:NO];
        [metallicityLabel setSelectable:NO];
        [metallicityLabel setBackgroundColor:[NSColor clearColor]];
        [self addSubview:metallicityLabel];
        [metallicityLabel release];
        
        NSString *metallicityString = [NSString stringWithFormat:@"%f", system.star.metallicityComparison];
        NSTextField *metallicityValue = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 370, 100, 30)];
        [metallicityValue setEditable:NO];
        [metallicityValue setStringValue:metallicityString];
        [self addSubview:metallicityValue];
        [metallicityValue release];
        
        NSButton *reset = [[NSButton alloc] initWithFrame:NSMakeRect(10, 740, 80, 30)];
        [reset setTitle:@"Reset"];
        [reset setTarget:delegate];
        [reset setAction:@selector(resetSystem)];
        [self addSubview:reset];
        [reset release];
    }
    
    return self;
}

@end
