//
//  CoreDataDelegate.m
//  Kaliido
//
//  Created by Vadim Budnik on 06/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "CoreDataDelegate.h"

@implementation CoreDataDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (CoreDataDelegate*)sharedDelegate
{
    static CoreDataDelegate *_sharedDelegate=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedDelegate==nil)
        {
            _sharedDelegate=[[CoreDataDelegate alloc] init];
        }
    });
    
    return _sharedDelegate;
}

#pragma mark -
#pragma mark Save Context


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)saveContext
{
    NSError *error = nil;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    NSLog(@"Save master context");
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        
        [[_managedObjectContext undoManager] disableUndoRegistration];
        [_managedObjectContext setUndoManager:nil];
    }
    
    return _managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSString *strSQLiteFileName = @"Channels.sqlite";
    NSLog(@"CoreData initialized : %@", strSQLiteFileName);
    NSString *_applicationDirectory=[self applicationDocumentsDirectory];
    NSURL *storeUrl = [NSURL fileURLWithPath:[_applicationDirectory stringByAppendingPathComponent:strSQLiteFileName]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Custom Methods

/**
 Returns the next available maximum number for the auto-incremental primary key.
 */

+(NSNumber *)nextAvailble:(NSString *)idKey forEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *moc = context;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    
    [request setEntity:entity];
    
    NSArray *propertiesArray = [[NSArray alloc] initWithObjects:idKey, nil];
    [request setPropertiesToFetch:propertiesArray];
    propertiesArray = nil;
    
    NSSortDescriptor *indexSort = [[NSSortDescriptor alloc] initWithKey:idKey ascending:YES];
    NSArray *array = [[NSArray alloc] initWithObjects:indexSort, nil];
    [request setSortDescriptors:array];
    array = nil;
    indexSort = nil;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    // NSSLog(@"Autoincrement fetch results: %@", results);
    NSManagedObject *maxIndexedObject = [results lastObject];
    request = nil;
    if (error) {
        NSLog(@"Error fetching index: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    
    NSInteger myIndex = 1;
    if (maxIndexedObject) {
        myIndex = [[maxIndexedObject valueForKey:idKey] integerValue] + 1;
    }
    
    return [NSNumber numberWithInteger:myIndex];
}
 

@end
