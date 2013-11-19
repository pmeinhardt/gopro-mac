//
//  GPConnectWindowController.m
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/16/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "GPConnectWindowController.h"

#import "GPCameraWindowController.h"
#import "GPCamera.h"

#import "NSWindow+GPExtensions.h"

#import <dispatch/dispatch.h>

@interface GPConnectWindowController ()

- (void)waiting;
- (void)reset:(BOOL)completely;

- (void)connect:(GPCamera *)camera;
- (void)connected:(GPCamera *)camera;
- (void)unavailable:(GPCamera *)camera;

@end

@implementation GPConnectWindowController

- (void)cancelOperation:(id)sender
{
    [self.window orderOut:sender];
    [self reset:YES];
}

- (void)waiting
{
    [[self.window standardWindowButton:NSWindowCloseButton] setEnabled:NO];

    [self.button setEnabled:NO];
    [self.button setHidden:YES];

    [self.field setEnabled:NO];
    [self.field setHidden:YES];

    [self.indicator startAnimation:nil];
}

- (void)reset:(BOOL)completely
{
    [[self.window standardWindowButton:NSWindowCloseButton] setEnabled:YES];

    [self.indicator stopAnimation:nil];

    [self.button setHidden:NO];
    [self.button setEnabled:YES];

    if (completely) [self.field setStringValue:@""];

    [self.field setHidden:NO];
    [self.field setEnabled:YES];

    [self.field selectText:self];
}

- (IBAction)confirm:(id)sender
{
    NSString *password = self.field.stringValue;

    if (password.length < 8) {
        [self.window shake];
        return;
    }

    [self connect:[[GPCamera alloc] initWithPassword:password]];
}

- (void)connect:(GPCamera *)camera
{
    [self waiting];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [camera sync];
        SEL action;

        if (success) {
            action = @selector(connected:);
        } else {
            action = @selector(unavailable:);
        }

        [self performSelectorOnMainThread:action withObject:camera waitUntilDone:NO];
    });
}

- (void)connected:(GPCamera *)camera
{
    GPCameraWindowController *controller = [[GPCameraWindowController alloc] initWithWindowNibName:@"CameraWindow"];
    [controller setCamera:camera];
    [controller showWindow:self];

    [camera release];

    [self.window orderOut:nil];
    [self reset:YES];
}

- (void)unavailable:(GPCamera *)camera
{
    // TODO: notify user
    //  - check connected to GoPro Wi-Fi network
    //    - Wi-Fi enabled on camera (GoPro App mode… instructions)
    //    - network selected
    //  - retype password

    [self.window shake];
    [camera release];
    [self reset:NO];
}

@end
