//
//  BundleResourceProtocol.m
//  GoPro
//
//  Created by Paul Meinhardt on 11/24/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "BundleResourceProtocol.h"

@implementation BundleResourceProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSURL *url = request.URL;
    NSString *path = [url.resourceSpecifier substringFromIndex:2];

    if ([url.scheme isEqualToString:@"bundle"]) {
        return [path isEqualToString:@"stylesheet.css"] || [path isEqualToString:@"customize.js"];
    }

    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [a.URL.resourceSpecifier isEqualToString:b.URL.resourceSpecifier];
}

- (void)startLoading
{
    NSURLRequest * request = self.request;
    NSString *path = [request.URL.resourceSpecifier substringFromIndex:2];

    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:path withExtension:nil];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:fileURL options:0 error:&error];

    id<NSURLProtocolClient> client = self.client;

    if (data == nil) {
        [client URLProtocol:self didFailWithError:error];
        return;
    }

    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];

    [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    [client URLProtocol:self didLoadData:data];
    [client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
    // do nothing
}

@end
