//
//  GPAppDelegate.m
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/13/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "AppDelegate.h"

#import "ConnectWindowController.h"

@interface AppDelegate ()

@property (nonatomic, retain, readonly) NSWindowController *connectWindowController;

@end

@implementation AppDelegate

@synthesize connectWindowController = _connectWindowController;

- (void)dealloc
{
    [self.connectWindowController release];
    [super dealloc];
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    NSStatusItem *item = [bar statusItemWithLength:NSVariableStatusItemLength];

#ifdef SPARKLE
    // [self.checkForUpdatesMenuItem setEnabled:YES];
    // [self.checkForUpdatesMenuItem setHidden:NO];
#endif

    [item setHighlightMode:YES];
    [item setMenu:self.menu];

    [item setImage:[NSImage imageNamed:@"status-off"]];
    [item setAlternateImage:[NSImage imageNamed:@"status-on"]];

    self.item = item;

    [self newConnection:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application
{
    return NO;
}

#pragma mark -

- (NSWindowController *)connectWindowController
{
    if (_connectWindowController == nil) {
        _connectWindowController = [[ConnectWindowController alloc] initWithWindowNibName:@"ConnectWindow"];
    }
    return _connectWindowController;
}

#pragma mark - IBAction

- (IBAction)openAbout:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:nil];
}

- (IBAction)openDocumentation:(id)sender
{
    NSURL *url = [NSURL URLWithString:kGoProAppWebsiteURLString];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)newConnection:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    [self.connectWindowController showWindow:sender];
}

- (IBAction)checkForUpdates:(id)sender
{
#ifdef SPARKLE
    [[SUUpdater sharedUpdater] setSendsSystemProfile:YES];
    [[SUUpdater sharedUpdater] checkForUpdates:sender];
#endif
}

@end
