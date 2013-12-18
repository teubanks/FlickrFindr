//
//  PhotoCollectionViewController.h
//  FlickrFindr
//
//  Created by Tracey Eubanks on 12/18/13.
//  Copyright (c) 2013 Tracey Eubanks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIInterface.h"

@interface PhotoCollectionViewController : UICollectionViewController <UISearchBarDelegate, APIInterfaceDelegate>
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) UIView *darkeningView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) APIInterface *apiInterface;
@property (strong, nonatomic) NSOperationQueue *imageFetchQueue;
@end
