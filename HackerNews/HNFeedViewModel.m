//
//  HNFeedViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

//View Model
#import "HNFeedViewModel.h"
#import "HNFeedCellViewModel.h"
#import "HNBrowserViewModel.h"

//Model
#import "HNDataManager.h"


@interface HNFeedViewModel () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) HNDataManager *dataManager;
@property (nonatomic, readwrite) RACSignal *updatedContentSignal;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation HNFeedViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        
        _dataManager = [HNDataManager sharedManager];
        
        self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"HNFeedViewModel updatedContentSignal"];
        
        @weakify(self)
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            [self requestTopPosts];
        }];
    }
    
    return self;
}

- (void)requestTopPosts {
    [[self.dataManager topPostsWithCount:30] subscribeNext:^(id x) {
        [self.fetchedResultsController performFetch:nil];
    }];
}



- (HNFeedCellViewModel *)feedCellViewModelForIndexPath:(NSIndexPath *)indexPath {
    
    HNFeedCellViewModel *viewModel = [[HNFeedCellViewModel alloc]initWithStory:[self storyForIndexPath:indexPath]];
    return viewModel;
}

- (HNBrowserViewModel *)browserViewModelForIndexPath:(NSIndexPath *)indexPath {
//    HNPost *selectedPost =  self.dataManager.posts[indexPath.row];
//    return [[HNBrowserViewModel alloc]initWithPost:selectedPost];
    return nil;
}

#pragma mark - Public Methods

-(NSInteger)numberOfSections {
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

#pragma mark - Private Methods

- (HNStory *)storyForIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:@"HNStory" inManagedObjectContext:self.dataManager.coreDataStack.managedObjectContext];
    fetchRequest.fetchBatchSize = 30;
    
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
