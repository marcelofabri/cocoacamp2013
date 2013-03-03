//
//  CurrencyHelper.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 03/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "CurrencyHelper.h"
#import "CurrencyAPIClient.h"

@implementation CurrencyHelper

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
    [components setHour:-2];
    
    NSDate *minDate = [calendar dateByAddingComponents:components toDate:date options:0];
    
    if (! attr || [[attr fileModificationDate] compare:minDate] == NSOrderedAscending) {
        [[CurrencyAPIClient sharedClient] getCurrencies:^(NSDictionary *currencies) {
            [currencies writeToFile:path atomically:YES];
            
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
@end
