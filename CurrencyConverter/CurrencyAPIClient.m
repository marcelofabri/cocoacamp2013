//
//  CurrencyAPIClient.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 03/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "CurrencyAPIClient.h"

@interface CurrencyAPIClient ()

@property (nonatomic, strong) NSOperationQueue *processingQueue;

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
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@", kOpenExchangeBaseURL, path, kOpenExchangeAppId]];
}

- (void)getCurrencies:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[[self class] APIURLByAddingPath:@"currencies.json"]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:self.processingQueue completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {
        if ([data length] > 0 && ! err) {
            NSError *parseError = nil;
            NSDictionary *currencies = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            
            if (currencies) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(currencies);
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

@end
