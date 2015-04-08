//
//  HNCoreDataStack.h
//  HackerNews
//
//  Created by Daniel on 4/7/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface HNCoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;

@end
