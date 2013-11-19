//
//  GPConnectWindowController.h
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/16/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ConnectWindowController : NSWindowController

@property (nonatomic, assign) IBOutlet NSProgressIndicator *indicator;
@property (nonatomic, assign) IBOutlet NSTextField *field;
@property (nonatomic, assign) IBOutlet NSButton *button;

- (IBAction)confirm:(id)sender;

@end
