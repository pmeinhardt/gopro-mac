//
//  BrowserWindowController.m
//  GoPro-Mac
//
//  Created by Paul Meinhardt on 11/23/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "BrowserWindowController.h"

@interface BrowserWindowController ()

@end

@implementation BrowserWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self.webview setMainFrameURL:@"https://www.google.com/"];
}

@end
