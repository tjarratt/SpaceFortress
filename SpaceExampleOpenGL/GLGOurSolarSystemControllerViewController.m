//
//  GLGOurSolarSystemControllerViewController.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/25/13.
//
//

#import "GLGOurSolarSystemControllerViewController.h"

@implementation GLGOurSolarSystemControllerViewController

- (void) BasicOpenGLView:(GLGView *)view drawInRect:(NSRect)rect {
    [super BasicOpenGLView:view drawInRect:rect];
    
    CGFloat scale = [self frame_number] * 2 * M_PI / (float) 600;
    CGFloat meters_to_pixels_scale = 3.543e-9 / 2;
    CGFloat x, y, px, py;

    // sun is currently hardcoded to the center
    glColor3f(1.0f, 0.85f, 0.35f);
    x = view.bounds.size.width / 2;
    y = view.bounds.size.height / 2;
    [view drawCircleWithRadius:30 centerX:x centerY:y];

    // mercury 0.4 AU
    glColor3f(0.85f, 0.35f, 0.35f);
    CGFloat au = 1.49e11;
    CGFloat mercury_max = 0.46 * au;
    CGFloat mercury_min = 0.3 * au;
    CGFloat mercury_radius = 2;
    px = x + mercury_max * cos(scale * 4.2) * meters_to_pixels_scale;
    py = y + mercury_min * sin(scale * 4.2) * meters_to_pixels_scale;
    [view drawCircleWithRadius:mercury_radius centerX:px centerY:py];

    // venus 0.7 AU
    CGFloat venus_min = 0.728 * au;
    CGFloat venus_max = 0.718 * au;
    CGFloat venus_radius = 5;
    glColor3f(0.85f, 0.85f, 0.85f);
    px = x + venus_max * cos(scale * 1.62) * meters_to_pixels_scale;
    py = y + venus_min * sin(scale * 1.62) * meters_to_pixels_scale;
    [view drawCircleWithRadius:venus_radius centerX:px centerY:py];

    // earth 1 AU
    CGFloat earth_max = 1.01 * au;
    CGFloat earth_min = 0.98 * au;
    CGFloat earth_radius = 6;
    glColor3f(0.1f, 0.35f, 0.85f);
    px = x + earth_max * cos(scale) * meters_to_pixels_scale;
    py = y + earth_min * sin(scale) * meters_to_pixels_scale;
    [view drawCircleWithRadius:earth_radius centerX:px centerY:py];

    // mars 1.5 AU
    CGFloat mars_max = 1.665 * au;
    CGFloat mars_min = 1.381 * au;
    CGFloat mars_radius = 3;
    glColor3f(0.9f, 0.5f, 0.1f);
    px = x + mars_max * cos(scale / 2) * meters_to_pixels_scale;
    py = y + mars_min * sin(scale / 2) * meters_to_pixels_scale;
    [view drawCircleWithRadius:mars_radius centerX:px centerY:py];

    return; // having trouble fitting more than 4 planets in currently

    // jupiter 5.2AU
    CGFloat jupiter_max = 5.45 * au;
    CGFloat jupiter_min = 4.9 * au;
    CGFloat jupiter_radius = 52.5;
    glColor3f(0.35f, 0.35f, 0.35f);
    px = x + 450 * cos(scale);
    py = y + 275 * sin(scale);
    [view drawCircleWithRadius:jupiter_radius centerX:px centerY:py];

    // saturn 9.5 AU
    CGFloat saturn_max = 10.11 * au;
    CGFloat saturn_min = 9.04 * au;
    CGFloat saturn_radius = 45;
    glColor3f(0.2f, 0.2f, 0.3f);
    px = x + 466 * cos(scale);
    py = y + 300 * sin(scale);
    [view drawCircleWithRadius:saturn_radius centerX:px centerY:py];

    // uranus 19.6 AU
    CGFloat uranus_max = 20.08 * au;
    CGFloat uranus_min = 18.375 * au;
    CGFloat uranus_radius = 20;
    glColor3f(0.9f, 0.1f, 0.7f);
    px = x + 488 * cos(scale);
    py = y + 322 * sin(scale);
    [view drawCircleWithRadius:uranus_radius centerX:px centerY:py];

    // neptune 30 AU
    CGFloat neptune_max = 30.44 * au;
    CGFloat neptune_min = 29.76 * au;
    CGFloat neptune_radius = 19.415;
    glColor3f(0.1f, 0.3f, 0.9f);
    px = x + 500 * cos(scale);
    py = y + 350 * sin(scale);
    [view drawCircleWithRadius:neptune_radius centerX:px centerY:py];
}
    
@end
