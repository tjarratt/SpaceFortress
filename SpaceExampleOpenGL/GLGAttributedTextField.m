//
//  GLGAttributedTextField.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/28/13.
//
//

#import "GLGAttributedTextField.h"

@implementation GLGAttributedTextField

- (id)initWithFrame:(NSRect) frame label:(NSString *) _label value:(NSString *) _value units:(NSString *) units {
    if (self = [super initWithFrame:frame]) {
        NSRange boldRange = NSMakeRange(0, [_label length]);
        NSDictionary *labelAttributes = @{NSFontAttributeName: [NSFont boldSystemFontOfSize:12]};

        NSMutableAttributedString *textfieldValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ %@", _label, _value, units]];
        [textfieldValue setAttributes:labelAttributes range:boldRange];

        [self setAttributedStringValue:textfieldValue];
    }
    
    return self;
}


@end
