//
//  NOCache.m
//  NOCore
//
//  Created by Kasper Welner on 8/29/12.
//  Copyright (c) 2012 Nodes. All rights reserved.
//

#import "NOCache.h"
//#import "NSString+URLEncode.h"
//#import "NOVersionManager.h"
#import "NSString+MD5Addition.h"

@interface NSString (InternalURLEncoding)
- (NSString *)StringByURLEncoding;
@end

@implementation NSString (InternalURLEncoding)

- (NSString *)StringByURLEncoding;
{
    NSString *encodedString = [self stringByReplacingOccurrencesOfString:@"•" withString:@"-"];
    
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"€" withString:@"Euro"];
    
    CFStringRef encodedCFString = (__bridge CFStringRef)encodedString;
    
    CFStringRef returnCFString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                         encodedCFString,
                                                                         NULL,
                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                         kCFStringEncodingISOLatin1 );
    
    NSString *returnString = (__bridge_transfer NSString *)returnCFString;
    
    return returnString;
    
}

@end

@interface NOCache()
@property (atomic, strong)NSMutableDictionary *creationDates;
@end

static NSMutableDictionary *sharedInstances;
static NSString * const kCreationDatesKey = @"CreationDate";
static NSString * const kPropertiesKey = @"Properties";

@implementation NOCache
{
    NSMutableDictionary *properties;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setStoragePath:[self.class baseSaveDirectory]];
        self.memoryCache = [[NSCache alloc] init];
        self.persistent = YES;
        self.returnsExpiredData = YES;
        
#ifndef WATCH
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emptyCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
#endif
    }
    
    return self;
}

- (void)emptyCache
{
    if( self.memoryCache ) {
        NSLog(@"NOCACHE REMOVING MEMORY");
        [self.memoryCache removeAllObjects];
    }
}

- (void)dealloc
{
#ifndef WATCH
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
#endif
}

+ (NSString *)baseSaveDirectory
{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"NOCache"];
}


+ (instancetype)defaultCache
{
    return [self cacheWithId:@"INTERNAL_DEFAULT_CACHE"];
}

+ (instancetype)cacheWithId:(NSString *)cacheID
{
    if (cacheID == nil)
        return nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstances = [NSMutableDictionary dictionaryWithCapacity:2];
    });
    
    NOCache *requestedCacheInstance;
    
    @synchronized (self)
    {
        requestedCacheInstance = [sharedInstances objectForKey:cacheID];
        
        if (requestedCacheInstance == nil)
        {
            requestedCacheInstance = [[self alloc] init];
            requestedCacheInstance.id = cacheID;
            
            if (![NSString instancesRespondToSelector:@selector(StringByURLEncoding)] ) {
                @throw [NSException exceptionWithName:@"NOCore fatal error" reason:@"********* \n PLEASE ADD THESE FLAGS: \n\"-lz -lsqlite3.0 -ObjC -all_load\" \nto \n\"Other Linker Flags\" in project settings. \n\n Quitting now! \n\n *********"  userInfo:nil];
            }
            NSString *idDir  = [requestedCacheInstance.id StringByURLEncoding];
            NSString *dirPath = [requestedCacheInstance.storagePath stringByAppendingPathComponent:idDir];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *cacheVersion = [userDefaults objectForKey:[@"NOCACHE_VER_" stringByAppendingString:cacheID]];
            NSString *appCurrentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
            {
                [self createDirectoryAtPath:dirPath];
                [requestedCacheInstance updateSystemVersion];
                
            } else if ( cacheVersion != nil && [self isVersion:appCurrentVersion greaterThanVersion:cacheVersion] ) {
                
                NSNumber *savedPersistsCacheAcrossVersions = [[NSUserDefaults standardUserDefaults] objectForKey:[@"NOCACHE_PERSISTS_VER_" stringByAppendingString:cacheID]];
                if (savedPersistsCacheAcrossVersions != nil) {
                    [requestedCacheInstance setValue:savedPersistsCacheAcrossVersions forKey:@"persistsCacheAcrossVersions"];
                }
                
                if ( requestedCacheInstance.persistsCacheAcrossVersions == NO ) {
                    NSError *error;
                    
                    [[NSFileManager defaultManager] removeItemAtPath:dirPath error:&error];
                    if (error != nil) {
                        NSLog(@"Error! Couldn't delete directory: %@ (deletion because system version increased) ", error.localizedDescription);
                    } else {
                        NSLog(@"Deleting cache because version number incremented");
                    }
                    
                    [self createDirectoryAtPath:dirPath];
                    [requestedCacheInstance updateSystemVersion];
                }
            }
            
            [requestedCacheInstance loadCreationDates];
            [requestedCacheInstance loadProperties];
            [requestedCacheInstance addKVO];
            [sharedInstances setObject:requestedCacheInstance forKey:cacheID];
            
            
        }
    }
    
    return requestedCacheInstance;
}

+ (void)createDirectoryAtPath:(NSString *)path
{
    NSError *error;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error != nil) {
        NSLog(@"Error! Couldn't create directory: %@", error.localizedDescription);
    }
}

- (void)updateSystemVersion
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:[@"NOCACHE_VER_" stringByAppendingString:self.id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadProperties
{
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:[self URLEncodedFilenameFromString:kPropertiesKey]];
    
    if (dict) {
        properties = dict.mutableCopy;
        
        NSValue *savedLifeSpan = [properties objectForKey:@"lifespan"];
        if (savedLifeSpan != nil) {
            [self setValue:savedLifeSpan forKey:@"lifespan"];
        }
        
        NSNumber *savedRuturnsExpData = [properties objectForKey:@"returnsExpiredData"];
        if (savedRuturnsExpData != nil) {
            [self setValue:savedRuturnsExpData forKey:@"returnsExpiredData"];
        }
        
        NSNumber *savedEncryptionEnabled = [properties objectForKey:@"encryptionEnabled"];
        if (savedEncryptionEnabled != nil) {
            [self setValue:savedEncryptionEnabled forKey:@"encryptionEnabled"];
        }
        
        NSNumber *savedIsPersistent = [properties objectForKey:@"persistent"];
        if (savedIsPersistent != nil) {
            [self setValue:savedIsPersistent forKey:@"persistent"];
        }
        
    } else {
        properties = [NSMutableDictionary dictionaryWithCapacity:1];
    }
}

- (void)addKVO
{
    [self addObserver:self
           forKeyPath:@"lifespan"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
              context:nil];
    [self addObserver:self
           forKeyPath:@"returnsExpiredData"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
              context:nil];
    [self addObserver:self
           forKeyPath:@"encryptionEnabled"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
              context:nil];
    [self addObserver:self
           forKeyPath:@"persistent"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
              context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [properties setValue:change[NSKeyValueChangeNewKey] forKey:keyPath];
    [self setCodableObject:properties forKey:kPropertiesKey];
}

- (void)setPersistsCacheAcrossVersions:(BOOL)persistsCacheAcrossVersions
{
    [[NSUserDefaults standardUserDefaults] setObject:@(persistsCacheAcrossVersions) forKey:[@"NOCACHE_VER_" stringByAppendingString:self.id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _persistsCacheAcrossVersions = persistsCacheAcrossVersions;
}

#pragma mark - Expiration methods

- (void)loadCreationDates
{
    NSDictionary *dict = [self dictForKey:kCreationDatesKey];
    if (dict) {
        self.creationDates = dict.mutableCopy;
    } else {
        self.creationDates = [NSMutableDictionary dictionaryWithCapacity:1];
    }
}

- (BOOL)objectForKeyIsValid:(NSString *)key
{
    BOOL objectExists = NO;
    if ( [self.memoryCache objectForKey:key] != nil ) {
        objectExists = YES;
    } else if ( [self dataForKey:key useMemoryCache:NO] != nil ) {
        objectExists = YES;
    }
    
    if ( objectExists == NO ) {
        return NO;
    }
    
    return [self internalObjectForKeyIsValid:key];
}

- (BOOL)internalObjectForKeyIsValid:(NSString *)key //For internal use. Doesn't check if object actually exists (this is done in the calling method).
{
    if (self.lifespan == 0 ) {
        return YES;
    }
    
    NSTimeInterval timeStamp = [self lastUpdateTimeForKey:key];
    
    if ([[NSDate date] timeIntervalSince1970] < timeStamp + self.lifespan) {
        return YES;
    }
    
    return NO;
}

- (NSTimeInterval)lastUpdateTimeForKey:(NSString *)key
{
    NSDate *date = [self.creationDates objectForKey:key];
    
    if (date) {
        return date.timeIntervalSince1970;
    }
    
    return NOCacheDateNotFound;
}

- (void)refreshValidationOnObjectForKey:(NSString *)key
{
    @synchronized(self) {
        
        [self.creationDates setObject:[NSDate date] forKey:key];
        if (self.persistent) {
            [self setObject:self.creationDates forKey:kCreationDatesKey];
        }
        
    }
}

#pragma mark - Tools

- (NSString *)URLEncodedFilenameFromString:(NSString *)string
{
    NSString *dir = [self.id StringByURLEncoding];
    
    NSString *filename = [[string StringByURLEncoding] stringFromMD5];
    
    return [[self.storagePath stringByAppendingPathComponent:dir] stringByAppendingPathComponent:filename];
}

#pragma mark - Getters and setters

- (void)setObject:(id)object forKey:(NSString *)key
{
    if ( object == nil ) {
        [self deleteObjectForKey:key];
        return;
    }
    
    if (self.persistent)
    {
        if ([object isKindOfClass:[UIImage class]])
        {
            @throw [NSException exceptionWithName:@"NOCache error!!" reason:@"You are using - (void)setObject:ForKey: with a UIImage. Please use - (void)setImage:ForKey:. Use -(void)imageForKey: to retrieve it." userInfo:nil];
        }
        else if ([object respondsToSelector:@selector(writeToFile:options:error:)])
        {
            [self setWritableObject:object forKey:key useMemoryCache:YES];
        }
        else if ([object conformsToProtocol:NSProtocolFromString(@"NSCoding")])
        {
            [self setCodableObject:object forKey:key];
        }
        else
        {
            [self.memoryCache setObject:object forKey:key];
            NSLog(@"NOCache: Error! Object: %@ is not supported for persistent caching! Object only cached in memory.", object);
        }
    } else {
        [self.memoryCache setObject:object forKey:key];
        [self refreshValidationOnObjectForKey:key];
    }
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [self.memoryCache setObject:image forKey:key];
    
    if (self.persistent) {
        [self setObject:@(image.scale) forKey:[key stringByAppendingString:@"_scl_"]];
        [self setObject:@(image.imageOrientation) forKey:[key stringByAppendingString:@"_orientation_"]];
        [self setWritableObject:UIImagePNGRepresentation(image) forKey:key useMemoryCache:NO];
    }
}

- (void)setData:(NSData *)data forKey:(NSString *)key
{
    [self setData:data forKey:key useMemoryCache:YES];
}

- (void)setData:(NSData *)data forKey:(NSString *)key useMemoryCache:(BOOL)useMemoryCache
{
    if (useMemoryCache) {
        [self.memoryCache setObject:data forKey:key];
    }
    
    [self setWritableObject:data forKey:key useMemoryCache:NO];
}

- (void)setWritableObject:(id)object forKey:(NSString *)key useMemoryCache:(BOOL)useMemoryCache
{
    if (useMemoryCache) {
        [self.memoryCache setObject:object forKey:key];
    }
    
    NSDataWritingOptions writeOptions = 0;
    
    if (self.encryptionEnabled) {
        writeOptions = NSDataWritingFileProtectionComplete | NSDataWritingAtomic;
    }
    
    NSError *error;
    
    NSURL *fileURL = [NSURL fileURLWithPath:[self URLEncodedFilenameFromString:key]];
    
    BOOL succes = [(NSData *)object writeToFile:[self URLEncodedFilenameFromString:key]
                                        options:writeOptions
                                          error:&error];
    
     [self fileURLWillBeWritten:fileURL];
    
    if (!succes) {
        NSLog(@"Failed to write object of type: %@ \n for key: %@ \n filename: %@ \n reason: %@", [object class], key, [self URLEncodedFilenameFromString:key], error.localizedDescription);
    } else {
        if (![key isEqualToString:kCreationDatesKey]) {
            [self refreshValidationOnObjectForKey:key];
        }
    }
}

- (void)fileURLWillBeWritten:(NSURL *)url
{}

- (void)setCodableObject:(id <NSCoding>)object forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self setData:data forKey:key useMemoryCache:NO];
    [self.memoryCache setObject:object forKey:key];
}


- (id)objectForKey:(NSString *)key
{
    id object = [self.memoryCache objectForKey:key];
    
    if (![self internalObjectForKeyIsValid:key] && !self.returnsExpiredData) {
        return nil;
    }
    
    if (object == nil && self.persistent)
    {
        @try {
            object = [NSKeyedUnarchiver unarchiveObjectWithFile:[self URLEncodedFilenameFromString:key]];
        }
        @catch (NSException *exception) {
            object = [self dataForKey:key useMemoryCache:NO];
        }
        
        if (object != nil) {
            [self.memoryCache setObject:object forKey:key];
        }
    }
    
    return object;
}

- (UIImage *)imageForKey:(NSString *)key
{
    if (![self internalObjectForKeyIsValid:key] && !self.returnsExpiredData) {
        return nil;
    }
    
    UIImage *image = [self.memoryCache objectForKey:key];
    
    if (image == nil && self.persistent) {
        
        image = [UIImage imageWithData:[self dataForKey:key useMemoryCache:NO]];
        
        if (image) {
            NSNumber *savedScale = [self objectForKey:[key stringByAppendingString:@"_scl_"]];
            NSNumber *savedOrientation = [self objectForKey:[key stringByAppendingString:@"_orientation_"]];
            
            if (savedScale) {
                image = [UIImage imageWithCGImage:image.CGImage scale:savedScale.floatValue orientation:savedOrientation.intValue];
            }
            [self.memoryCache setObject:image forKey:key];
        }
    }
    
    return image;
}

- (NSData *)dataForKey:(NSString *)key
{
    return [self dataForKey:key useMemoryCache:YES];
}

- (NSData *)dataForKey:(NSString *)key useMemoryCache:(BOOL)useMemoryCache
{
    if (![self internalObjectForKeyIsValid:key] && !self.returnsExpiredData) {
        return nil;
    }
    
    id object = nil;
    
    if (useMemoryCache) {
        object = [self.memoryCache objectForKey:key];
    }
    
    if (object == nil  && self.persistent) {
        object = [NSData dataWithContentsOfFile:[self URLEncodedFilenameFromString:key]];
        
        if (object && useMemoryCache) {
            [self.memoryCache setObject:object forKey:key];
        }
    }
    return object;
}

- (NSDictionary *)dictForKey:(NSString *)key
{
    return [self objectForKey:key];
}

- (NSArray *)arrayForKey:(NSString *)key
{
    return [self objectForKey:key];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key;
{
    return [self objectForKey:key];
}


- (NSString *)stringForKey:(NSString *)key
{
    NSString *string = [self.memoryCache objectForKey:key];
    
    if (string == nil && self.persistent) {
        
        NSData *data = [self dataForKey:key useMemoryCache:NO];
        
        if (data) {
            
            string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            if (string) {
                [self.memoryCache setObject:string forKey:key];
            }
        }
    }
    
    return string;
}

- (void)deleteObjectForKey:(NSString *)key
{
    [self.memoryCache removeObjectForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:[self URLEncodedFilenameFromString:key] error:nil];
}


- (void)clearAllData
{
    [self.memoryCache removeAllObjects];
    
    NSString *dir = [self.storagePath stringByAppendingPathComponent:[self.id StringByURLEncoding]];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator* en = [fm enumeratorAtPath:dir];
    NSError* err = nil;
    BOOL res;
    
    NSString* file;
    while (file = [en nextObject]) {
        res = [fm removeItemAtPath:[dir stringByAppendingPathComponent:file] error:&err];
        if (!res && err) {
            NSLog(@"Error deleting file %@", err);
        }
    }
}

#pragma mark - Version stuff

static NSInteger maxValues = 3;

+ (BOOL)isVersion:(NSString *)versionA greaterThanVersion:(NSString *)versionB
{
    if ( versionA == nil || versionB == nil ) {
        return NO;
    }
    
    NSArray *versionAArray = [versionA componentsSeparatedByString:@"."];
    maxValues = versionAArray.count;
    versionAArray = [self normalizedValuesFromArray:versionAArray];
    
    NSArray *versionBArray = [versionB componentsSeparatedByString:@"."];
    versionBArray = [self normalizedValuesFromArray:versionBArray];
    
    for (NSInteger i=0; i<maxValues; i++) {
        if ([[versionAArray objectAtIndex:i] integerValue]>[[versionBArray objectAtIndex:i] integerValue]) {
            return TRUE;
        } else if ([[versionAArray objectAtIndex:i] integerValue]<[[versionBArray objectAtIndex:i] integerValue]) {
            return FALSE;
        }
    }
    return FALSE;
}

+ (NSArray *)normalizedValuesFromArray:(NSArray *)array{
    NSMutableArray *mutableArray = [array mutableCopy];
    if([mutableArray count]<maxValues){
        NSInteger difference = maxValues-[mutableArray count];
        for (NSInteger i=0; i<difference; i++) {
            [mutableArray addObject:@"0"];
        }
        return [[NSArray alloc] initWithArray:mutableArray];
    } else {
        return array;
    }
}

@end