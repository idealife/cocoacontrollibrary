//
//  KATableViewBlackFadeDrawer.m
//  AiOControlIBPlugin
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

#import "KATableViewBlackFadeDrawer.h"
#import "KATableViewPresentationInfo.h"

static NSString *grayFade = @"grayfade.png";
@implementation KATableViewBlackFadeDrawer

/*!
 @function
 @abstract   drawer
 @discussion This class method should return a auto release object of itself.
 @param      nil
 @result     The autorelease object of self.
 */

+ (id<IControlDrawer>) drawer
{
	return [[[self alloc] init] autorelease];
}

/*!
 @function	
 @abstract   Draw the presentation of the control specified in the args.
 @discussion Draw the presentation of the control specified in the args.
 @param      control The control which implements protocol IPresentationSeparated
 @param		args The presentation args.
 @result     The function return void.
 */
- (void) DrawControl:(id<IPresentationSeparated>) control Args:(PresentationArgs *)args
{
	KATableViewPresentationInfo *info = (KATableViewPresentationInfo *)[args m_PresentationInfo];
	switch ([info currentDrawType]) {
		case CornorView:
			[self drawCornorView:((KATableCornerView *)control) inRect:[args m_ClipRectangle]];
			break;
		case HeaderCell:
			[self drawHeaderCell:((KATableHeaderCell *)control) inRect:[args m_ClipRectangle] inView:[info kaControlView]];
			break;
		case TableViewBody:
			[self drawTableRows:((KATableView *)control) rawIndex:[info currentRowIndex] inRect:[args m_ClipRectangle]];
			break;
		default:
			break;
	}
}

- (void) drawCornorView:(KATableCornerView *) aCornorView inRect:(NSRect) aRect
{
	[[NSColor colorWithDeviceRed:0.66f green:0.66f blue:0.66f alpha:1.0] set];
	NSRectFill(aRect);
}

- (id)textColor {	
	return [NSColor whiteColor];
}

- (void) drawHeaderCell:(KATableHeaderCell *) aCell inRect:(NSRect) cellFrame inView:(NSView *) controlView
{
	cellFrame.size.height += 1;
	[[NSColor colorWithDeviceRed:0.73 green:0.73 blue:0.73 alpha:1.0] set];
	NSRectFill(cellFrame);
	
	NSFont *titleFont = [NSFont fontWithName: @"Arial" size: 12.0f];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    [paraStyle setAlignment:NSLeftTextAlignment];
    [paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   titleFont, NSFontAttributeName,
									   [NSColor colorWithDeviceRed:0.141f green:0.141f blue:0.141f alpha:1.0], NSForegroundColorAttributeName,
									   paraStyle, NSParagraphStyleAttributeName,
									   nil];
	NSString *headerTitle = [aCell title];
	NSRect textRect = cellFrame;
	textRect.origin.y += 1;
	textRect.origin.x += 10;
	if(headerTitle)
		[headerTitle drawInRect:textRect withAttributes:titleAttrs];
	[paraStyle release];
	
	//Draw right vertical gap line
	NSRect borderRect = cellFrame;
	borderRect.origin.x += borderRect.size.width - 1;
	borderRect.size.width = 1;
	
	if((cellFrame.origin.x + cellFrame.size.width) != ([controlView frame].origin.x + [controlView frame].size.width))
	{
		[[NSColor colorWithDeviceRed:0.79 green:0.79 blue:0.79 alpha:1.0] set];
		NSRectFill(borderRect);
	}
}

- (void) drawTableRows:(KATableView *) aTableView rawIndex:(int) rowIndex inRect:(NSRect) aRect
{
	if([[aTableView selectedRowIndexes] containsIndex:rowIndex])
	{
		NSRect selectRect = [aTableView rectOfRow:rowIndex];
		NSString *file = [[NSBundle bundleForClass:[self class]] pathForImageResource:grayFade];
		NSImage *tempTab = [[NSImage alloc] initWithContentsOfFile:file];		
		[tempTab drawInRect:selectRect fromRect:NSZeroRect operation:5 fraction:1.0];		
		[tempTab release];
	}
	
	NSArray *m_Columns = [aTableView tableColumns];
	int i, count = [m_Columns count];
	
	NSFont *titleFont = [NSFont fontWithName: @"Arial" size: 12.0f];
	NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    [paraStyle setAlignment:NSLeftTextAlignment];
    [paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   titleFont, NSFontAttributeName,
									   [NSColor colorWithDeviceRed:0.141f green:0.141f blue:0.141f alpha:1.0], NSForegroundColorAttributeName,
									   paraStyle, NSParagraphStyleAttributeName,
									   nil];
	float lastWidth = 0.0f;
	
	for (i = 0; i < count; i++) 
	{
		NSTableColumn* m_TableColumn = [m_Columns objectAtIndex:i];
		// Call the dataSource to get the row value of the given column
		// Need to check if we have the dataSource
		if([aTableView dataSource])
		{
			NSString *rowText = [[aTableView dataSource] tableView:aTableView objectValueForTableColumn:m_TableColumn row:rowIndex];
			// If we got the row text
			// Then we begin to draw row text for each column
			if(rowText)
			{
				NSRect rowTextRect = [aTableView rectOfRow:rowIndex];
				rowTextRect.origin.x = lastWidth;
				rowTextRect.size.width = [m_TableColumn width];
				[rowText drawInRect:NSInsetRect(rowTextRect, 10, -1) withAttributes:titleAttrs];
			}
		}
		lastWidth += [m_TableColumn width];
	}	
	
	[paraStyle release];
}

@end
