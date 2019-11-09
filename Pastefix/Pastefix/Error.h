//
//  Error.h
//  Pastefix
//
//  Created by Brian Naylor on 11/9/19.
//  Copyright © 2019 Brian Naylor. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef Error_h
#define Error_h

@interface Error:NSObject {
}
- (void) errorWithError:(NSError *)error logMessage:(NSString *)msg;
@end

#endif /* Error_h */
