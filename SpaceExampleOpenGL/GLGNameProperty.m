//
//  GLGNameProperty.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/28/13.
//
//

#import "GLGNameProperty.h"

@implementation GLGNameProperty

static NSArray *latinWords;
static NSArray *greekAlphabet;
static NSArray *romanNumerals;

+ (void) initialize {
    [self readGreekAlphabet];
    [self readLatinWords];

    romanNumerals = @[@"I", @"II", @"III", @"IV", @"V", @"VI", @"VII", @"VIII", @"IX", @"X", @"XI"];
    [romanNumerals retain];
}

+ (NSString *) numeralForDigit: (NSInteger) n {
    assert(n < [romanNumerals count] && n >= 0);
    
    return [romanNumerals objectAtIndex:n];
}

+ (NSInteger) randomIntegerBetweenZeroAnd: (NSInteger) maximum {
    CGFloat scale = (CGFloat) arc4random() / 0x100000000;
    return scale * maximum;
}

+ (NSString *) randomName {
    NSString *first = [[greekAlphabet objectAtIndex: [self randomIntegerBetweenZeroAnd: [greekAlphabet count]]] capitalizedString];
    NSString *second = [[latinWords objectAtIndex: [self randomIntegerBetweenZeroAnd:[latinWords count]]] capitalizedString];
    
    return [NSString stringWithFormat:@"%@ %@", first, second];
}

#pragma mark - initializers
+ (void) readLatinWords {
    NSError *error;
    NSString *latinPath = [[NSBundle mainBundle] pathForResource:@"latin" ofType:@"txt"];
    NSString *words = [[NSString alloc] initWithContentsOfFile:latinPath encoding:NSUTF8StringEncoding error:&error];
    
    latinWords = [words componentsSeparatedByString:@"\n"];
    [latinWords retain];
    [words release];
}

+ (void) readGreekAlphabet {
    NSError *error;
    NSString *greekPath = [[NSBundle mainBundle] pathForResource:@"greek_alphabet" ofType:@"txt"];
    NSString *alphabet = [[NSString alloc] initWithContentsOfFile:greekPath encoding:NSUTF8StringEncoding error:&error];
    
    greekAlphabet = [alphabet componentsSeparatedByString:@"\n"];
    [greekAlphabet retain];
    [alphabet release];
}
@end
