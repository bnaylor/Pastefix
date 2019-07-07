//
//  EventCapture.m
//  Pastefix
//
//  Created by Brian Naylor on 4/23/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "EventCapture.h"


@implementation EventCapture

- (id)init
{
  self = [super init];
  return self;
}

- (void)flagsChanged:(NSEvent *)flagEvent
{
  NSLog(@"flagsChanged.");
}

- (void)keyDown:(NSEvent *)keyEvent
{
  unichar key = [[keyEvent charactersIgnoringModifiers] characterAtIndex:0];
//  unichar key = [[keyEvent characters] characterAtIndex:0];
//  BOOL cmd, ctrl, opt, shft = NO;
  
//  cmd  = [keyEvent modifierFlags] & NSCommandKeyMask;
//  ctrl = [keyEvent modifierFlags] & NSControlKeyMask;
//  opt  = [keyEvent modifierFlags] & NSAlternateKeyMask;
//  shft = [keyEvent modifierFlags] & NSShiftKeyMask;
  
//  NSLog(@"key=%c, cmd=%d, ctrl=%d, opt=%d, shft=%d", key, cmd, ctrl, opt, shft);
  
  // will want to pass this along to a formatter type guy who then sends the
  // pretty string to the window to be displayed.
  // no commands need be processed.

  NSLog(@"event captured, %d", [keyEvent keyCode]);

  if(owner)
  {
    [owner captureFinished:[keyEvent keyCode] key:key];
  }

//  NSArray *arr = [NSArray arrayWithObject:keyEvent];
//  [self interpretKeyEvents:arr];
}

- (void)keyUp:(NSEvent *)keyEvent
{
  NSLog(@"key up");
}

- (BOOL)performKeyEquivalent:(NSEvent *)event
{
  NSLog(@"performKeyEquivalent");
  return YES;
}

- (void)doCommandBySelector:(SEL)aSelector
{
  NSLog(@"doCommandBySelector?");
//  NSLog(@"lol: %@", aSelector);
}

- (BOOL)acceptsFirstResponder
{
  NSLog(@"accepts");
  return YES;
}

- (BOOL)becomeFirstResponder
{
  NSLog(@"become");
  return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
  NSLog(@"resign");
  return [super resignFirstResponder];
}

- (void)setOwner:(id)myOwner
{
  owner = myOwner;
}

- (void)dealloc
{
  [super dealloc];
}

@end
