//
//  EventCapture.h
//  Pastefix
//
//  Created by Brian Naylor on 4/23/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface EventCapture : NSWindow {
  id owner;
}

- (id)init;

- (BOOL)acceptsFirstResponder;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (void)flagsChanged:(NSEvent *)flagEvent;
- (void)keyDown:(NSEvent *)keyEvent;
- (void)keyUp:(NSEvent *)keyEvent;
- (BOOL)performKeyEquivalent:(NSEvent *)event;
- (void)doCommandBySelector:(SEL)aSelector;

- (void)setOwner:(id)myOwner;

- (void)dealloc;

@end
