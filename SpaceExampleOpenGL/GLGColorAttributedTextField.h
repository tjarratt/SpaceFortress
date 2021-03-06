//
//  GLGColorAttributedTextField.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/29/13.
//
//

#import <Cocoa/Cocoa.h>
#import "GLGLabel.h"
#import "GLGFloatPair.h"

@interface GLGColorAttributedTextField : GLGLabel

- (id)initWithFrame:(NSRect) frame
              label:(NSString *) label
              value:(CGFloat) value
        targetValue:(CGFloat) target
              range:(GLGFloatPair *) range
              units:(NSString *) units
          formatter:(NSNumberFormatter *)formatter;

@end
