//
//  AppDelegate.h
//  Pastefix
//
//  Created by Brian Naylor on 7/7/19.
//  Copyright © 2019 Brian Naylor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet id filterSelector;
    IBOutlet id refreshButton;
}
// global key event handler
OSStatus focusKeyHandler(EventHandlerCallRef nextHandler, EventRef event,
                         void *userData);

@end

