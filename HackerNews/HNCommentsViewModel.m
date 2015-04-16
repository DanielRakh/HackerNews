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
#import "HNCommentsCellViewModel.h"


// Model
#import "HNDataManager.h"
#import "HNComment.h"
#import "HNStory.h"



@interface HNCommentsViewModel () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) HNDataManager *dataManager;
@property (nonatomic) HNStory *story;
@property (nonatomic, readwrite) RACSignal *updatedContentSignal;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end


@implementation HNCommentsViewModel

-(instancetype)initWithStory:(HNStory *)story {
    self = [super init];
    if (self) {
        
        _story = story;
        _dataManager = [HNDataManager sharedManager];
        
        self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"HNCommentsViewModel updatedContentSignal"];
        
        @weakify(self)
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            [self requestTopCommentsForItem:(HNItem *)story];
        }];
    }
    
    return self;
}


- (void)requestTopCommentsForItem:(HNItem *)item {
    [[self.dataManager commentsForItem:item] subscribeNext:^(id x) {
        [self.fetchedResultsController performFetch:nil];

    }];
}

- (HNCommentsCellViewModel *)commentsCellViewModelForIndexPath:(NSIndexPath *)indexPath {
    HNCommentsCellViewModel *viewModel = [[HNCommentsCellViewModel alloc]initWithComment:[self commentForIndexPath:indexPath]];
    return viewModel;
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

- (HNComment *)commentForIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:@"HNComment" inManagedObjectContext:self.dataManager.coreDataStack.managedObjectContext];
    
//    NSPredicate *commentsPredicate =[NSPredicate predicateWithFormat:@"ANY parent_ == %@", self.story.id_];
//    fetchRequest.predicate = commentsPredicate;
    
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
