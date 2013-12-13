//
//  AboutWindowWindowController.m
//  MongoApp
//
//  Created by Daniel Parnell on 25/11/2013.
//  Copyright (c) 2013 Daniel Parnell. All rights reserved.
//

#import "AboutWindowWindowController.h"

@interface AboutWindowWindowController ()

@end

@implementation AboutWindowWindowController

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
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    NSString* html = [NSString stringWithContentsOfURL:
                                              [[NSBundle mainBundle] URLForResource: @"about" withExtension: @"html"]
                                              encoding: NSUTF8StringEncoding error: nil];
    
    html = [html stringByReplacingOccurrencesOfString: @"$VERSION$" withString: currentVersion];
    
    [[_web_view mainFrame] loadHTMLString: html baseURL: nil];
}

@end
