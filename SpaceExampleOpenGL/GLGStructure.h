//
//  GLGStructure.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/15/13.
//
//

#import <Foundation/Foundation.h>

@interface GLGStructure : NSObject

@property (retain) NSColor *color;
@property NSInteger heightInStories;
@property CGFloat length;
@property CGFloat point;

- (id) initAtPoint:(CGFloat) point withColor:(NSColor *)_color height:(NSInteger) _height length:(CGFloat) _length;
@end
