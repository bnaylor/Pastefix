//
//  Tempfile.m
//  Pastefix
//
//  Created by Brian Naylor on 11/10/19.
//  Copyright © 2019 Brian Naylor. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "Error.h"
#import "Tempfile.h"


@implementation Tempfile

- (id) init {
    if(self = [super init]) {
        fileURL = NULL;
        [self create];
    }
    return self;
}

- (void) create {
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath: NSTemporaryDirectory() isDirectory: YES];
    NSString *filename = [[NSUUID UUID] UUIDString];
    fileURL = [temporaryDirectoryURL URLByAppendingPathComponent:filename];
}

- (NSString *) filePath {
    char fbuf[PATH_MAX];
    
    if (fileURL != NULL) {
        [fileURL getFileSystemRepresentation:fbuf maxLength:PATH_MAX-1];
        return [NSString stringWithCString:fbuf encoding:NSUTF8StringEncoding];
    }
    return NULL;
}

- (BOOL) write:(NSData *)data {
    // Coding error
    if (fileURL == NULL) {
        NSLog(@"Tempfile write called unintialized.");
        return FALSE;
    }
    
    NSError *error = nil;
    if (! [data writeToURL:fileURL options:NSDataWritingAtomic error:&error]) {
        Error *e;
        [e errorWithError:error logMessage:@"Couldn't write temporary file"];
        NSLog(@"honk");
        return FALSE;
    }
    NSLog(@"tmp write ok");
    return TRUE;
}

- (BOOL) writeString:(NSString *)strData {
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    return [self write:data];
}

@end
