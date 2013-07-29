//
//  GLGAttributedTextField.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/28/13.
//
//

#import <Cocoa/Cocoa.h>
#import "GLGLabel.h"

@interface GLGAttributedTextField : GLGLabel
- (id)initWithFrame:(NSRect) frame label:(NSString *) _label value:(NSString *) _value units:(NSString *) units;
@end
