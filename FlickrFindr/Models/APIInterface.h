//
//  APIInterface.h
//  FlickrFindr
//
//  Created by Tracey Eubanks on 12/18/13.
//  Copyright (c) 2013 Tracey Eubanks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIInterfaceDelegate
-(void)returnedPhotos:(NSArray*)photoURLs;
@end

@interface APIInterface : NSObject <NSURLSessionDataDelegate>
@property (strong, nonatomic) NSURLSession *networkSession;
@property (strong) NSOperationQueue *backgroundOperationQueue;
@property (weak) id delegate;

-(void)searchPhotosWithText:(NSString*)searchText;
@end
