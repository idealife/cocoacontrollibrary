//
//  DrawerFactory.m
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

#import "DrawerFactory.h"
@class KACustomViewBlackFadeDrawer, KACustomView, KACustomViewCustomDrawer, KAWindowBlackFadeDrawer, KAButtonCell, KAPopUpButtonCell;
@class KAThemeFrame, KAScroller, KAScrollerBlackFadeDrawer, KAButtonBlackFadeDrawer, KAButtonGrayDrawer, KAPopUpButtonBlackFadeDrawer;
@class KAProgressIndicator, KAProgressBarBlackFadeDrawer, KATableViewBlackFadeDrawer, KATableView, KATableCornerView, KATableHeaderCell;
@class KATextFieldBlackFadeDrawer, KATextFieldCell;

@implementation DrawerFactory

- (id) init
{
	if(self = [super init])
	{
		[self setM_DrawerList:[NSMutableDictionary dictionary]];
		[self InitializeDrawerList];
	}
	return self;
}

- (void) dealloc
{
	[self setM_DrawerList:nil];
	[super dealloc];
}

/*!
 @function	
 @abstract   InitializeDrawerList
 @discussion Initialize all draw list. You need to add your drawer here.
 @param      nil.
 @result     void.
 */
- (void) InitializeDrawerList
{
	[self RegisterDrawer:[KACustomViewBlackFadeDrawer drawer] Type:[KACustomView class] StyleId:0];
	[self RegisterDrawer:[KACustomViewCustomDrawer drawer] Type:[KACustomView class] StyleId:1];
	[self RegisterDrawer:[KAWindowBlackFadeDrawer drawer] Type:[KAThemeFrame class] StyleId:0];
	[self RegisterDrawer:[KAScrollerBlackFadeDrawer drawer] Type:[KAScroller class] StyleId:0];
	[self RegisterDrawer:[KAButtonGrayDrawer drawer] Type:[KAButtonCell class] StyleId:0];
	[self RegisterDrawer:[KAButtonBlackFadeDrawer drawer] Type:[KAButtonCell class] StyleId:1];
	[self RegisterDrawer:[KAPopUpButtonBlackFadeDrawer drawer] Type:[KAPopUpButtonCell class] StyleId:0];
	[self RegisterDrawer:[KAProgressBarBlackFadeDrawer drawer] Type:[KAProgressIndicator class] StyleId:0];
	[self RegisterDrawer:[KATableViewBlackFadeDrawer drawer] Type:[KATableCornerView class] StyleId:0];
	[self RegisterDrawer:[KATableViewBlackFadeDrawer drawer] Type:[KATableHeaderCell class] StyleId:0];
	[self RegisterDrawer:[KATableViewBlackFadeDrawer drawer] Type:[KATableView class] StyleId:0];
	[self RegisterDrawer:[KATextFieldBlackFadeDrawer drawer] Type:[KATextFieldCell class] StyleId:0];
}

/*!
 @function	
 @abstract   Get drawer by control type.
 @discussion Get the drawer according the control type.
 @param      controlType The class type of the control.
 @result     The corresponding drawing.
 */
- (id<IControlDrawer>) GetDrawer:(Class) controlType
{
	NSMutableDictionary *drawList = [m_DrawerList objectForKey:controlType];
	if(drawList)
	{
		return (id<IControlDrawer>)[drawList objectForKey:[NSNumber numberWithInt:0]];
	}
	return nil;
}

/*!
 @function	
 @abstract   Get drawer.
 @discussion Get the drawer according to the control type and style id.
 @param      controlType The class type of the control.
 @param		styleId The style id of the control.
 @result     The drawer associated with the control.
 */
- (id<IControlDrawer>) GetDrawer:(Class) controlType 
						 StyleId:(int) styleId
{
	NSMutableDictionary *drawList = [m_DrawerList objectForKey:controlType];
	if(drawList)
	{
		return (id<IControlDrawer>)[drawList objectForKey:[NSNumber numberWithInt:styleId]];
	}
	return nil;
}

/*!
 @function	
 @abstract   Register drawer.
 @discussion Associate a drawer instance with the specified style of the control.
 @param      drawer The draw which implements the IControlDrawer protocol.
 @param		controlType The class type of the control.
 @param		styleId The int of the control
 @result     void.
 @exception	NSInvalidArgumentException Class is nil or drawer is nil.
 */
- (void) RegisterDrawer:(id<IControlDrawer>) drawer
				   Type:(Class) controlType 
				StyleId:(int) styleId
{
	if(nil == drawer)
	{
		[NSException raise:NSInvalidArgumentException format:@"The drawer can't be nil"];
	}
	
	if(nil == controlType)
	{
		[NSException raise:NSInvalidArgumentException format:@"The Class can't be nil"];
	}
	
	NSMutableDictionary *drawList = [m_DrawerList objectForKey:controlType];
	if(nil == drawList)
	{
		drawList = [NSMutableDictionary dictionary];
		[m_DrawerList setObject:drawList forKey:controlType];
	}
	[drawList setObject:drawer forKey:[NSNumber numberWithInt:styleId]];	
}


- (NSMutableDictionary *) m_DrawerList {
	return m_DrawerList;
}

- (void) setM_DrawerList: (NSMutableDictionary *) newValue {
	[m_DrawerList autorelease];
	m_DrawerList = [newValue retain];
}

@end
