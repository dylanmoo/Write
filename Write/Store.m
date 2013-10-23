
//
//  Store.m
//  Raft
//
//  Created by Dylan Moore on 6/9/13.
//  Copyright (c) 2013 Raft. All rights reserved.
//


#import "WriteAppDelegate.h"
#import "Store.h"
#import "Sentence.h"
#import "Tag.h"

// To switch between production and development server base URLs

@implementation Store

@synthesize backgroundWritingContext = _backgroundWritingContext;
@synthesize mainContext = _mainContext;
@synthesize backgroundOpContext = _backgroundOpContext;
@synthesize backgroundNewContentContext = _backgroundNewContentContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark Initialization
+ (Store *)sharedStore
{
    static Store *store = nil;
    
    if (!store) {
        store = [[super allocWithZone:nil] init];
        
    }
    
    return store;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self initCoreDataStack];
        
        NSError *error2 = nil;
        if (![_backgroundWritingContext save:&error2]) {
            NSLog(@"Error Saving Core Data: init");
        }
        
        
    }
    
    return self;
}

-(void)initCoreDataStack{
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        // create MOC
        _backgroundWritingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundWritingContext setPersistentStoreCoordinator:coordinator];
        [_backgroundWritingContext setUndoManager:nil];
    }
    
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainContext.parentContext = _backgroundWritingContext;
    
    _backgroundOpContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _backgroundOpContext.parentContext = _mainContext;
    
    _backgroundNewContentContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _backgroundNewContentContext.parentContext = _mainContext;
    
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Write" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Write.sqlite"];
    
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
                                                             URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.backgroundWritingContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)addNote:(NSString *)note{
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = _mainContext;
    
    [temporaryContext performBlock:^{
        
        NSArray *stopWords = [[NSArray alloc] initWithObjects:@"  ", @"a", @"about", @"above", @"above", @"across", @"after", @"afterwards", @"again", @"against", @"all", @"almost", @"alone", @"along", @"already", @"also",@"although",@"always",@"am",@"among", @"amongst", @"amoungst", @"amount", @"an", @"and", @"another", @"any",@"anyhow",@"anyone",@"anything",@"anyway", @"anywhere", @"are", @"around", @"as", @"at", @"back",@"be",@"became", @"because",@"become",@"becomes", @"becoming", @"been", @"before", @"beforehand", @"behind", @"being", @"below", @"beside", @"besides", @"between", @"beyond", @"bill", @"both", @"bottom",@"but", @"by", @"call", @"can", @"cannot", @"cant", @"co", @"con", @"could", @"couldnt", @"cry", @"de", @"describe", @"detail", @"do", @"done", @"down", @"due", @"during", @"each", @"eg", @"eight", @"either", @"eleven",@"else", @"elsewhere", @"empty", @"enough", @"etc", @"even", @"ever", @"every", @"everyone", @"everything", @"everywhere", @"except", @"few", @"fifteen", @"fify", @"fill", @"find", @"fire", @"first", @"five", @"for", @"former", @"formerly", @"forty", @"found", @"four", @"from", @"front", @"full", @"further", @"get", @"give", @"go", @"had", @"has", @"hasnt", @"have", @"he", @"hence", @"her", @"here", @"hereafter", @"hereby", @"herein", @"hereupon", @"hers", @"herself", @"him", @"himself", @"his", @"how", @"however", @"hundred", @"ie", @"if", @"in", @"inc", @"indeed", @"interest", @"into", @"is", @"it", @"its", @"itself", @"keep", @"last", @"latter", @"latterly", @"least", @"less", @"ltd", @"made", @"many", @"may", @"me", @"meanwhile", @"might", @"mill", @"mine", @"more", @"moreover", @"most", @"mostly", @"move", @"much", @"must", @"my", @"myself", @"name", @"namely", @"neither", @"never", @"nevertheless", @"next", @"nine", @"no", @"nobody", @"none", @"noone", @"nor", @"not", @"nothing", @"now", @"nowhere", @"of", @"off", @"often", @"on", @"once", @"one", @"only", @"onto", @"or", @"other", @"others", @"otherwise", @"our", @"ours", @"ourselves", @"out", @"over", @"own",@"part", @"per", @"perhaps", @"please", @"put", @"rather", @"re", @"same", @"see", @"seem", @"seemed", @"seeming", @"seems", @"serious", @"several", @"she", @"should", @"show", @"side", @"since", @"sincere", @"six", @"sixty", @"so", @"some", @"somehow", @"someone", @"something", @"sometime", @"sometimes", @"somewhere", @"still", @"such", @"system", @"take", @"ten", @"than", @"that", @"the", @"their", @"them", @"themselves", @"then", @"thence", @"there", @"thereafter", @"thereby", @"therefore", @"therein", @"thereupon", @"these", @"they", @"thickv", @"thin", @"third", @"this", @"those", @"though", @"three", @"through", @"throughout", @"thru", @"thus", @"to", @"together", @"too", @"top", @"toward", @"towards", @"twelve", @"twenty", @"two", @"un", @"under", @"until", @"up", @"upon", @"us", @"very", @"via", @"was", @"we", @"well", @"were", @"what", @"whatever", @"when", @"whence", @"whenever", @"where", @"whereafter", @"whereas", @"whereby", @"wherein", @"whereupon", @"wherever", @"whether", @"which", @"while", @"whither", @"who", @"whoever", @"whole", @"whom", @"whose", @"why", @"will", @"with", @"within", @"without", @"would", @"yet", @"you", @"your", @"yours", @"yourself", @"yourselves", @"the", nil];
        
        NSDate *now = [NSDate date];
        
        
            
        
        
        NSArray *sentences = [note componentsSeparatedByCharactersInSet:
                              [NSCharacterSet newlineCharacterSet]];
        
        
        for(int i=0; i<sentences.count; i++){
            NSString *string = [sentences objectAtIndex:i];
            NSLog(@"%@",string);
            
            NSEntityDescription *entityDescription = [NSEntityDescription
                                                      entityForName:@"Sentence" inManagedObjectContext:temporaryContext];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDescription];
            
            [request setPredicate:[NSPredicate predicateWithFormat:@"sentence LIKE[c] %@", string]];
            [request setReturnsObjectsAsFaults:NO];
            
            NSError *Fetcherror;
            NSMutableArray *array = [[temporaryContext executeFetchRequest:request error:&Fetcherror] mutableCopy];
            
            Sentence *sentence;
            if (array.count == 1) {
                sentence = array[0];
                [sentence setUpdated_at:now];
                [sentence setSentence:string];
            }else{

            
            sentence = [NSEntityDescription insertNewObjectForEntityForName:@"Sentence" inManagedObjectContext:temporaryContext];
            [sentence setSentence:string];
            [sentence setCreated_at:now];
            [sentence setUpdated_at:now];
            
            NSArray *wordsInSentence = [string componentsSeparatedByCharactersInSet:
                                        [NSCharacterSet characterSetWithCharactersInString:@" "]];
            
            for(NSString *word in wordsInSentence){
                
                if(![stopWords containsObject:word]){
                    //Update tag
                    NSEntityDescription *entityDescription = [NSEntityDescription
                                                              entityForName:@"Tag" inManagedObjectContext:temporaryContext];
                    
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:entityDescription];
                    
                    [request setPredicate:[NSPredicate predicateWithFormat:@"word ==[c] %@", word]];
                    [request setReturnsObjectsAsFaults:NO];
                    
                    NSError *Fetcherror;
                    NSMutableArray *array = [[temporaryContext executeFetchRequest:request error:&Fetcherror] mutableCopy];
                    
                    Tag *tag;
                    if (array.count == 1) {
                        // Update tag with data from JSON
                        tag = array[0];
                        [tag setUpdated_at:now];
                        [tag setMentions:[NSNumber numberWithInt:(tag.mentions.intValue+1)]];
                        [tag addAppears_inObject:sentence];
                    }else{
                        //Create tag
                        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:temporaryContext];
                        [tag setCreated_at:now];
                        [tag setUpdated_at:now];
                        [tag setWord:word];
                        [tag setMentions:[NSNumber numberWithInt:1]];
                        [tag addAppears_inObject:sentence];
                        
                    }
                    
                    [sentence addTagsObject:tag];
                }
            }
            
        }
        }
        
        
        
        // push to parent
        NSError *error;
        if (![temporaryContext save:&error])
        {
            // handle error
        }
        
        // save parent to disk asynchronously
        [_mainContext performBlock:^{
            NSError *error;
            if (![_mainContext save:&error])
            {
                // handle error
                NSLog(@"Error Saving Core Data on main context: new note");
            }
            
            [_backgroundWritingContext performBlock:^{
                NSError *error = nil;
                if (![_backgroundWritingContext save:&error]) {
                    NSLog(@"Error Saving Core Data on background writing context: new note");
                }
            }];
            
        }];

    }];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end




