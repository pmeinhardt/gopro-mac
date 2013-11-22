//
//  ConnectWindowController.m
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/16/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "ConnectWindowController.h"

#import "CameraWindowController.h"
#import "GoProCamera.h"

#import "NSWindow+GPExtensions.h"

#import <dispatch/dispatch.h>

@interface ConnectWindowController ()

- (void)preventClose;
- (void)allowClose;

- (void)requesting;
- (void)reset:(BOOL)completely;

- (void)connect:(GoProCamera *)camera;
- (void)connected:(GoProCamera *)camera;
- (void)unavailable:(GoProCamera *)camera;

@end

@implementation ConnectWindowController

#pragma mark - NSResponder

- (void)cancelOperation:(id)sender
{
    [self.window orderOut:sender];
    [self reset:YES];
}

#pragma mark - Window state

- (void)preventClose
{
    [self.window standardWindowButton:NSWindowCloseButton].enabled = NO;
}

- (void)allowClose
{
    [self.window standardWindowButton:NSWindowCloseButton].enabled = YES;
}

- (void)requesting
{
    [self preventClose];
    self.loading = YES;
}

- (void)reset:(BOOL)completely
{
    self.loading = NO;

    [self allowClose];

    if (completely) {
        [self.field setStringValue:@""];
    }

    [self.field selectText:self];
}

#pragma mark - IBAction

- (IBAction)confirm:(id)sender
{
    NSString *password = self.field.stringValue;

    if (password.length < 8) {
        [self.window shake];
        return;
    }

    [self connect:[[GoProCamera alloc] initWithPassword:password]];
}

#pragma mark - Connection handling

- (void)connect:(GoProCamera *)camera
{
    [self requesting];

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

- (void)connected:(GoProCamera *)camera
{
    CameraWindowController *controller = [[CameraWindowController alloc] initWithWindowNibName:@"CameraWindow"];
    [controller setCamera:camera];
    [controller showWindow:self];

    [camera release];

    [self.window orderOut:self];
    [self reset:YES];
}

- (void)unavailable:(GoProCamera *)camera
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
