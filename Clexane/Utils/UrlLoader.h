//
//  UrlLoader.h
//  David Sayag
//
//  Created by user on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHTTPMethodPost     @"Post"
#define kHTTPMethodGet      @"Get"
#define kHTTPMethodPut      @"Put"
#define kHTTPMethodDelete   @"Delete"

#define kContentTypePostData   @"application/x-www-form-urlencoded"
#define kContentTypeJSONData   @"application/json"

@protocol UrlLoaderDelegate <NSObject>

- (void) urlLoadingDone:(NSData*)data;
- (void) urlLoadingError;

@end

@interface UrlLoader : NSObject 

@property (nonatomic, weak) id<UrlLoaderDelegate> delegate;

- (void) startLoadingUrl:(NSString *) urlStr;
- (void)startPostToURL:(NSString*)urlStr withPostData:(NSData*)postData;

- (void)sendRequest:(NSString *)requestURL withParams:(NSString *)params httpMethod:(NSString *)method;
- (void)sendRequest:(NSString *)requestURL withParams:(NSString *)params httpMethod:(NSString *)method
        contentType:(NSString *)contentType;

- (void)cancel;

@end
