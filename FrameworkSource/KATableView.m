//
//  KATableView.m
//  AiOControls
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

#import "KATableView.h"
#import "KATableCornerView.h"
#import "KATableHeaderView.h"
#import "KATableViewPresentationInfo.h"
@class PresentationArgs, PresentationManager;

int __TableViewStyleId = 0;
extern NSString *BlackFade;

@implementation KATableView

-(id)initWithFrame:(NSRect) frame
{
	if(self = [super initWithFrame:frame])
	{
		//Corner view
		KATableCornerView *cornerView = [[[KATableCornerView alloc] init] autorelease];	
		[self setCornerView:cornerView];
		
		KATableHeaderView *headerView = [[[KATableHeaderView alloc] init] autorelease];
		[self setHeaderView:headerView];
		//Set row height
		[self setRowHeight:16.0f];	
		
		//Setup Header Cells		
		[self updateTableColumnHeaders];
		
		[self setKastyles:[NSArray arrayWithObjects:BlackFade, nil]];
		[self setKastyle:BlackFade];
	}
	return self;
}

- (void) updateTableColumnHeaders
{
	NSArray *columns = [self tableColumns];
	int i, count = [columns count];
	for (i = 0; i < count; i++) {
		NSTableColumn * aColumn = [columns objectAtIndex:i];
		if([[aColumn headerCell] class] == [NSTableHeaderCell class]) {
			
			KATableHeaderCell *newHeader = [[KATableHeaderCell alloc] initTextCell: @""];
			[newHeader setFont: [[aColumn headerCell] font]];
			[newHeader setTitle:[[aColumn headerCell] title]];
			[newHeader setGridColor:[self gridColor]];
			[aColumn setHeaderCell: newHeader];
			[newHeader release];
		}
	}
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder]; 
	
	if(self) {		
		if([aDecoder containsValueForKey:@"kastyle"])
		{
			[self setKastyle:[aDecoder decodeObjectForKey:@"kastyle"]];
		}else
		{
			[self setKastyle:BlackFade];
		}
		[self setKastyles:[NSArray arrayWithObjects:BlackFade, nil]];
		//Setup Header Cells
		[self updateTableColumnHeaders];
	}
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	[super encodeWithCoder: coder];
	
	[coder encodeObject:[self kastyle] forKey:@"kastyle"];
	[coder encodeObject:[self kastyles] forKey:@"kastyles"];
}

-(void)dealloc
{
	[super dealloc];
}

- (void)drawRow:(int)rowIndex clipRect:(NSRect)clipRect
{	
	PresentationArgs *args = [[PresentationArgs alloc] init];
	KATableViewPresentationInfo *info = [[KATableViewPresentationInfo alloc] init];
	[info setCurrentDrawType:TableViewBody];
	[info setCurrentRowIndex:rowIndex];
	[args setM_ClipRectangle:clipRect];
	[args setM_PresentationInfo:info];
	
	[[PresentationManager Instance] DrawControl:self Args:args Style:__TableViewStyleId];
	
	[info release];
	[args release];
}


- (void)highlightSelectionInClipRect:(NSRect)clipRect
{
	[[self backgroundColor] set];
	NSRectFill(clipRect);		
}

- (void)drawBackgroundInClipRect:(NSRect)clipRect
{
	[[self backgroundColor] set];
	NSRectFill(clipRect);
}

- (NSString *) kastyle {
	return kastyle;
}

- (void) setKastyle: (NSString *) newValue {
	if(kastyle != newValue)
	{
		[kastyle release];
		kastyle = [newValue retain];
		
		if([kastyle compare:BlackFade] == NSOrderedSame)
		{
			__TableViewStyleId = 0;
		}
	}
}

- (NSArray *) kastyles {
	return kastyles;
}

- (void) setKastyles: (NSArray *) newValue {
	if(kastyles != newValue)
	{
		[kastyles release];
		kastyles = [newValue retain];
	}
}

@end
