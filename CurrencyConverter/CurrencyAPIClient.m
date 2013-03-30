//
//  CurrencyAPIClient.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 03/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "CurrencyAPIClient.h"

@interface CurrencyAPIClient ()

@property (nonatomic, strong) NSOperationQueue *processingQueue; // the queue that will process JSONs
@property (nonatomic) NSUInteger activityCount;

@end

static NSString * const kOpenExchangeBaseURL = @"http://openexchangerates.org/api/";
static NSString * const kOpenExchangeAppId = @"06840bce5d424835a14be156a02c53f1";

@implementation CurrencyAPIClient

+ (instancetype) sharedClient {
    static dispatch_once_t onceToken;
    static CurrencyAPIClient *_sharedClient = nil;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    return _sharedClient;
}

- (void)setActivityCount:(NSUInteger)activityCount {
    @synchronized (self) {
        _activityCount = MAX(activityCount, 0);
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = _activityCount > 0;
    }
}
- (NSOperationQueue *)processingQueue {
    if (! _processingQueue) {
        _processingQueue = [[NSOperationQueue alloc] init];
    }
    
    return _processingQueue;
}

+ (NSURL *)APIURLByAddingPath:(NSString *)path {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kOpenExchangeBaseURL, path]];
}

+ (NSURL *)authenticatedAPIURLByAddingPath:(NSString *)path {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?app_id=%@", kOpenExchangeBaseURL, path, kOpenExchangeAppId]];
}

- (void)fetchJSONRequest:(NSURLRequest *)request success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    self.activityCount++;
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.processingQueue completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {
        self.activityCount--;
        
        if ([data length] > 0 && ! err) { // received data with no errors?
            NSError *parseError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            
            if (result) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(result);
                    });
                }
            } else if (parseError) {
                err = parseError;
            }
        }
        
        if (err && failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(err);
            });
            
        }
    }];
}

- (void)getCurrencies:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    // no need to pass token to API on this call
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[[self class] APIURLByAddingPath:@"currencies.json"]];
    
    [self fetchJSONRequest:req success:success failure:failure];
}

- (void)getCurrencyMarketInfo:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    // creates a request with the authenticated URL (passing the app_id)
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[[self class] authenticatedAPIURLByAddingPath:@"latest.json"]];
    
    [self fetchJSONRequest:req success:success failure:failure];
}

@end
