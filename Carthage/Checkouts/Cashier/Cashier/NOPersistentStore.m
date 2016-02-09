//
//  CICache.m
//  CityGuides
//
//  Created by Jakob Mygind on 03/09/14.
//  Copyright (c) 2014 Nodes. All rights reserved.
//

#import "NOPersistentStore.h"

@implementation NOPersistentStore

+ (NSString *)baseSaveDirectory
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"NOCache"];
}

- (void)fileURLWillBeWritten:(NSURL *)url
{
    NSError *error;
    [url setResourceValue:@YES forKey: NSURLIsExcludedFromBackupKey error:&error];

    if ( error ) {
        NSLog(@"What?? %@", error);
    }
}

+ (instancetype)defaultCache
{
    return [self cacheWithId:@"INTERNAL_PERSISTENT_DEFAULT_CACHE"];
}

- (BOOL)persistsCacheAcrossVersions
{
    return YES;
}

@end
