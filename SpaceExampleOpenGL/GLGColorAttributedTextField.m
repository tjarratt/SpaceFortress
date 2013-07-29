//
//  GLGColorAttributedTextField.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/29/13.
//
//

#import "GLGColorAttributedTextField.h"

@implementation GLGColorAttributedTextField

- (id)initWithFrame:(NSRect) frame
              label:(NSString *) label
              value:(CGFloat) value
        targetValue:(CGFloat) target
              units:(NSString *) units
          formatter:(NSNumberFormatter *)formatter {

    if (self = [super initWithFrame:frame]) {
        NSRange boldRange = NSMakeRange(0, [label length]);
        NSDictionary *labelAttributes = @{
                                          NSFontAttributeName: [NSFont boldSystemFontOfSize:12],
                                          };

        NSString *valueString = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
        NSColor *color = [NSColor colorWithDeviceRed:55555 green:0.5 blue:0.30 alpha:1];
        NSRange colorRange = NSMakeRange(label.length + 1, valueString.length);
        NSDictionary *valueAttributes = @{
                                          NSForegroundColorAttributeName: color
                                          };
        NSMutableAttributedString *textfieldValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ %@", label, valueString, units]];
        
        [textfieldValue setAttributes:labelAttributes range:boldRange];
        [textfieldValue setAttributes:valueAttributes range:colorRange];
        [self setAttributedStringValue:textfieldValue];

        [textfieldValue release];
    }
    
    return self;
}

@end
