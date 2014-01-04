//
//  UrlLoader.h
//  David Sayag
//
//  Created by user on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHTTPMethodPost @"Post"
#define kHTTPMethodGet @"Get"
#define kHTTPMethodPut @"Put"
#define kHTTPMethodDelete @"Delete"

#define kAPIBaseURL                         @"http://0.0.0.0:3000"

@protocol UrlLoaderDelegate <NSObject>

- (void) urlLoadingDone:(NSData*)data;
- (void) urlLoadingError;

@end

@interface UrlLoader : NSObject 

@property (nonatomic, weak) id<UrlLoaderDelegate> delegate;

- (void) startLoadingUrl:(NSString *) urlStr;
- (void)startPostToURL:(NSString*)urlStr withPostData:(NSData*)postData;

- (void)sendRequest:(NSString *)requestURL withParams:(NSString *)params httpMethod:(NSString *)method;


//- (void) startPost:(NSString *) urlStr withPostDataStr:(NSString *) postData;
//- (void) startPost:(NSString *) urlStr withPostData:(NSString *) postData storeDataIn:(NSMutableData *) data;
//- (void)startPostToURL:(NSString*) urlStr withPostDataString:(NSString*)postDataStr isJson:(BOOL)isJson;
- (void)cancel;

@end
