//
//  CoreDataDelegate.h
//  Kaliido
//
//  Created by Vadim Budnik on 06/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataDelegate : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataDelegate*)sharedDelegate;
+ (NSNumber *)nextAvailble:(NSString *)idKey forEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *)context;

- (NSString*)applicationDocumentsDirectory;
- (void)saveContext;


@end
