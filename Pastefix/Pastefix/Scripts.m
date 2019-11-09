//
//  Scripts.m
//  Pastefix
//
//  Created by Brian Naylor on 7/7/19.
//  Copyright © 2019 Brian Naylor. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "Scripts.h"


// This is an interesting suggestion, let's try it.
// Nope.  Just saving for syntax refresher now
//@interface NSString (WcharEncodedString)
//
//- (wchar_t*) getWideString;
//
//@end
//
//@implementation NSString (WcharEncodedString)
//
//- (wchar_t*) getWideString {
//    const char* tmp = [self cStringUsingEncoding:NSUTF8StringEncoding];
//    unsigned long buflen = strlen(tmp) + 1;
//    wchar_t* buffer = malloc(buflen * sizeof(wchar_t));
//    mbstowcs(buffer, tmp, buflen);
//    return buffer;
//}
//
//@end

@interface Scripts ()
@end

@implementation Scripts

-(id)init {
        
    // import sys
    //PyObject *sys = PyImport_Import(PyString_FromString("sys"));
  
    // sys.path.append(resourcePath)
        
    return [super init];
}


@end

