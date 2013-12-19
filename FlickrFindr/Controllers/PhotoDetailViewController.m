//
//  PhotoDetailViewController.m
//  FlickrFindr
//
//  Created by Tracey Eubanks on 12/18/13.
//  Copyright (c) 2013 Tracey Eubanks. All rights reserved.
//

#import "PhotoDetailViewController.h"

@interface PhotoDetailViewController ()
@property (strong, nonatomic) UIActivityIndicatorView *loadingLargeImageIndicator;
@end

@implementation PhotoDetailViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        self.loadingLargeImageIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.loadingLargeImageIndicator setColor:[UIColor blackColor]];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.view addSubview:self.loadingLargeImageIndicator];
    [self.loadingLargeImageIndicator setFrame:self.photoView.frame];
    [self.loadingLargeImageIndicator startAnimating];
    
    dispatch_queue_t imageLoadQueue = dispatch_queue_create("com.flickrfindr.large_image_load", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(imageLoadQueue,^{
        UIImage *largeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.largeImageURL]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.photoView.image = largeImage;
            [self.loadingLargeImageIndicator stopAnimating];
            [self.loadingLargeImageIndicator removeFromSuperview];
        });
    });
    self.titleText.text = self.titleString;

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationItem.backBarButtonItem setAccessibilityLabel:@"back"];
}

@end
