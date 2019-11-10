//
//  Tempfile.h
//  Pastefix
//
//  Created by Brian Naylor on 11/10/19.
//  Copyright © 2019 Brian Naylor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tempfile : NSObject {
    NSURL *fileURL;
}

- (id)   init;
- (void) create;
- (NSString *)filePath;
- (BOOL) write:(NSData *)data;
- (BOOL) writeString:(NSString *)strData;

@end

NS_ASSUME_NONNULL_END
