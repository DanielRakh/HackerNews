//
//  HNCommentsViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

// View Model
#import "HNCommentsViewModel.h"


// Model
#import "HNDataManager.h"

@interface HNCommentsViewModel () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) HNDataManager *dataManager;
@property (nonatomic, readwrite) RACSignal *updatedContentSignal;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end


@implementation HNCommentsViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        
        _dataManager = [HNDataManager sharedManager];
        
        self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"HNCommentsViewModel updatedContentSignal"];
        
        @weakify(self)
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            [self requestTopComments];
        }];
    }
    
    return self;
}


- (void)requestTopComments {
    //
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:@"HNComment" inManagedObjectContext:self.dataManager.coreDataStack.managedObjectContext];
    fetchRequest.fetchBatchSize = 0;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"by_" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSFetchedResultsController *aFRC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.dataManager.coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFRC.delegate = self;
    self.fetchedResultsController = aFRC;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


#pragma mark - Fetched

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [(RACSubject *)self.updatedContentSignal sendNext:nil];
}



@end
