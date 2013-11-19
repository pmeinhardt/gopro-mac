//
//  GPAppDelegate.m
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/13/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "GPAppDelegate.h"

#import "GPConnectWindowController.h"

@interface GPAppDelegate ()

@property (nonatomic, retain, readonly) NSWindowController *connectWindowController;

@end

@implementation GPAppDelegate

@synthesize connectWindowController = _connectWindowController;

- (void)dealloc
{
    [self.connectWindowController release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [self.connectWindowController showWindow:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application
{
    return NO;
}

- (NSWindowController *)connectWindowController
{
    if (_connectWindowController == nil) {
        _connectWindowController = [[GPConnectWindowController alloc] initWithWindowNibName:@"ConnectWindow"];
    }
    return _connectWindowController;
}

- (IBAction)newConnection:(id)sender
{
    [self.connectWindowController showWindow:sender];
}

@end
