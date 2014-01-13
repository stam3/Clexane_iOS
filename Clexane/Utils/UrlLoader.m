//
//  UrlLoader.m
//  David Sayag
//
//  Created by user on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UrlLoader.h"
#import "SIAlertView.h"

@interface UrlLoader ()

@property (nonatomic, strong) NSMutableData *webData;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSString *currentUrlStr;

@end

@implementation UrlLoader

- (void)cancel {
    
    if(self.connection) {
        
        [self.connection cancel];
        _delegate = nil;
    }
}

- (void) startLoadingUrl:(NSString *) urlStr {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.currentUrlStr = urlStr;
	self.webData = [NSMutableData data];
	NSURL *url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[req addValue:0 forHTTPHeaderField:@"Content-Length"];
	[req setHTTPMethod:@"GET"];
    NSMutableString* cookieStringToSet = [[NSMutableString alloc] init];
    NSArray *cookiesToSet = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kAPIBaseURL]];
    for (NSHTTPCookie *cookie in cookiesToSet) {
        [cookieStringToSet appendFormat:@"%@=%@;", cookie.name, cookie.value];
    }
    NSLog(@"cookieStringToSet: %@", cookieStringToSet);
    
    if (cookieStringToSet.length) {
        [req setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
    }
//    [req setValue:@"WkoS2f5Dy5lOnLVfFTTYTw" forHTTPHeaderField:@"auth_token"];
    

	
    self.connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

- (void)startPostToURL:(NSString*)urlStr withPostData:(NSData*)postData {
 
    NSURL *url = [NSURL URLWithString: urlStr];
	NSLog (@"POST URL: %@", url);
   
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
    
	self.connection = [[NSURLConnection alloc]
                       initWithRequest:request
                       delegate:self];

}

//- (void)startPostToURL:(NSString*) urlStr withPostData:(NSData*)postData {
//    
//    NSData *postData;
//    if (isJson)
//        postData = [NSJSONSerialization dataWithJSONObject:postDataStr options:0 error:nil];
//    else
//        postData = [postDataStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    [self startPostToURL:urlStr withPostData:postData];
//}

- (void)sendRequest:(NSString *)requestURL withParams:(NSString *)params httpMethod:(NSString *)method {
 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	self.webData = [NSMutableData data];
    NSString* str = [NSString stringWithFormat:@"%@%@", kAPIBaseURL, requestURL];
	NSURL *url = [NSURL URLWithString:str];
	NSLog (@"Request URL: %@", url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    
	//NSString *post = @"login_email=gilddd@2.com&password=&login_b=login";
    if (params) {
        NSData *encodedPostData = [params dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [encodedPostData length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:encodedPostData];
        NSLog (@"post data: %@", params);
    }
	
	[request setHTTPMethod:method];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString* cookieStringToSet = [[NSMutableString alloc] init];
    NSArray *cookiesToSet = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kAPIBaseURL]];
    for (NSHTTPCookie *cookie in cookiesToSet) {
        [cookieStringToSet appendFormat:@"%@=%@;", cookie.name, cookie.value];
    }
    NSLog(@"cookieStringToSet: %@", cookieStringToSet);
    if (cookieStringToSet.length) {
        [request setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
    }
    
	self.connection = [[NSURLConnection alloc]
                       initWithRequest:request
                       delegate:self];
}


//- (void) startPost:(NSString *) urlStr withPostDataStr:(NSString *) postData {
//
//	
//	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//	NSLog (@"post");
//	self.webData = [NSMutableData data];
//	NSURL *url = [NSURL URLWithString: urlStr];
//	NSLog (@"POST URL: %@", url);
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
//    
//	//NSString *post = @"login_email=gilddd@2.com&password=&login_b=login";
//    if (postData) {
//        NSData *encodedPostData = [postData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//        NSString *postLength = [NSString stringWithFormat:@"%d", [encodedPostData length]];
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [request setHTTPBody:encodedPostData];
//        NSLog (@"post data: %@", postData);
//    }
//	
//	[request setHTTPMethod:@"POST"];
//	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    NSMutableString* cookieStringToSet = [[NSMutableString alloc] init];
//    NSArray *cookiesToSet = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://0.0.0.0:3000"]];
//    for (NSHTTPCookie *cookie in cookiesToSet) {
//        [cookieStringToSet appendFormat:@"%@=%@;", cookie.name, cookie.value];
//    }
//    NSLog(@"cookieStringToSet: %@", cookieStringToSet);
//    if (cookieStringToSet.length) {
//        [request setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
//    }
//    //[request setValue:@"WkoS2f5Dy5lOnLVfFTTYTw" forHTTPHeaderField:@"auth_token"];
//	
//    
//	self.connection = [[NSURLConnection alloc]
//                       initWithRequest:request
//                       delegate:self];
//}

//- (void) startPost:(NSString *) urlStr withPostData:(NSString *) postData
//		storeDataIn:(NSMutableData *) data {
//	
//	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//	NSLog (@"post");
//	self.webData = [NSData data];//self.webData = data;
//	//NSString *urlString = @"http://192.168.0.3:8000/Groupages/default/index";
//	NSURL *url = [NSURL URLWithString: urlStr];
//	NSLog (@"POST URL: %@", url);
//
//	//NSString *post = @"login_email=gilddd@2.com&password=&login_b=login";
//	NSData *encodedPostData = [postData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];	
//	NSString *postLength = [NSString stringWithFormat:@"%d", [encodedPostData length]];
//	NSLog (@"post data: %@", postData);
//
//	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
//	[request setHTTPMethod:@"POST"];
//	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//	[request setHTTPBody:encodedPostData];
//
//	self.connection = [[NSURLConnection alloc]
//								   initWithRequest:request
//								   delegate:self];
//}


#pragma mark -
#pragma mark connection Methods

-(void) connection:(NSURLConnection *) connection 
didReceiveResponse:(NSURLResponse *) response {
	if(self.webData)
		[self.webData setLength: 0];
}
//Note that the preceding code initializes the length of webData to 0. 
//As the data progressively comes in from the web service, the 
// connection:didReceiveData: method will be called repeatedly.
// You use the method to append the data received to the webData object:

-(void) connection:(NSURLConnection *) connection 
	didReceiveData:(NSData *) data {
    
	if(self.webData)
		[self.webData appendData:data];
}
//If there is an error during the transmission, 
//the connection:didFailWithError: method will be called:

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSLog(@"didFailWithError: %@", error);
	if(self.webData) {
        self.webData = nil;
    }
    NSString* err_msg = [NSString stringWithFormat:@"Error: %@", error];
    SIAlertView* alertView = [[SIAlertView alloc] initWithTitle:@"Error" andMessage:err_msg];
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDefault
                          handler:nil];
    [alertView show];
    if (self.delegate)
        [self.delegate urlLoadingError];
//	else if (caller)
//		[caller urlLoadingError];
    
}
//When the connection has finished and succeeded in downloading the response,
//the connectionDidFinishLoading: method will be called:

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if(self.webData) {
		NSLog(@"DONE for URL: %@. Received Bytes: %d",self.currentUrlStr, [self.webData length]);
	} else {
		NSLog(@"DONE getting URL: %@ with no data", self.currentUrlStr);
	}
    
//    if ([webData length] == 0) {
//         NSString *theXML = [[NSString alloc] 
//         initWithBytes: [webData mutableBytes] 
//         length:[webData length] 
//         encoding:NSUTF8StringEncoding];
//         NSLog(@"Results:\n%@", theXML);
//        
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HTTP get returned 0"
//                                                        message:currentUrlStr	 
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//        [theXML release];
//    }
    
    NSMutableString* cookieStringToSet = [[NSMutableString alloc] init];
    NSArray *cookiesToSet = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kAPIBaseURL] ];
    for (NSHTTPCookie *cookie in cookiesToSet) {
        [cookieStringToSet appendFormat:@"%@=%@;", cookie.name, cookie.value];
    }
    NSLog(@"cookieStringToSet: %@", cookieStringToSet);
    
	if (self.delegate)
        [self.delegate urlLoadingDone:self.webData];
//	else if (caller)
//		[caller urlLoadingDone:[webData autorelease]];
}

@end
