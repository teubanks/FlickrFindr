//
//  FlickrFindrNavigation.m
//  FlickrFindr
//
//  Created by Tracey Eubanks on 12/18/13.
//  Copyright (c) 2013 Tracey Eubanks. All rights reserved.
//

#import <KIF/KIF.h>

@interface FlickrFindrNavigation : KIFTestCase

@end

@implementation FlickrFindrNavigation


- (void)testSearch {
    [tester enterText:@"Bleh" intoViewWithAccessibilityLabel:@"search bar"];
    [tester tapViewWithAccessibilityLabel:@"done"];
    [tester waitForViewWithAccessibilityLabel:@"photoCell"];
}

@end
