//
//  GLGAppDelegate.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/13/13.
//
//

#import <Cocoa/Cocoa.h>
#include "GLGOpenGLController.h"

@interface GLGAppDelegate : NSObject <NSApplicationDelegate> {
    GLGOpenGLController *controller;
}

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
