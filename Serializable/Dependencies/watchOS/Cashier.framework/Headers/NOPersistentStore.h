//
//  CICache.h
//  CityGuides
//
//  Created by Jakob Mygind on 03/09/14.
//  Copyright (c) 2014 Marcus Waring. All rights reserved.
//

#import "Cashier.h"

/**
 
 NOPersistentStore is a special type of Cashier. On the outside, it works exactly the 
 same as a Cashier, but unlike the Cashier, it saves the cached objects in a folder 
 that doesn't get cleared by the system when the device runs out of space.
 
 */
@interface NOPersistentStore : Cashier

@end
