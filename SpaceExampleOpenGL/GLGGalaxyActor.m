//
//  GLGGalaxyActor.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 8/10/13.
//
//

#import "GLGGalaxyActor.h"

@implementation GLGGalaxyActor

@synthesize selectedPlanet;
@synthesize wantsPsychedelia;
@synthesize zoomScale, origin;

- (id) init {
    if (self = [super init]) {
        planetSizeWeight = 1000;
    }

    return self;
}

- (void) updateWithView:(GLGOpenGLView *) view {
    CGFloat __block x, y, px, py, pxp, pyp;
    CGFloat zoomScaleFactor = powf(1.01, [zoomScale currentValue]);
    CGFloat metersToPixelsScale = 3.543e-9 * zoomScaleFactor;
    CGFloat scale = frameNumber * M_PI / 1.0e12;

    NSPoint currentOrigin = [origin currentValue];
    x = view.bounds.size.width / 2 + currentOrigin.x;
    y = view.bounds.size.height / 2 + currentOrigin.y;

    if (selectedPlanet != nil) {
        CGFloat planetX = -1 * selectedPlanet.apogeeMeters * metersToPixelsScale * cos(scale * selectedPlanet.rotationAroundSolarBodySeconds);
        CGFloat planetY = -1 * selectedPlanet.perogeeMeters * metersToPixelsScale * sin(scale * selectedPlanet.rotationAroundSolarBodySeconds);

        [origin setPoint:NSMakePoint(planetX, planetY)];
    }

    [self drawStarFieldInView:view];

    GLGSolarSystem *system = [self activeSystem];
    GLGSolarStar *star = [system star];
    NSColor *solarColor = [star color];
    glColor4f(solarColor.redComponent, solarColor.greenComponent, solarColor.blueComponent, 1.0f);
    CGFloat solarRadius = MAX(5, [star radius] * metersToPixelsScale);
    [view drawCircleWithRadius:solarRadius centerX:x centerY:y];

    glColor4f(0.1f, 0.65f, 0.1f, 1.0f);
    CGFloat innerRadius = star.habitableZoneInnerRadius * metersToPixelsScale;
    CGFloat outerRadius = star.habitableZoneOuterRadius * metersToPixelsScale;
    [view drawTorusAtPoint:NSMakePoint(x, y) innerRadius:innerRadius outerRadius:outerRadius];

    [[system planetoids] enumerateObjectsUsingBlock:^(GLGPlanetoid *planet, NSUInteger index, BOOL *stop) {
        [view drawOrbitForPlanet:planet atScale:zoomScaleFactor atOrigin:[origin currentValue]];
    }];

    [[system planetoids] enumerateObjectsUsingBlock:^(GLGPlanetoid *planet, NSUInteger index, BOOL *stop) {
        if ([self wantsPsychedelia]) {
            [self drawTrailersForPlanet:planet onView:view];
        }

        CGFloat radius = MAX([planet radius] * metersToPixelsScale * planetSizeWeight, 1);

        px = x + planet.apogeeMeters * metersToPixelsScale * cos(scale * planet.rotationAroundSolarBodySeconds);
        py = y + planet.perogeeMeters * metersToPixelsScale * sin(scale * planet.rotationAroundSolarBodySeconds);

        pxp = px * cos(planet.rotationAngleAroundStar) - py * sin(planet.rotationAngleAroundStar);
        pyp = px * sin(planet.rotationAngleAroundStar) + py * cos(planet.rotationAngleAroundStar);

        CGFloat translated_x = x * cos(planet.rotationAngleAroundStar) - y * sin(planet.rotationAngleAroundStar);
        CGFloat translated_y = x * sin(planet.rotationAngleAroundStar) + y * cos(planet.rotationAngleAroundStar);
        pxp -= (translated_x - x);
        pyp -= (translated_y - y);

        glColor3f(planet.color.redComponent, planet.color.greenComponent, planet.color.blueComponent);
        [view drawCircleWithRadius:radius centerX:pxp centerY:pyp];
    }];
}

- (void) drawStarFieldInView:(GLGOpenGLView *) view {
    glColor3f(1.0, 1.0, 1.0);
    NSMutableArray *starfield = [[self activeSystem] starField];
    [starfield enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger index, BOOL *stop) {
        NSPoint p = [value pointValue];
        [view drawCircleWithRadius:1 centerX:p.x centerY:p.y];
    }]; 
}

- (void) drawTrailersForPlanet:(GLGPlanetoid *) planet onView:(GLGOpenGLView *) view {
    // draw each of the trailers
    // and update their positions
    // say each of these will be visible for 10 frames

    // behavior is basically to have a trail of trailing frames
    // every 10 (say) frames, phase out the last one and emit a new one at
    // the previous position (basically using a ring buffer?)
    // this means that the alpha should fade out as it gets to the edge (probably logarithmic)
    // probably means that I should have more than ~10 frames to make this more seemless
    [planet tick];

    CGFloat __block x, y, px, py, pxp, pyp;
    NSUInteger count = [[planet trailers] count];
    CGFloat zoomScaleFactor = powf(1.01, [zoomScale currentValue]);
    CGFloat metersToPixelsScale = 3.543e-9 * zoomScaleFactor;

    NSPoint currentOrigin = [origin currentValue];
    x = view.bounds.size.width / 2 + currentOrigin.x;
    y = view.bounds.size.height / 2 + currentOrigin.y;

    [[planet trailers] enumerateObjectsUsingBlock:^(GLGPsychedeliaTrailer *trail, NSUInteger index, BOOL *stop) {
        CGFloat scale = (frameNumber - 10 * (count - index)) * M_PI / 1.0e12;

        CGFloat radius = MAX([planet radius] * metersToPixelsScale * planetSizeWeight, 1);
        px = x + planet.apogeeMeters * metersToPixelsScale * cos(scale * planet.rotationAroundSolarBodySeconds);
        py = y + planet.perogeeMeters * metersToPixelsScale * sin(scale * planet.rotationAroundSolarBodySeconds);

        pxp = px * cos(planet.rotationAngleAroundStar) - py * sin(planet.rotationAngleAroundStar);
        pyp = px * sin(planet.rotationAngleAroundStar) + py * cos(planet.rotationAngleAroundStar);

        CGFloat translated_x = x * cos(planet.rotationAngleAroundStar) - y * sin(planet.rotationAngleAroundStar);
        CGFloat translated_y = x * sin(planet.rotationAngleAroundStar) + y * cos(planet.rotationAngleAroundStar);
        pxp -= (translated_x - x);
        pyp -= (translated_y - y);

        CGFloat alpha = 0 + (0.09 * index);
        glColor4f(trail.color.redComponent, trail.color.greenComponent, trail.color.blueComponent, alpha);
        [view drawCircleWithRadius:radius centerX:pxp centerY:pyp];
    }];
}

- (GLGSolarSystem *) activeSystem {
    return _system;
}

- (NSUInteger) frameNumber {
    return frameNumber;
}

- (void) updateFramerate {
    return;
}

- (void) incrementFrameNumber {
    frameNumber += 1 * [speedOfTime currentValue];
}

- (void) didPanByVector:(CGPoint) vector {

}

- (void) didZoom:(CGFloat) amount {
    
}


@end
