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

@interface PhotoCollectionViewController ()
@property (assign) CGRect hiddenSearchBarFrame;
@property (assign) CGRect visibleSearchBarFrame;
@end

@implementation PhotoCollectionViewController

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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch)];
    [self.navigationItem setRightBarButtonItem:rightButton];

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
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];

    cell.shortTitle.text = @"placeholder";

    NSString *imageToLoad = @"nonexistantimage";
    cell.thumbnail.image = [UIImage imageNamed:imageToLoad];

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[sender identifier] isEqualToString:@"photoDetailSegue"]){
        PhotoDetailViewController *photoDetails = (PhotoDetailViewController*)[segue destinationViewController];
        [photoDetails.photoView setImage:[UIImage imageNamed:@"placeholder"]];
        photoDetails.titleText.text = @"placeholder";
    }
}

@end
