//
//  Cashier.h
//
//
//  Created by Kasper Welner on 8/29/12.
//  Copyright (c) 2012 Nodes. All rights reserved.


#import <UIKit/UIKit.h>

static NSTimeInterval const CashierDateNotFound = 0;

/**
 
 Cashier caches objects using key-value coding.
 
 Always use either:
 
     + (id)defaultCache
 
 or
 
     + (id)cacheWithId:(NSString *)cacheID
 
 to get/create a cache.
 
 NOTE: If persistent caching is enabled (it is by default),
 you have to make sure that any collections you cache only contain
 objects conforming to the NSCoding protocol.
 
 Use the `lifespan` parameter to make time-limited caching. You can set it on a
 per-cache basis.
 */
@interface Cashier : NSObject

#pragma mark - Properties

/**
 *  The id of the current Cashier object.
 */
@property (nonatomic, retain)NSString *id;


/**
 * A boolean that determines if the current cache is persistent.
 *
 * If `persistent` is false, the objects will be cached in memory, using an NSCache. 
 *
 * If `persistent` is true, the objects will be written to a file in the Library/Caches folder. 
 * This means that its contents are not backed up by iTunes and may be deleted by the system.
 * Read more about the [iOS file system](https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html)
 *
 * `persistent` is true by default.
 */
@property (atomic, assign)BOOL persistent;


/**
 * A boolean that determines if the contents of the current cache are written to a protected file.
 *
 * If `encryptionEnabled` is false, the file that the cached objects are written to will be written using 
 * [NSDataWritingFileProtectionComplete](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSData_Class/index.html#//apple_ref/c/tdef/NSDataWritingOptions).
 *
 * If `encryptionEnabled` is false, the file that the cached objects are written to will not be protected
 *
 * `encryptionEnabled` is false by default.
 */
@property (atomic, assign)BOOL encryptionEnabled;

/**
 *  The lifespan of the current cache. If the cached objects are older than the cache's lifespan, they will 
 *  be considere expired. Expired objects are considered invalid, but they are not deleted. 
 *  Set the `returnsExpiredData` to true if you want to also use expired data.
 *  `lifespan` is 0 by default, which means that the data won't ever expire.
 */
@property (atomic, assign)NSTimeInterval lifespan;

/**
 *  A boolean that determines if the contents of the current cache are returned even though they're expired.
 *  `returnExpiredData` is true by default
 */
@property (atomic, assign)BOOL returnsExpiredData;


/**
 *  A boolean that determines if the contents of the current cache persist across app version updates.
 *  `persistsCacheAcrossVersions` is false by default. This is because if a model changes, the app can crash
 *  if it gets old data from the cache and it's expecting it to look differently.
 */
@property (nonatomic, assign)BOOL persistsCacheAcrossVersions;

#pragma mark - Cache creation and access
/**
 *  Returns the default cache. This is the easiest way to create and access a cache. If the default cache wasn't 
 *  created before, this method creates it and returns it. Otherwise, it returns the previously created default cache.
 *
 *  @return The default Cashier object
 */
+ (instancetype)defaultCache;

/**
 *  Returns a cache object with the `cachedID` id. If the cache with the `cacheID` id wasn't created before,
 *  this method creates it and returns it.
 *
 *  @param cacheID the id of the cache
 *
 *  @return A Cashier with the specified id.
 */
+ (instancetype)cacheWithId:(NSString *)cacheID;

#pragma mark - Adding data to cache

/**
 *  Sets the value of the specified key in the cache
 *
 *  @warning For caching images, use the `setImage:forKey:` method.
 *  @warning For caching NSData, use the `setData:forKey:` method.
 *  @param object The object to be stored in the cache
 *  @param key    The key with which to associate the value
 */
- (void)setObject:(id)object forKey:(NSString *)key;


/**
 *  Sets the image value of the specified key in the cache.
 *
 *  @param image The UIImage to be stored in the cache
 *  @param key   The key with wich to associate the image
 */
- (void)setImage:(UIImage *)image forKey:(NSString *)key;


/**
 *  Sets the data value of the specified key in the cache.
 *
 *  @param data The NSData to be stored in the cache
 *  @param key   The key with wich to associate the image
 */
- (void)setData:(NSData *)data forKey:(NSString *)key;

#pragma mark - Reading data from cache

/**
 *  Returns the value associated with a given key.
 *
 *  @param key An object identifying the value.
 *
 *  @return The value associated with key, or nil if no value is associated with key.
 */
- (id)objectForKey:(NSString *)key;


/**
 *  Returns the image value associated with a given key.
 *
 *  @param key An object identifying the value.
 *
 *  @return The UIImage value associated with key, or nil if no value is associated with key.
 */
- (UIImage *)imageForKey:(NSString *)key;


/**
 *  Returns the data value associated with a given key.
 *
 *  @param key An object identifying the value.
 *
 *  @return The NSData value associated with key, or nil if no value is associated with key.
 */
- (NSData *)dataForKey:(NSString *)key;


/**
 *  Returns the dictionary value associated with a given key.
 *
 *  @param key An object identifying the value.
 *
 *  @return The NSDictionary value associated with key, or nil if no value is associated with key.
 */
- (NSDictionary *)dictForKey:(NSString *)key;


/**
 *  Returns the array value associated with a given key.
 *
 *  @param key An object identifying the value.
 *
 *  @return The NSArray value associated with key, or nil if no value is associated with key.
 */
- (NSArray *)arrayForKey:(NSString *)key;


/**
 *  Returns the dictionary value associated with a given key.
 *
 *  @param key An object identifying the value.
 *
 *  @return The NSDictionary value associated with key, or nil if no value is associated with key.
 */
- (NSDictionary *)dictionaryForKey:(NSString *)key;


/**
 *  Returns the value associated with a given key.
 *
 *  @param key An object identifying the value.
 *
 *  @return The value associated with key, or nil if no value is associated with key.
 */
- (NSString *)stringForKey:(NSString *)key;

#pragma mark - Removing data from cache

/**
 *  Clears all the data from the cache.
 */
- (void)clearAllData;


/**
 *  Removes the value associated with the given key.
 *
 *  @param key An object identifying the value that will be removed.
 */
- (void)deleteObjectForKey:(NSString *)key;

#pragma mark - Cached data validation

/**
 *  Checks if an object for the specified key is valid. This means that the object exists in 
 *  the cache and is not expired
 *
 *  @param key An object identifying the value.
 *
 *  @return `YES` if an object exists for the specified key and the object isn't expired. `NO` oherwise.
 */
- (BOOL)objectForKeyIsValid:(NSString *)key;


/**
 *  Updates the validation timestamp to current timestamp for the object at the specified key.
 *
 *  @param key An object identifying the value that will have its validation timestamp updated
 */
- (void)refreshValidationOnObjectForKey:(NSString *)key;


/**
 *  Returns the current validation timestamp of the object at the specified key. This is the timestamp
 *  when the object was last updated in cache or it was explicitly re-validated using the 
 *  `refershValidationOnObjectForKey:` method
 *
 *  @param key An object identifying the value
 *
 *  @return The timestamp of the last update of the object corresponding to the specified key, 
 *  as the `timeIntervalSince1970` for the date when the object was last updated.
 */
- (NSTimeInterval)lastUpdateTimeForKey:(NSString *)key;



@end
