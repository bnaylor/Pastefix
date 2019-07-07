//
//  PrefsController.h
//  Pastefix
//
//  Created by Brian L. Naylor on 4/22/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


NSString *PFAutoHideKey          = @"autoHide";
NSString *PFUseIconvKey          = @"useIconv";
NSString *PFCheckForUpdatesKey   = @"checkForUpdates";
NSString *PFMaxLineLengthKey     = @"maxLineLength";
NSString *PFIgnoreThisVersionKey = @"ignoreThisVersion";
NSString *PFHkUseCmdKey          = @"hkUseCmd";
NSString *PFHkUseCtrlKey         = @"hkUseCtrl";
NSString *PFHkUseOptKey          = @"hkUseOpt";
NSString *PFHkUseShftKey         = @"hkUseShft";
NSString *PFHkBaseKeyKey         = @"hkBaseKey";
NSString *PFHkBaseKeycodeKey     = @"hkBaseKeycode";


// It would be nice to get this working, but for now I am punting
@class EventCapture;

@interface PrefsController : NSWindowController {
  id                  owner;
  id                  panelWindow;
  IBOutlet BOOL       autoHide;
  IBOutlet BOOL       checkForUpdates;
  IBOutlet BOOL       useIconv;
  id                  okButton;
  id                  autoHideButton;
  id                  useIconvButton;
  id                  checkForUpdatesButton;
  id                  maxLineLengthField;
//  id                  captureHotkeyButton;
  id                  hotkeyLabel;
  EventCapture       *capture;
  IBOutlet BOOL       hkUseCmd;
  IBOutlet BOOL       hkUseCtrl;
  IBOutlet BOOL       hkUseOpt;
  IBOutlet BOOL       hkUseShft;
  id                  hkUseCmdButton;
  id                  hkUseCtrlButton;
  id                  hkUseOptButton;
  id                  hkUseShftButton;
  id                  hkBaseKeyCaptureButton;
}

- (id)init;
- (void)windowDidLoad;
- (IBAction)changeAutoHide:(id)sender;
- (IBAction)changeCheckForUpdates:(id)sender;
- (IBAction)changeUseIconv:(id)sender;
// this gets called when you change focus
- (IBAction)changeMaxLineLength:(id)sender;
// this gets called by the 'ok' button at the end, in case you didn't change focus.
- (void)updateMaxLineLength:(NSString *)val;
- (IBAction)captureHotkeyPressed:(id)sender;
- (void)captureFinished:(int)keyCode key:(char)key;
- (IBAction)okPressed:(id)sender;

- (IBAction)changeHkUseCmd:(id)sender;
- (IBAction)changeHkUseCtrl:(id)sender;
- (IBAction)changeHkUseOpt:(id)sender;
- (IBAction)changeHkUseShft:(id)sender;
- (void)changeHkBaseKey:(int)keyCode key:(char)key;

- (void)setOwner:(id)myOwner;

@end
