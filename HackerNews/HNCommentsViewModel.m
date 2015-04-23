//
//  HNCommentsViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <DateTools/NSDate+DateTools.h>
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
        _score = [NSString stringWithFormat:@"%@ Points", story.score_];
        _title = story.title_;
        _commentsCount = [self formattedStringForCommentsCount:story.descendants_];
        _info = [NSString stringWithFormat: @"by %@ | %@", story.by_, [self formattedStringForTime:story.time_]];
        
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
    
    NSPredicate *commentsPredicate =[NSPredicate predicateWithFormat:@"%K == %@", @"parent_", self.story.id_];
    fetchRequest.predicate = commentsPredicate;
    
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

#pragma mark - Helper Methods

- (NSString *)formattedStringForTime:(NSNumber *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.doubleValue];
    NSString *timeString = date.timeAgoSinceNow;
    return timeString;
}

- (NSString *)formattedStringForCommentsCount:(NSNumber *)commentsCount {
    
    NSString *commentsCountString;
    
    switch (commentsCount.integerValue) {
        case 0:
            commentsCountString = @"No Comments";
            break;
        case 1:
            commentsCountString = @"1 Comment";
            break;
        default:
            commentsCountString = [NSString stringWithFormat:@"%@ Comments", commentsCount];
            break;
    }
    return commentsCountString;
}

@end
