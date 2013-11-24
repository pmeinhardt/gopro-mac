//
//  BrowserWindowController.m
//  GoPro
//
//  Created by Paul Meinhardt on 11/23/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "BrowserWindowController.h"

static NSString * const BrowserWindowNavigationBarItemIdentifier = @"BrowserWindowNavigationBarItemIdentifier";
static CGFloat const BrowserWindowBottomBarHeight = 25.0;

@implementation BrowserWindowController

- (void)dealloc
{
    [self.baseURL release];
    [super dealloc];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    // Set the bottom window content border thickness, so controls
    // at the window bottom are rendered with a native background gradient.
    [self.window setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
	[self.window setContentBorderThickness:BrowserWindowBottomBarHeight forEdge:NSMinYEdge];

    // Insert an address bar into the toolbar at the top of the window.
    [self.toolbar insertItemWithItemIdentifier:BrowserWindowNavigationBarItemIdentifier atIndex:0];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your
    // window controller's window has been loaded from its nib file.
    [self.webView setMainFrameURL:[self.baseURL absoluteString]];
}

#pragma mark - NSToolbarDelegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    if (itemIdentifier == BrowserWindowNavigationBarItemIdentifier) {
        // Configure the toolbar item containing the navigation bar.
        NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
        item.view = self.navbar;
        item.minSize = NSMakeSize(280.0, 32.0);
        item.maxSize = NSMakeSize(CGFLOAT_MAX, 32.0);
        return item;
    }

    return nil;
}

#pragma mark - WebFrameLoadDelegate

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if (frame == self.webView.mainFrame) {
        self.loading = YES;
    }
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    if (frame == self.webView.mainFrame) {
        self.loading = NO;
    }
}

#pragma mark - Actions

- (IBAction)goForward:(id)sender
{
    [self.webView goForward:sender];
}

- (IBAction)goBack:(id)sender
{
    [self.webView goBack:sender];
}

- (IBAction)reload:(id)sender
{
    [self.webView reload:sender];
}

@end
