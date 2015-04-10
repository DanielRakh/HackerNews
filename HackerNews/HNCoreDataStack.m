//
//  HNCoreDataStack.m
//  HackerNews
//
//  Created by Daniel on 4/7/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCoreDataStack.h"

@interface HNCoreDataStack ()

@property (readwrite, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation HNCoreDataStack


- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSURL *modelURL = [bundle URLForResource:@"HNPostModel" withExtension:@"momd"];
        
        _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:_managedObjectModel];
        
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
        
        NSURL *documentsURL = [self applicationDocumentsDirectory];
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"HNPostModel"];
        
        NSError *error = nil;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption : @(YES)} error:&error]) {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    
    return self;
}

- (NSURL *)applicationDocumentsDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return urls[0];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data Deleting

- (void)clearAllDataForEntity:(NSString *)nameEntity {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [self.managedObjectContext deleteObject:object];
    }
    
    error = nil;
    [self.managedObjectContext save:&error];
}



@end
