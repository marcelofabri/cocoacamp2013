//
//  CurrencyHelper.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 03/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "CurrencyHelper.h"
#import "CurrencyAPIClient.h"
#import "CurrencyMarketInfo.h"

// TODO: Store market info and currencies in memory too, so we don't need to reach disk every time.

// This class caches the JSONs responses in cache folder manually. This is made to not depend on API's cache policies to evict loading data all the time (and not reach the free requests limit)
@implementation CurrencyHelper

static const CGFloat kCurrenciesCacheDurationInMinutes = 30;
static const CGFloat kMarketInfoCacheDurationInMinutes = 30;

+ (instancetype) sharedHelper {
    static dispatch_once_t onceToken;
    static CurrencyHelper *_sharedHelper = nil;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[self alloc] init];
    });
    return _sharedHelper;
}

- (NSString *)applicationCacheDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)getCurrencies:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    NSString *path = [[self applicationCacheDirectory] stringByAppendingPathComponent:@"currencies.plist"];
    NSError *err = nil;
    NSDictionary *attr = [manager attributesOfItemAtPath:path error:&err];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:-kCurrenciesCacheDurationInMinutes];
    
    NSDate *minDate = [calendar dateByAddingComponents:components toDate:date options:0];
    
    if (! attr || [[attr fileModificationDate] compare:minDate] == NSOrderedAscending) { // is the cache too old or not exists?
        [[CurrencyAPIClient sharedClient] getCurrencies:^(NSDictionary *currencies) {
            [currencies writeToFile:path atomically:YES]; // caches the response on disk
            
            if (success) {
                success(currencies);
            }
        } failure:failure];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // so file I/O is not done in main queue
            NSDictionary *currencies = [NSDictionary dictionaryWithContentsOfFile:path];
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(currencies);
                });
            }
        });
    }
}

- (void)getCurrencyMarketInfo:(void (^)(CurrencyMarketInfo *))success failure:(void (^)(NSError *))failure {
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    NSString *path = [[self applicationCacheDirectory] stringByAppendingPathComponent:@"rates.plist"];
    NSError *err = nil;
    NSDictionary *attr = [manager attributesOfItemAtPath:path error:&err];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:-kMarketInfoCacheDurationInMinutes];
    
    NSDate *minDate = [calendar dateByAddingComponents:components toDate:date options:0];
    
    if (! attr || [[attr fileModificationDate] compare:minDate] == NSOrderedAscending) { // is the cache too old or not exists?
        [self getUpdatedCurrencyMarketInfo:success failure:failure];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // so file I/O is not done in main queue
            NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
            
            CurrencyMarketInfo *marketInfo = [CurrencyMarketInfo marketInfoWithTimeStamp:info[@"timestamp"]
                                                                            baseCurrency:info[@"base"] rates:info[@"rates"]];
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(marketInfo);
                });
            }
        });
    }
}

- (void)getUpdatedCurrencyMarketInfo:(void (^)(CurrencyMarketInfo *))success failure:(void (^)(NSError *))failure {
    NSString *path = [[self applicationCacheDirectory] stringByAppendingPathComponent:@"rates.plist"];
    
    [[CurrencyAPIClient sharedClient] getCurrencyMarketInfo:^(NSDictionary *info) {
        
        NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:[info[@"timestamp"] doubleValue]];
        
        NSMutableDictionary *updatedInfo = [info mutableCopy];
        updatedInfo[@"timestamp"] = timestamp;
        
        [updatedInfo writeToFile:path atomically:YES]; // caches the response on disk
        
        CurrencyMarketInfo *marketInfo = [CurrencyMarketInfo marketInfoWithTimeStamp:timestamp
                                                                        baseCurrency:info[@"base"] rates:info[@"rates"]];
        if (success) {
            success(marketInfo);
        }
    } failure:failure];
}
@end
