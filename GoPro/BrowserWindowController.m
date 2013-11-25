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
        NSRect frame = self.navbar.frame;

        item.view = self.navbar;
        item.minSize = NSMakeSize(frame.size.width, frame.size.height);
        item.maxSize = NSMakeSize(CGFLOAT_MAX, frame.size.height);

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

        if ([sender.mainFrameURL hasPrefix:[self.baseURL absoluteString]]) {
            // Inject our custom stylesheet into the DOM.
            DOMDocument *document = frame.DOMDocument;

            // Inject the stylesheet by evaluating a script.
            //
            // We're using the "bundle://" URL scheme here to allow embedding
            // of local resources ("file://...") in the context of another
            // domain ("http://10.5.5.9"). Loading of local requests would
            // normally be blocked to prevent leaking of local information
            // to different domains.
            //
            // However, we trust our own camera (and protocol implementation)
            // and bypass this restriction.
            NSString *script = @"(function() {"
                "if (window.customized) return;"
                "window.customized = true;"
                ""
                "var head = document.getElementsByTagName('head')[0];"
                ""
                "var link = document.createElement('link');"
                "link.setAttribute('rel', 'stylesheet');"
                "link.setAttribute('href', 'bundle://stylesheet.css');"
                "head.appendChild(link);"
                ""
                "var script = document.createElement('script');"
                "script.src = 'bundle://customize.js';"
                "head.appendChild(script);"
                "})();";

            [document evaluateWebScript:script];
        }
    }
}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    if (frame == self.webView.mainFrame) {
        self.loading = NO;
    }
}

#pragma mark - WebPolicyDelegate

- (void)webView:(WebView *)webView decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
    if ([type hasPrefix:@"video/"]) {
        [listener download];
    } else {
        [listener use];
    }
}

#pragma mark - NSURLDownloadDelegate

- (BOOL)download:(NSURLDownload *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
    NSLog(@"Downloading to: %@", filename);
}

- (void)download:(NSURLDownload *)download didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Download cancelled authentication challenge");
}

- (void)downloadDidBegin:(NSURLDownload *)download
{
    NSLog(@"Download did begin: %@", download);
}

- (void)download:(NSURLDownload *)download didCreateDestination:(NSString *)path
{
    NSLog(@"Download created destination: %@", path);
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
    NSLog(@"Download failed with error: %@", error);
}

- (void)downloadDidFinish:(NSURLDownload *)download
{
    NSLog(@"Download did finish: %@", download);
}

- (void)download:(NSURLDownload *)download didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Download did receive authentication challenge: %@", challenge);
}

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
    NSLog(@"Downloaded %ld bytes", length);
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Download did receive response: %@", response);
}

- (BOOL)download:(NSURLDownload *)download shouldDecodeSourceDataOfMIMEType:(NSString *)encodingType
{
    return NO;
}

- (void)download:(NSURLDownload *)download willResumeWithResponse:(NSURLResponse *)response fromByte:(long long)startingByte
{
    NSLog(@"Download will resume from byte %lld", startingByte);
}

- (NSURLRequest *)download:(NSURLDownload *)download willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    NSLog(@"Download will send request after redirect: %@", redirectResponse);
    return request;
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
