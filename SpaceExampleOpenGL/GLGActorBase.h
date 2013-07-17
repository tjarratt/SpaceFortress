//
//  GLGActorBase.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/16/13.
//
//

#import <Foundation/Foundation.h>
#import "GLGActor.h"

@interface GLGActorBase : NSObject
- (void) handleMouseUp;
- (void) handleMouseDown:(NSPoint) point;
@end
