//
//  PhotoCollectionViewController.m
//  FlickrFindr
//
//  Created by Tracey Eubanks on 12/18/13.
//  Copyright (c) 2013 Tracey Eubanks. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoCell.h"
#import "PhotoDetailViewController.h"
#import "APIInterface.h"

@interface PhotoCollectionViewController ()
@property (assign) CGRect hiddenSearchBarFrame;
@property (assign) CGRect visibleSearchBarFrame;
@end

@implementation PhotoCollectionViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        self.apiInterface = [[APIInterface alloc] init];
        [self.apiInterface setDelegate:self];

        self.imageFetchQueue = [[NSOperationQueue alloc] init];
        [self.imageFetchQueue setMaxConcurrentOperationCount:10];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch)];
    [self.navigationItem setRightBarButtonItem:rightButton];

    self.fetchingPhotosIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.fetchingPhotosIndicator setFrame:self.view.frame];

    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];

    self.hiddenSearchBarFrame = CGRectMake(0, -44, self.view.bounds.size.width, 44);
    self.visibleSearchBarFrame = CGRectMake(0, statusBarFrame.size.height, self.view.bounds.size.width, 44);

    self.searchBar = [[UISearchBar alloc] initWithFrame:self.hiddenSearchBarFrame];
    [self.searchBar setDelegate:self];

    self.darkeningView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.darkeningView setAlpha:0.0f];
    [self.darkeningView setBackgroundColor:[UIColor grayColor]];
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSearch)];
    [self.darkeningView addGestureRecognizer:dismissTap];
    [self showSearch];
}

#pragma mark - Search
-(void)showSearch {
    [self.navigationController.view addSubview:self.searchBar];
    [self.navigationController.view addSubview:self.darkeningView];

    [self.searchBar becomeFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        [self.searchBar setFrame:self.visibleSearchBarFrame];
        [self.darkeningView setAlpha:0.2f];
    }];
}

-(void)dismissSearch {
    if([self.searchBar isFirstResponder]){
        [self.searchBar resignFirstResponder];
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.searchBar setFrame:self.hiddenSearchBarFrame];
        [self.darkeningView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self.searchBar removeFromSuperview];
        [self.darkeningView removeFromSuperview];
    }];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.apiInterface searchPhotosWithText:searchBar.text];
    [self.view addSubview:self.fetchingPhotosIndicator];
    [self.fetchingPhotosIndicator startAnimating];
    [self dismissSearch];
}

#pragma mark - API Interface Delegate
-(void)returnedPhotos:(NSArray *)photoURLs {
    self.photos = photoURLs;
    [self.collectionView reloadData];
    [self.fetchingPhotosIndicator stopAnimating];
    [self.fetchingPhotosIndicator removeFromSuperview];
}

#pragma mark - Collection View Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];

    NSDictionary *currentPhoto = [self.photos objectAtIndex:indexPath.row];

    UIActivityIndicatorView *downloadIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [downloadIndicator setFrame:CGRectMake(50, 50, downloadIndicator.frame.size.width, downloadIndicator.frame.size.height)];
    [cell addSubview:downloadIndicator];
    [downloadIndicator startAnimating];
    [self.imageFetchQueue addOperationWithBlock:^{
        cell.thumbnail.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[currentPhoto objectForKey:@"thumbnail"]]];
        cell.shortTitle.text = [currentPhoto objectForKey:@"title"];
        [downloadIndicator stopAnimating];
        [downloadIndicator removeFromSuperview];
    }];

    return cell;
}

#pragma mark - Photo Details
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"photoDetailSegue"]){
        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];

        NSDictionary *currentPhoto = [self.photos objectAtIndex:selectedIndexPath.row];
        PhotoDetailViewController *photoDetails = [segue destinationViewController];
        UIImage *largeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[currentPhoto objectForKey:@"large"]]];
        photoDetails.largeImage = largeImage;
        photoDetails.titleString = [currentPhoto objectForKey:@"title"];
    }
}

@end
