//
//  constants.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/28/13.
//
//

#import "constants.h"

const CGFloat chandrasekharLimit = 2.864e30;

#pragma mark - Sol consants
const CGFloat solarAge = 4.57e9; // billions of years
const CGFloat solarMass = 1.989e30; //kilograms
const CGFloat solarRadius = 6.96e8; //meters
const CGFloat solarSurfaceTemperature = 5887;
const CGFloat solarRotationRate = 2592000; // 25-30 earth days
const CGFloat solarMetallicity = 0; // or 1.2% by ratio of H + He to remaining
const CGFloat solarBolometricMagnitude = 4.72;
const CGFloat solarLuminosity = 3.839e26;

#pragma mark - star property ranges
const CGFloat minimumSolarAge = 1;
const CGFloat maximumSolarAge = 11; // billions of years

const CGFloat minimumSolarMetallicity = -2;
const CGFloat maximumSolarMetallicity = 2;

const CGFloat minimumSolarSurfaceTemperature = 1000;
const CGFloat maximumSolarSurfaceTemperature = 50000;

const CGFloat minimumSolarRotationRate = 1e-5;
const CGFloat maximumSolarRotationRate = 150 * solarRotationRate;

// http://www.astro.wisc.edu/~dolan/constellations/extra/brightest.html
const CGFloat minimumSolarAbsMagnitude = -8;
const CGFloat maximumSolarAbsMagnitude = 16;

const CGFloat minimumSolarAppMagnitude = -38;
const CGFloat maximumSolarAppMagnitude = 38;

const CGFloat minimumSolarLuminosity = 5.83e22;
const CGFloat maximumSolarLuminosity = 6.98e33;

const CGFloat minimumSolarMass = 1.76e29;
const CGFloat maximumSolarMass = 264 * solarMass;

const CGFloat minimumSolarRadius = 0.13 * solarRadius;
const CGFloat maximumSolarRadius = 18 * solarRadius;

const CGFloat minimumSolarPlanets = 0;
const CGFloat maximumSolarPlanets = 10;

#pragma mark - universal constants
const CGFloat universalGravitationConstant = 6.67e-11;
const CGFloat maximumMassBeforeNuclearFusion = 9.9945e28;
const CGFloat astronomicalUnit = 1.49e11; // mean earth-sun distance

#pragma mark - earth constants
const CGFloat earthRadius = 6.371e+6;
const CGFloat earthDensity = 5.515;
const CGFloat earthEscapeVelocity = 11.186;
const CGFloat earthSurfaceTemperature = 288;