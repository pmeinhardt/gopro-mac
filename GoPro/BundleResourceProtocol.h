//
//  BundleResourceProtocol.h
//  GoPro
//
//  Created by Paul Meinhardt on 11/24/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

// WebViews loading content from non-local domains (e.g. 10.5.5.9)
// are usually not allowed to embed local content, for security reasons.
// The BundleResourceProtocol allows for loading certain local resources
// from the bundle, to allow injection of local content.
@interface BundleResourceProtocol : NSURLProtocol
@end
