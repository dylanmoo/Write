//
//  WriteMasterViewController.h
//  Write
//
//  Created by Dylan Moore on 10/22/13.
//  Copyright (c) 2013 Dylan Moore. All rights reserved.
//

@class Tag;
@class Sentence;

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface WriteMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
