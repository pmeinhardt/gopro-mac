//
//  GPCameraWindowController.h
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/16/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GPCamera.h"

@interface GPCameraWindowController : NSWindowController

@property (nonatomic, assign) IBOutlet NSProgressIndicator *spinner;
@property (nonatomic, assign) IBOutlet NSTextField *label;

@property (nonatomic, retain) GPCamera *camera;

- (IBAction)sync:(id)sender;

- (IBAction)capture:(id)sender;
- (IBAction)setMode:(id)sender;

@end
