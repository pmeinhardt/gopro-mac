//
//  ConnectWindowController.h
//  GoPro
//
//  Created by Paul Meinhardt on 11/16/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ConnectWindowController : NSWindowController

// Controls in the window
@property (nonatomic, assign) IBOutlet NSProgressIndicator *indicator;
@property (nonatomic, assign) IBOutlet NSTextField *field;
@property (nonatomic, assign) IBOutlet NSButton *button;

// Indicates an ongoing connection attempt - used in Cocoa bindings of the window
@property (nonatomic, assign) BOOL loading;

// View actions
- (IBAction)confirm:(id)sender;

@end
