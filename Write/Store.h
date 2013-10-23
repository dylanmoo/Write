//
//  Store.h
//  Raft
//
//  Created by Dylan Moore on 6/9/13.
//  Copyright (c) 2013 Raft. All rights reserved.
//

@class Sentence;
@class Tag;

#import <AssetsLibrary/AssetsLibrary.h>

@interface Store : NSObject {
    //@public NSManagedObjectContext *context;
    //    NSManagedObjectModel *model;
}

+ (Store *)sharedStore;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundWritingContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundOpContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundNewContentContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainContext;

-(void)saveContext;

-(void)addNote:(NSString*)note;

@end
