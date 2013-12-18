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
}

-(void)showSearch {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];

    CGRect hiddenSearchBarFrame = CGRectMake(0, -44, self.view.bounds.size.width, 44);
    CGRect visibleSearchBarFrame = CGRectMake(0, statusBarFrame.size.height, self.view.bounds.size.width, 44);

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:hiddenSearchBarFrame];
    [searchBar setDelegate:self];
    [self.navigationController.view addSubview:searchBar];

    UIView *darkeningView = [[UIView alloc] initWithFrame:self.view.frame];
    [darkeningView setAlpha:0.0f];
    [darkeningView setBackgroundColor:[UIColor grayColor]];
    [self.navigationController.view addSubview:darkeningView];

    [UIView animateWithDuration:0.3f animations:^{
        [searchBar setFrame:visibleSearchBarFrame];
        [darkeningView setAlpha:0.2f];
    } completion:^(BOOL finished) {
        [searchBar becomeFirstResponder];
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
