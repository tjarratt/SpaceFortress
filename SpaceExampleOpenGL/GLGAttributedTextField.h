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
- (id)initWithFrame:(NSRect)              frame
              label:(NSString *)          label
              value:(NSString *)             value
              units:(NSString *)          units;
@end
