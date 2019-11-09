//
//  Error.m
//  Pastefix
//
//  Created by Brian Naylor on 11/9/19.
//  Copyright © 2019 Brian Naylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "Error.h"

@implementation Error

- (void) errorWithError:(NSError *)error logMessage:(NSString *)msg {
    NSLog(@"%@\n", msg);
    NSAlert *alert = [NSAlert alertWithError:error];
    [alert runModal];
}

@end

