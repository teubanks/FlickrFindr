//
//  APIInterface.m
//  FlickrFindr
//
//  Created by Tracey Eubanks on 12/18/13.
//  Copyright (c) 2013 Tracey Eubanks. All rights reserved.
//

#import "APIInterface.h"

static NSString *APIURL = @"http://api.flickr.com/services/rest";
static NSString *APIKey = @"1dd17dde0fed7286935d83875fcc17dd";

@implementation APIInterface
-(id)init {
    self = [super init];
    if(self){
        self.backgroundOperationQueue = [[NSOperationQueue alloc] init];
        self.backgroundOperationQueue.maxConcurrentOperationCount = 5;

        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.networkSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:self.backgroundOperationQueue];
    }
    return self;
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSError *error = nil;
    NSDictionary *photoResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error){
        NSLog(@"data read error: %@", [error description]);
        return;
    }
    NSMutableArray *urlsArray = [[NSMutableArray alloc] init];

    NSArray *photos = [[photoResponse objectForKey:@"photos"] objectForKey:@"photo"];
    [photos enumerateObjectsUsingBlock:^(NSDictionary *photo, NSUInteger idx, BOOL *stop) {
        // http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
        NSString *thumbPhotoURLString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_s.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        NSString *largePhotoURLString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_c.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];

        NSURL *thumbnailPhotoURL = [NSURL URLWithString:thumbPhotoURLString];
        NSURL *largePhotoURL = [NSURL URLWithString:largePhotoURLString];
        NSString *photoTitle = [photo objectForKey:@"title"];

        [urlsArray addObject:[@{@"thumbnail":thumbnailPhotoURL, @"large":largePhotoURL, @"title":photoTitle} mutableCopy]];
    }];

    [self.delegate returnedPhotos:urlsArray];
}

-(void)searchPhotosWithText:(NSString *)searchText {
    NSString *urlString = [NSString stringWithFormat:@"%@?api_key=%@&method=flickr.photos.search&text=%@&format=json&nojsoncallback=1&per_page=25&safe_search=1", APIURL, APIKey, [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *photoRequestURL = [NSURL URLWithString:urlString];
    NSURLRequest *photoRequest = [[NSURLRequest alloc] initWithURL:photoRequestURL];
    NSURLSessionDataTask *taskRequest = [self.networkSession dataTaskWithRequest:photoRequest];
    [taskRequest resume];
}
@end
