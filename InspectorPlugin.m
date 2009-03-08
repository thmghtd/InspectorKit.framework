//
//  InspectorPane.m
//  InspectorPane
//
//  Created by Steven on 3/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "InspectorPlugin.h"

@implementation InspectorPlugin

- (NSArray *)libraryNibNames {
    return [NSArray arrayWithObject:@"InspectorLibrary"];
}

- (NSArray *)requiredFrameworks {
    return [NSArray arrayWithObject:[NSBundle bundleWithIdentifier:@"com.thoughtfultree.InspectorFramework"]];
}

- (NSString *)label {
	return @"Inspector";
}

@end
