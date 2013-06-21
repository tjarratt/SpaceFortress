//
//  GLGSolarStar.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import <Foundation/Foundation.h>


/*
facts:
  85% of all stars are red dwarfs
*/

@interface GLGSolarStar : NSObject {
    CGFloat radius;
    CGFloat mass;
    CGFloat surface_temperature;
    NSUInteger rotation_rate_in_seconds;
    NSString *name;
    
    // percentage of its mass not derived from hydrogen, helium
    // http://en.wikipedia.org/wiki/Metallicity
    CGFloat metallicity;
}

@property CGFloat age;

// classification (O B A B G K M)
// http://en.wikipedia.org/wiki/Spectral_classification
- (NSString *) spectralClassification;
- (CGFloat) luminosity;
- (CGFloat) escapeVelocity;

@end
