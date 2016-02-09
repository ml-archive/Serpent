//
//  NOCache.h
//  NOCore
//
//  Created by Kasper Welner on 8/29/12.
//  Copyright (c) 2012 Nodes. All rights reserved.

/* ============= */
/* Version 1.0.6 */
/* ============= */

//  This class caches objects using key-value coding.
//
//  Always use either:
//  + (id)defaultCache
//  or
//  + (id)cacheWithId:(NSString *)cacheID
//  to get/create a cache.
//
//  NOTE: If persistent caching is enabled (it is by default),
//  you have to make sure that any collections you cache only contains
//  objects conforming to the NSCoding protocol. 
//
//  Use the lifespan parameter to make time-limited caching. You can set it on a
//  per-cache basis.
//

#import <UIKit/UIKit.h>
//#import "NSString+URLEncode.h"

static NSTimeInterval const NOCacheDateNotFound = 0;

@interface NOCache : NSObject

@property (nonatomic, retain)NSString *storagePath;
@property (nonatomic, retain)NSString *id;
@property (nonatomic, strong)NSCache *memoryCache;
@property (atomic, assign)BOOL persistent; //Default: YES
@property (atomic, assign)BOOL encryptionEnabled; //Default: NO
@property (atomic, assign)NSTimeInterval lifespan; //Default: 0 = Infinite
@property (atomic, assign)BOOL returnsExpiredData; //Default: YES
@property (nonatomic, assign)BOOL persistsCacheAcrossVersions; //Default: NO

+ (instancetype)defaultCache;
+ (instancetype)cacheWithId:(NSString *)cacheID;

- (void)clearAllData;

- (void)setObject:(id)object forKey:(NSString *)key;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (void)setData:(NSData *)data forKey:(NSString *)key;

- (id)objectForKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;
- (NSDictionary *)dictForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;

- (BOOL)objectForKeyIsValid:(NSString *)key;

- (void)refreshValidationOnObjectForKey:(NSString *)key;

- (NSTimeInterval)lastUpdateTimeForKey:(NSString *)key;

- (void)deleteObjectForKey:(NSString *)key;

@end
