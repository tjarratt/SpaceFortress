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
              range:(GLGFloatPair *) range
              units:(NSString *) units
          formatter:(NSNumberFormatter *)formatter {

    if (self = [super initWithFrame:frame]) {
        NSRange boldRange = NSMakeRange(0, [label length]);
        NSDictionary *labelAttributes = @{
                                          NSFontAttributeName: [NSFont boldSystemFontOfSize:12],
                                          };

        NSString *valueString = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];

        NSColor *color;
        CGFloat min = [range first];
        CGFloat max = [range second];
        CGFloat step = fabsf((max - min) / 9.0);
        int deviation = (int) fabsf(ceilf((target - value) / step));

        switch(deviation) {
            case 0:
                color = [NSColor colorWithDeviceRed:0.1f green:0.8f blue:0.3f alpha:1.0];
                break;
            case 1:
                color = [NSColor colorWithDeviceRed:0.31f green:0.82f blue:0.23f alpha:1.0];
                break;
            case 2:
                color = [NSColor colorWithDeviceRed:0.63f green:0.85f blue:0.16f alpha:1.0f];
                break;
            case 3:
                color = [NSColor colorWithDeviceRed:0.71f green:0.825f blue:0.13f alpha:1.0f];
                break;
            case 4:
                color = [NSColor colorWithDeviceRed:0.8f green:0.8f blue:0.1f alpha:1.0f];
                break;
            case 5:
                color = [NSColor colorWithDeviceRed:0.825f green:0.65f blue:0.175f alpha:1.0f];
                break;
            case 6:
                color = [NSColor colorWithDeviceRed:0.85f green:0.5f blue:0.25f alpha:1.0];
                break;
            case 7:
                color = [NSColor colorWithDeviceRed:0.85f green:0.3f blue:0.275f alpha:1.0f];
                break;
            case 8:
                color = [NSColor colorWithDeviceRed:0.85f green:0.1f blue:0.3f alpha:1.0f];
                break;
            default:
                assert( false );
        }

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
