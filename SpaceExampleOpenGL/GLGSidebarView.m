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
        NSTextField *framerate_value = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
        [framerate_value setEditable:NO];
        [framerate_value bind:@"value" toObject:delegate withKeyPath:@"framerate" options:nil];
        [self addSubview:framerate_value];
        [framerate_value release];
        
        NSTextField *framerate_label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 20, 100, 30)];
        [framerate_label setEditable:NO];
        [framerate_label setStringValue:@"Framerate"];
        [framerate_label setBezeled:NO];
        [framerate_label setSelectable:NO];
        [framerate_label setBackgroundColor:[NSColor clearColor]];
        [self addSubview:framerate_label];
        [framerate_label release];
        
        NSTextField *radius_label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 100, 100, 40)];
        [radius_label setEditable:NO];
        [radius_label setStringValue:@"Percentage Solar Radius"];
        [radius_label setBezeled:NO];
        [radius_label setSelectable:NO];
        [radius_label setBackgroundColor:[NSColor clearColor]];
        [self addSubview:radius_label];
        [radius_label release];
        
        NSTextField *radius_value = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 75, 100, 30)];
        [radius_value setEditable:NO];
        NSString *radius_string = [NSString stringWithFormat:@"%f", system.star.radius_comparison];
        [radius_value setStringValue: radius_string];
        [self addSubview:radius_value];
        [radius_value release];
        
        NSTextField *mass_label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 205, 100, 30)];
        [mass_label setEditable:NO];
        [mass_label setStringValue:@"Percentage Solar Mass"];
        [mass_label setBezeled:NO];
        [mass_label setSelectable:NO];
        [mass_label setBackgroundColor:[NSColor clearColor]];
        [self addSubview:mass_label];
        [mass_label release];
        
        NSString *mass_string = [NSString stringWithFormat:@"%f", system.star.mass_comparison];
        NSTextField *mass_value = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 170, 100, 30)];
        [mass_value setEditable:NO];
        [mass_value setStringValue:mass_string];
        [self addSubview:mass_value];
        [mass_value release];
        
        NSTextField *surface_temperature_label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 305, 100, 30)];
        [surface_temperature_label setEditable:NO];
        [surface_temperature_label setStringValue:@"Percentage Solar Surface Temperature"];
        [surface_temperature_label setBezeled:NO];
        [surface_temperature_label setSelectable:NO];
        [surface_temperature_label setBackgroundColor:[NSColor clearColor]];
        [self addSubview:surface_temperature_label];
        [surface_temperature_label release];
        
        NSString *surface_temperature_string = [NSString stringWithFormat:@"%f", system.star.surface_temperature_comparison];
        NSTextField *surface_temperature_value = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 270, 100, 30)];
        [surface_temperature_value setEditable:NO];
        [surface_temperature_value setStringValue:surface_temperature_string];
        [self addSubview:surface_temperature_value];
        [surface_temperature_value release];
        
        NSTextField *metallicity_label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 405, 100, 35)];
        [metallicity_label setEditable:NO];
        [metallicity_label setStringValue:@"Percentage Solar Metallicity"];
        [metallicity_label setBezeled:NO];
        [metallicity_label setSelectable:NO];
        [metallicity_label setBackgroundColor:[NSColor clearColor]];
        [self addSubview:metallicity_label];
        [metallicity_label release];
        
        NSString *metallicity_string = [NSString stringWithFormat:@"%f", system.star.metallicity_comparison];
        NSTextField *metallicity_value = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 370, 100, 30)];
        [metallicity_value setEditable:NO];
        [metallicity_value setStringValue:metallicity_string];
        [self addSubview:metallicity_value];
        [metallicity_value release];
    }
    
    return self;
}

@end
