//
//  PhotoCollectionViewController.h
//  FlickrFindr
//
//  Created by Tracey Eubanks on 12/18/13.
//  Copyright (c) 2013 Tracey Eubanks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewController : UICollectionViewController <UISearchBarDelegate>
@property (strong, nonatomic) NSArray *photos;
@end
