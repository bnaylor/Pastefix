//
//  PrefsController.m
//  Pastefix
//
//  Created by Brian L. Naylor on 4/22/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "PrefsController.h"
#import "EventCapture.h"

@implementation PrefsController

- (id)init
{
  self = [super initWithWindowNibName:@"Preferences"];
  capture = [[EventCapture alloc] init];
  [capture setOwner:self];
  return self;
}

- (void)windowDidLoad
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [autoHideButton        setState:[defaults boolForKey:PFAutoHideKey]];
  [useIconvButton        setState:[defaults boolForKey:PFUseIconvKey]];
  [checkForUpdatesButton setState:[defaults boolForKey:PFCheckForUpdatesKey]];
  [maxLineLengthField    setStringValue:[defaults objectForKey:PFMaxLineLengthKey]];
  [hkUseCmdButton        setState:[defaults boolForKey:PFHkUseCmdKey]];
  [hkUseCtrlButton       setState:[defaults boolForKey:PFHkUseCtrlKey]];
  [hkUseOptButton        setState:[defaults boolForKey:PFHkUseOptKey]];
  [hkUseShftButton       setState:[defaults boolForKey:PFHkUseShftKey]];
  [hotkeyLabel           setStringValue:[defaults objectForKey:PFHkBaseKeyKey]];
}

- (IBAction)changeAutoHide:(id)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:PFAutoHideKey];
}

- (IBAction)changeCheckForUpdates:(id)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:PFCheckForUpdatesKey];
}

- (IBAction)changeUseIconv:(id)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:PFUseIconvKey];
}

- (IBAction)changeMaxLineLength:(id)sender
{
  [self updateMaxLineLength:[sender stringValue]];
}

- (void)updateMaxLineLength:(NSString *)val
{
  if([val intValue] == 0)
  {
    NSLog(@"Invalid max line length entered; ignoring.");
  }
  else
  {
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:PFMaxLineLengthKey];
  }
}

- (IBAction)captureHotkeyPressed:(id)sender
{
  [panelWindow makeFirstResponder:capture];
  [sender setEnabled:NO];
}

- (void)captureFinished:(int)keyCode key:(char)key
{
  NSLog(@"Capture finished.");
  [hkBaseKeyCaptureButton setEnabled:YES];
  [panelWindow makeFirstResponder:hkBaseKeyCaptureButton];
  [hotkeyLabel setStringValue:[NSString stringWithFormat:@"%c", key]];
  [self changeHkBaseKey:keyCode key:key];
}

- (IBAction)okPressed:(id)sender
{
  if(![[maxLineLengthField stringValue] isEqualToString:
		[[NSUserDefaults standardUserDefaults] stringForKey:PFMaxLineLengthKey]])
  {
	[self updateMaxLineLength:[maxLineLengthField stringValue]];
  }
    
  [self close];
  
  if(owner)
  {
    [owner prefsFinished];
  }
}

- (IBAction)changeHkUseCmd:(id)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:PFHkUseCmdKey];
}

- (IBAction)changeHkUseCtrl:(id)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:PFHkUseCtrlKey];
}

- (IBAction)changeHkUseOpt:(id)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:PFHkUseOptKey];
}

- (IBAction)changeHkUseShft:(id)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:PFHkUseShftKey];
}  
 
- (void)changeHkBaseKey:(int)keyCode key:(char)key
{
  NSLog(@"keycode=%d, key=%c", keyCode, key);
  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:keyCode] forKey:PFHkBaseKeycodeKey];
  [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%c", key] forKey:PFHkBaseKeyKey];  
}  
    
//- (IBAction)changeHkBaseKey:(id)sender
//{
//  [self updateHkBaseKey:[sender stringValue]];
//}

//- (void)updateHkBaseKey:(NSString *)key
//{
//  if([key length] > 0)
//  {
//    char chr[2];
//	chr[0] = [key characterAtIndex:0];
//	chr[1] = 0;
//    NSString *basekey = [NSString stringWithCString:chr encoding:NSASCIIStringEncoding];
//    [[NSUserDefaults standardUserDefaults] setObject:basekey forKey:PFHkBaseKeyKey];
//  }
//}

- (void)setOwner:(id)myOwner
{
  owner = myOwner;
}

@end
