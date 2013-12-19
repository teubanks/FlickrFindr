//
//  FlickrFindrNavigation.m
//  FlickrFindr
//
//  Created by Tracey Eubanks on 12/18/13.
//  Copyright (c) 2013 Tracey Eubanks. All rights reserved.
//

#import "FlickrFindrNavigation.h"

@implementation FlickrFindrNavigationTests

-(void)beforeAll {
    [tester enterText:@"Green" intoViewWithAccessibilityLabel:@"search bar"];
    [tester tapViewWithAccessibilityLabel:@"search"];
    [tester waitForViewWithAccessibilityLabel:@"photoCell"];
}

-(void)testDetailView {
    [tester tapViewWithAccessibilityLabel:@"photoCell"];
    [tester tapViewWithAccessibilityLabel:@"Green"];
}

@end
