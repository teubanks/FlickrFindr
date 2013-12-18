//
//  PhotoDetailViewController.m
//  FlickrFindr
//
//  Created by Tracey Eubanks on 12/18/13.
//  Copyright (c) 2013 Tracey Eubanks. All rights reserved.
//

#import "PhotoDetailViewController.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIActivityIndicatorView *largeImageLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [largeImageLoadingIndicator setColor:[UIColor blackColor]];
    [self.view addSubview:largeImageLoadingIndicator];
    [largeImageLoadingIndicator setFrame:self.photoView.frame];
    [largeImageLoadingIndicator startAnimating];
    
    dispatch_queue_t imageLoadQueue = dispatch_queue_create("com.flickrfindr.large_image_load", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(imageLoadQueue,^{
        UIImage *largeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.largeImageURL]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.photoView.image = largeImage;
            [largeImageLoadingIndicator stopAnimating];
            [largeImageLoadingIndicator removeFromSuperview];
        });
    });
    self.titleText.text = self.titleString;
}

@end
