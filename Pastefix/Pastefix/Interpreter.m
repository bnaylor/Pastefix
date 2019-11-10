//
//  Interpreter.m
//  Pastefix
//
//  Created by Brian Naylor on 11/9/19.
//  Copyright © 2019 Brian Naylor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Interpreter.h"
#import "Error.h"
#import "Tempfile.h"

#define PERL      "/usr/bin/perl"
#define PERL_ARGS "-ln"

#define PERL_MAIN                          \
"                                        \n\
use strict;                              \n\
use warnings;                            \n\
                                         \n\
sub process_buffer($);                   \n\
                                         \n\
my $buffer = '';                         \n\
                                         \n\
while(<STDIN>) {                         \n\
    $buffer .= $_;                       \n\
}                                        \n\
                                         \n\
my $filtered = process_buffer($buffer);  \n\
print STDOUT $filtered;                  \n\
close(STDOUT);                           \n\
                                         \n\
exit 0;                                  \n\
"

#define PERL_USER                          \
"                                        \n\
sub process_buffer($) {                  \n\
    my($buffer) = @_;                    \n\
    $buffer =~ s/hello/world/gm;         \n\
    return $buffer;                      \n\
}                                        \n\
"

#define PERL_TEST_DATA     \
"                        \n\
hey there                \n\
buddy                    \n\
hello                    \n\
expo                     \n\
"


@implementation Interpreter

- (id)init
{
  if(self = [super init]) {
  }
  return self;
}



- (BOOL) RunTest {
    NSPipe *interpreterStdin = [NSPipe pipe];
    NSPipe *interpreterStdout = [NSPipe pipe];
    NSFileHandle *istdin = interpreterStdin.fileHandleForWriting;
    NSFileHandle *istdout = interpreterStdout.fileHandleForReading;

    Tempfile *script = [[Tempfile alloc] init];
    NSString *code = [NSString stringWithCString:PERL_MAIN PERL_USER encoding:NSUTF8StringEncoding];
    if (! [script writeString:code]) {
        NSLog(@"Couldn't write temporary file");
        return FALSE;
    }

    NSLog(@"Wrote script to %@\n", [script filePath]);

    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @PERL;
    task.arguments = @[@PERL_ARGS, [script filePath]];
    task.standardInput = interpreterStdin;
    task.standardOutput = interpreterStdout;

    NSError *error = nil;
    if (! [task launchAndReturnError:&error]) {
        Error *e;
        [e errorWithError:error logMessage:@"Couldn't execute interpreter."];
    }
    
    NSString *buffer = [NSString stringWithCString:PERL_TEST_DATA encoding:NSUTF8StringEncoding];
    NSData *bufdata = [buffer dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Writing text: %@\n", buffer);
    [istdin writeData:bufdata];
    [istdin closeFile];
    
    NSData *data = [istdout readDataToEndOfFile];
    [istdout closeFile];

    NSString *output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"perl returned text:\n%@", output);
    return TRUE;
}

@end
