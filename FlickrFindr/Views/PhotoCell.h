//
//  PhotoCell.h
//  FlickrFindr
//
//  Created by Tracey Eubanks on 12/18/13.
//  Copyright (c) 2013 Tracey Eubanks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell
@property (strong, nonatomic) NSURL *imageURL;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *shortTitle;
@end
