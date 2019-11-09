//
//  AppDelegate.m
//  Pastefix
//
//  Created by Brian Naylor on 7/7/19.
//  Copyright © 2019 Brian Naylor. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

#import "AppDelegate.h"

// tmp
#import "Interpreter.h"
#import "Scripts.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setupHotkey];
    [self setupFilterList];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

/*
 * Install the global hotkey
 */
- (void)setupHotkey
{
    // register for hotkeys
    static EventHotKeyRef gHotKeyRef = NULL;
    EventHotKeyID gHotKeyID;
    EventTypeSpec eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UInt32 modifier = 0;
    int key;

    InstallApplicationEventHandler(&focusKeyHandler, 1, &eventType, (__bridge void *) _window, NULL);
    
    gHotKeyID.signature = 'key1';
    gHotKeyID.id        = 1;

// Old hax, just hardcode it for now and revisit.
// BLN TBD
    modifier = (cmdKey + shiftKey);
    key = 0x7;  // 'x'
//    modifier += ([defaults boolForKey:PFHkUseCmdKey])  ? cmdKey     : 0;
//    modifier += ([defaults boolForKey:PFHkUseCtrlKey]) ? controlKey : 0;
//    modifier += ([defaults boolForKey:PFHkUseOptKey])  ? optionKey  : 0;
//    modifier += ([defaults boolForKey:PFHkUseShftKey]) ? shiftKey   : 0;
//    key       = ([defaults integerForKey:PFHkBaseKeycodeKey]);
    
    NSLog(@"key=%d, ref=%p", key, gHotKeyRef);
    
    if(gHotKeyRef)
    {
        UnregisterEventHotKey(gHotKeyRef);
    }
    RegisterEventHotKey(key, modifier, gHotKeyID, GetApplicationEventTarget(),
                        0, &gHotKeyRef);
}

/*
 * Populate the filter list with discovered scripts and/or builtin actions
 */
- (void) setupFilterList
{
    // BLN XXX get these from actual sources obviously
    NSArray *filterActions = [[NSArray alloc] initWithObjects:@"Wrap @ 78",
                               @"Strip Newlines", @"Strip Specials", @"Convert to Plain",
                               @"Split for IRC", @"Strip Markup", nil];
    [filterSelector removeAllItems];
    [filterSelector addItemsWithTitles:filterActions];
}

/*
 * Global hotkey handler: bring app into focus
 */
OSStatus focusKeyHandler(EventHandlerCallRef nextHandler, EventRef event,
                         void *userData)
{
    [NSApp activateIgnoringOtherApps:YES];
    return noErr;
}

/*======================================================================================================
 *
 * UI actions and whatnot
 *
 *====================================================================================================*/

/*
 * 'Refresh' button click
 */
- (IBAction)refreshFromClipboard:(id)sender
{
//    hasEdited = NO;
//    [self onFocus:self];
//    [self setStatus:@"Reverted to original contents."];
    [refreshButton setEnabled:NO];
}

/*
 * 'Apply' button click
 */
- (IBAction)applyFilter:(id)sender
{
    NSLog(@"Applying selection %@", [filterSelector titleOfSelectedItem]);
//    Scripts *python = [[Scripts alloc] init];
    Interpreter *interp = [[Interpreter alloc] init];
    int rc = [interp RunTest];
    NSLog(@"Exec returned rc=%d\n", rc);
}

/*
 * 'Save' button click
 */
- (IBAction)saveToClipboard:(id)sender
{
    NSLog(@"Save clicked");
}

@end
