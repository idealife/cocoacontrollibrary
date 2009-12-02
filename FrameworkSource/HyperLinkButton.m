// HyperLinkButton.m
// AiOControlIBPlugin
//
//  Created by Edward.Chen on 11/11/09.
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

#import "HyperLinkButton.h"
@class KAButtonCell;

@implementation HyperLinkButton


/****************************** awakeFromNib *************************
 Initialize the GUI of button
 *********************************************************************/
- (void) initialize
{
	[self setBordered: NO];
	[self setBezelStyle: NSRegularSquareBezelStyle];
	[self setButtonType: NSMomentaryChangeButton];
	
	//Get localization information
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	//Get preferred lanuage
	NSArray* languagesList = [defaults objectForKey: @"AppleLanguages"];
	[self setLanguageCodeString: [languagesList objectAtIndex: 0]];
	
	//Get preferred region
	NSString* localeInfoString = [defaults objectForKey: @"AppleLocale"];
	NSArray* localeInfoArray = [localeInfoString componentsSeparatedByString: @"_"];
	[self setRegionString: [localeInfoArray objectAtIndex: 1]];
	[self updateButtonTitle];
	
	[self setTarget: self];
	[self setAction: @selector(openURL:)];
}

- (void) updateButtonTitle
{
	NSString* titleString = [self title];
	NSMutableAttributedString *hyperLinkString = [[NSMutableAttributedString alloc] initWithString: titleString];
	NSRange selectedRange = {0, [hyperLinkString length]};
	
	[hyperLinkString beginEditing];
	
	[hyperLinkString addAttribute:NSForegroundColorAttributeName
							value:[NSColor colorWithCalibratedRed:0.8086 green:0.8086 blue:0.8086 alpha:1.0]
							range:selectedRange];
	
	[hyperLinkString addAttribute:NSUnderlineStyleAttributeName
							value:[NSNumber numberWithInt:NSSingleUnderlineStyle]
							range:selectedRange];
	[hyperLinkString endEditing];
	
	[self setAttributedTitle: hyperLinkString];
	[self sizeToFit];
	
	[hyperLinkString release];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	if (self)
	{
		[self initialize];
		
		if([aDecoder containsValueForKey:@"urlstring"])
		{
			[self setTheURLString:[aDecoder decodeObjectForKey:@"urlstring"]];
		}else
		{
			[self setTheURLString:@"http://www.kodak.com"];
		}
	}
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {	
	[super encodeWithCoder: coder];
	
	[coder encodeObject:[self theURLString] forKey:@"urlstring"];
}

- (id)valueForUndefinedKey:(NSString *)key
{
	if([key compare:@"urlstring"] == NSOrderedSame)
	{
		return [self theURLString];
	}else
	{
		return [super valueForUndefinedKey:key];
	}	
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{	
	if([key compare:@"urlstring"] == NSOrderedSame)
	{
		[self setTheURLString:value];
	}else
	{
		[super setValue:value forUndefinedKey:key];
	}
}


/****************************** resetCursorRects ********************************
 Setup the shape of cursor. 
 ********************************************************************************/
- (void)resetCursorRects
{
	[self addCursorRect: [self bounds] cursor: [NSCursor pointingHandCursor]];
}

-(void)setLanguageCodeString: (NSString* )aLanguageCodeString
{
	[languageCodeString release];
	languageCodeString = [aLanguageCodeString retain];
}

- (NSString* )languageCodeString
{
	return languageCodeString;
}

-(void)setRegionString: (NSString* )aRegionString
{
	[regionString release];
	regionString = [aRegionString retain];
}

- (NSString* )regionString
{
	return regionString;
}

- (IBAction) openURL:(id) sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[self theURLString]]];
}


- (NSString *) theURLString {
	return theURLString;
}

- (void) setTheURLString: (NSString *) newValue {
	[theURLString autorelease];
	theURLString = [newValue retain];
}

@end
