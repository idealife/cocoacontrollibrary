//
//  KAWindowInspector.m
//  AiOControlIBPlugin
//
//  Created by Edward.Chen on 11/13/09.
//  Copyright 2009 Eastman Kodak Company. All rights reserved.
//

#import "KAWindowInspector.h"

@implementation KAWindowInspector

- (NSString *)viewNibName {
    return @"KAWindowInspector";
}

- (void)refresh {
	// Synchronize your inspector's content view with the currently selected objects
	[super refresh];
}

- (NSString *) label{
	return @"KAWindowStyle";
}

@end
