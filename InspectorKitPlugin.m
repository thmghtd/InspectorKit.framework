//
//  InspectorPane.m
//  InspectorPane
//
//  Created by Steven on 3/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "InspectorKitPlugin.h"

@implementation InspectorKitPlugin

- (NSArray *)libraryNibNames {
    return [NSArray arrayWithObject:@"InspectorKitLibrary"];
}

- (NSArray *)requiredFrameworks {
    return [NSArray arrayWithObject:[NSBundle bundleWithIdentifier:@"com.thoughtfultree.InspectorKit"]];
}

- (NSString *)label {
	return @"InspectorKit";
}

@end
