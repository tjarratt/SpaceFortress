//
//  GLGAppDelegate.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/13/13.
//
//

#import <OpenGL/OpenGL.h>
#import <Cocoa/Cocoa.h>

#include "BasicOpenGLView.h"

@interface GLGAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
