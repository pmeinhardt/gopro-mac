//
//  CameraWindowController.h
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/16/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GoProCamera.h"

@interface CameraWindowController : NSWindowController

// Reference to the connected camera
@property (nonatomic, retain) GoProCamera *camera;

// Window controls
@property (nonatomic, assign) IBOutlet NSProgressIndicator *spinner;
@property (nonatomic, assign) IBOutlet NSTextField *label;

// Indicates an ongoing request - used in Cocoa bindings of the window
@property (nonatomic, assign) BOOL loading;

// View actions
- (IBAction)sync:(id)sender;
- (IBAction)capture:(id)sender;
- (IBAction)setMode:(id)sender;

@end
