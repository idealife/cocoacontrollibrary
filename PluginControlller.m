//
//  PluginControlller.m
//  AiOControlIBPlugin
//
//  Created by Edward.Chen on 11/12/09.
//  Copyright 2009 yoyokko. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//		Redistributions of source code must retain the above copyright notice, this
//	list of conditions and the following disclaimer.
//
//		Redistributions in binary form must reproduce the above copyright notice,
//	this list of conditions and the following disclaimer in the documentation and/or
//	other materials provided with the distribution.
//
//		Neither the name of the BinaryMethod.com nor the names of its contributors
//	may be used to endorse or promote products derived from this software without
//	specific prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS AS IS AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//	IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//	INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
//	OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//	POSSIBILITY OF SUCH DAMAGE.

#import "PluginControlller.h"
#import <AiOControlIBPlugin/KAWindowStyle.h>

@class KAWindow, KAPanel, IBEditableWindow, IBWindowView, KACustomView;
@class NSWindowTemplate;

@implementation PluginControlller

- (void)awakeFromNib
{
	[KAWindow poseAsClass:[NSWindow class]];
	
	NSWindow *darkWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(196, 240, 480, 270) styleMask:(NSTitledWindowMask | NSClosableWindowMask | kaWindowStyle)  backing:NSBackingStoreBuffered defer:YES];
	[darkWindow setTitle:@""];
	
	IBWindowView *ibWindow = [IBWindowView new];
	[ibWindow setWindowToMimic:darkWindow];
	[ibWindow sizeToFit];
	
	[windowIBTemplate setDraggedView:ibWindow];
    
	NSWindowTemplate *windowTemplate = [[NSWindowTemplate alloc] init];
	[windowTemplate setValue:[[[KACustomView alloc] initWithFrame:NSMakeRect(196, 240, 480, 270)] autorelease] forKeyPath:@"windowView"];
	[windowTemplate setValue:@"KACustomView" forKeyPath:@"viewClass"];
	[windowTemplate setValue:@"KAWindow" forKeyPath:@"windowClass"];
	[windowTemplate setTitle:@""];
	[windowTemplate setStyleMask:[darkWindow styleMask] | kaWindowStyle];
	[windowTemplate setContentRect:NSMakeRect(196, 240, 480, 270)];
	[windowTemplate setVisibleAtLaunch:YES];
	[windowTemplate setBackingType:NSBackingStoreBuffered];
	[windowTemplate setDeferred:YES];
	[windowIBTemplate setRepresentedObject:windowTemplate];	
}

@end
