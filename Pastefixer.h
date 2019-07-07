//
//  Pastefixer.h
//  Pastefix
//
//  Created by Brian L. Naylor on 4/20/07.
//  Copyright 2007 scromp. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "Preferences.h"

@class TextProc;
@class PrefsController;

@interface Pastefixer : NSObject
{
  IBOutlet id      mainText;
  IBOutlet id      revertButton;
  IBOutlet id      splitButton;
  IBOutlet id      saveButton;
  IBOutlet id      statusLine;
  IBOutlet id      mainWin;
  id               pb;
  TextProc        *textproc;
  PrefsController *prefs;
  BOOL             hasEdited;
}

+ (void)initialize;
- (id)init;
- (void)awakeFromNib;

// button actions
- (IBAction)save:(id)sender;
- (IBAction)split:(id)sender;
- (IBAction)revert:(id)sender;

// call this when we get focus
- (IBAction)onFocus:(id)sender;

// check line lengths and update ui elements
- (BOOL)checkLines:(NSString *)buffer;

// update the status area
- (void)setStatus:(NSString *)message;

// verify that the pasteboard has data we can use
- (BOOL)pasteboardHasString;

// posted when we gain focus
- (void)windowDidBecomeMain:(NSNotification *)aNotification;

// posted when the user edits the text
- (void)textDidBeginEditing:(NSNotification *)aNotification;
- (void)textDidChange:(NSNotification *)aNotification;
- (void)textDidEndEditing:(NSNotification *)aNotification;

// bring up the prefs window
- (IBAction)showPrefsWindow:(id)sender;
- (void)prefsFinished;
- (id)pref:(NSString *)key;

// convenience - grab prefs for use - know what you're asking for.
- (id)pref:(NSString *)key;

- (void)setupHotkey;

- (void)dealloc;


// global key event handler
OSStatus focusKeyHandler(EventHandlerCallRef nextHandler, EventRef event,
                           void *userData);


@end

