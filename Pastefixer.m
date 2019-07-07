//
//  Pastefixer.m
//  Pastefix
//
//  Created by Brian L. Naylor on 4/20/07.
//  Copyright 2007 scromp. All rights reserved.
//

#import "Pastefixer.h"
#import "TextProc.h"

// The vagaries of IRC demand that we guess here.
// Users will have to adjust if they deviate from the "averages" (which
// are in fact total guesses on my part rather than averages, don't tell anyone)
#define AVG_IRC_LINE_MAX      510
#define AVG_NICK_LEN           10
#define AVG_HOST_LEN           40
#define PROTO_OVERHEAD         10
#define DEFAULT_MAX_LINE_LENGTH \
  (AVG_IRC_LINE_MAX - ((AVG_NICK_LEN*2) + AVG_HOST_LEN + PROTO_OVERHEAD))

#define PF_VERSION            0.9
NSString *PFVersionCheckURL = @"http://scromp.net/Pastefix/current_version";

@implementation Pastefixer

+ (void)initialize
{
  NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
  [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:PFAutoHideKey];
  [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:PFCheckForUpdatesKey];
  [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:PFUseIconvKey];
  [defaultValues setObject:[NSNumber numberWithInt:DEFAULT_MAX_LINE_LENGTH] forKey:PFMaxLineLengthKey];
  [defaultValues setObject:[NSString stringWithString:@"0.0"] forKey:PFIgnoreThisVersionKey];
  [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:PFHkUseCmdKey];
  [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:PFHkUseCtrlKey];
  [defaultValues setObject:[NSNumber numberWithBool:NO] forKey:PFHkUseOptKey];
  [defaultValues setObject:[NSNumber numberWithBool:NO] forKey:PFHkUseShftKey];
  [defaultValues setObject:[NSNumber numberWithInt:8] forKey:PFHkBaseKeycodeKey];
  [defaultValues setObject:[NSString stringWithFormat:@"%c", 'c'] forKey:PFHkBaseKeyKey];
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (id)init
{
  if(self = [super init])
  {
    textproc = [[TextProc alloc] init];
    pb = [NSPasteboard generalPasteboard];
  }
  return self;
}

- (void)awakeFromNib
{
  [self setupHotkey];
}

- (IBAction)save:(id)sender
{
  // save to pasteboard
  NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
  [pb declareTypes:types owner:self];
  [pb setString:[mainText string] forType:NSStringPboardType];
  [saveButton setEnabled:NO];
  [revertButton setEnabled:NO];
  [self setStatus:@"Copied."];
  hasEdited = NO;
}

- (IBAction)split:(id)sender
{
  [[[mainText textStorage] mutableString] setString:[textproc 
      splitLines:[mainText string] maxLength:[[self pref:PFMaxLineLengthKey] intValue]]];
  [splitButton setEnabled:NO];
  [revertButton setEnabled:YES];
  [self setStatus:@""];
  hasEdited = YES;
}

- (IBAction)revert:(id)sender
{
  hasEdited = NO;
  [self onFocus:self];
  [self setStatus:@"Reverted to original contents."];  
  [revertButton setEnabled:NO];
}

- (void)onFocus:(id)sender
{
  // check this here each time in case they change our prefs
  [mainWin setHidesOnDeactivate:[[self pref:PFAutoHideKey] boolValue]];
  
  if(hasEdited)
  {
    return;
  }
  
  if(![self pasteboardHasString]) 
  {
    [self setStatus:@"Clipboard has no usable data."];
  }
  else
  {
    NSString *tmp = [pb stringForType:NSStringPboardType];
    [self setStatus:[NSString stringWithFormat:@"Copied %d characters from clipboard.", 
      [tmp length]]];
    if(tmp)
    {
      tmp = [textproc convertUTF8ToASCII:tmp];
      [[[mainText textStorage] mutableString] setString:tmp];
      [self checkLines:tmp];
      [saveButton setEnabled:YES];
    }
  }
}

- (BOOL)checkLines:(NSString *)buffer
{
  int max = [[self pref:PFMaxLineLengthKey] intValue];
  if([textproc shouldSplitLines:buffer maxLength:max])
  {
    [self setStatus:
      [NSString stringWithFormat:@"Some lines exceed maximum length of %d characters.  'split' recommended.", 
        max]];
    [splitButton setEnabled:YES];
    return YES;
  }
  [self setStatus:@""];
  [splitButton setEnabled:NO];
  return NO;
}

- (void)setStatus:(NSString *)message
{
  [statusLine setStringValue:message];
}

- (BOOL)pasteboardHasString 
{
  NSArray *types = [NSArray arrayWithObject:NSStringPboardType];
  NSString *bestType = [pb availableTypeFromArray:types];
  return (bestType != nil);
}

- (void)windowDidBecomeMain:(NSNotification *)aNotification
{
  [self onFocus:aNotification];
}

- (void)textDidBeginEditing:(NSNotification *)aNotification
{
  [revertButton setEnabled:YES];
  [self checkLines:[mainText string]];
  hasEdited = YES;  // this prevents us from recopying the clipboard automatically.
}

- (void)textDidChange:(NSNotification *)aNotification
{
  // have to do the revert button here too, if you 'revert' once,
  // you still never get the beginEditing notification again.
  [revertButton setEnabled:YES];
  [self checkLines:[mainText string]];
  hasEdited = YES;  // this prevents us from recopying the clipboard automatically.
}

- (void)textDidEndEditing:(NSNotification *)aNotification
{
  NSLog(@"end editing - curious if anyone ever sees this.");
}

- (IBAction)showPrefsWindow:(id)sender
{
  if(!prefs)
  {
    prefs = [[PrefsController alloc] init];
	[prefs setOwner:self];
  }
  [prefs showWindow:self];
}

- (void)prefsFinished
{
  NSLog(@"prefsFinished");
  [self setupHotkey];
}

- (id)pref:(NSString *)key
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setupHotkey
{
  // register for hotkeys
  static EventHotKeyRef gHotKeyRef = NULL;
  EventHotKeyID gHotKeyID;
  EventTypeSpec eventType;
  eventType.eventClass=kEventClassKeyboard;
  eventType.eventKind=kEventHotKeyPressed;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  UInt32 modifier = 0;
  int key;

  InstallApplicationEventHandler(&focusKeyHandler,1,&eventType,mainWin,NULL);
  
  gHotKeyID.signature = 'key1';
  gHotKeyID.id        = 1;
  
  modifier += ([defaults boolForKey:PFHkUseCmdKey])  ? cmdKey     : 0;
  modifier += ([defaults boolForKey:PFHkUseCtrlKey]) ? controlKey : 0;
  modifier += ([defaults boolForKey:PFHkUseOptKey])  ? optionKey  : 0;
  modifier += ([defaults boolForKey:PFHkUseShftKey]) ? shiftKey   : 0;
  key       = ([defaults integerForKey:PFHkBaseKeycodeKey]);
  
  NSLog(@"key=%d, ref=%d", key, gHotKeyRef);
  
  if(gHotKeyRef)
  {
    UnregisterEventHotKey(gHotKeyRef);  
  }
  RegisterEventHotKey(key, modifier, gHotKeyID, GetApplicationEventTarget(), 
                      0, &gHotKeyRef);
}

- (void)dealloc
{
  [textproc release];
  if(prefs) { [prefs release]; }
  [super dealloc];
}

OSStatus focusKeyHandler(EventHandlerCallRef nextHandler, EventRef event,
                         void *userData)
{
  [NSApp activateIgnoringOtherApps:YES];
  return noErr;
}



@end
