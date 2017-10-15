



#import "AppDelegate.h"



@implementation AppDelegate


- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _persistentContainer = [self persistentContainer];
    
    NSManagedObjectContext * databaseContext = _persistentContainer.viewContext ;
    
    NSDictionary *userInfo = databaseContext ? @{ @"Context" : databaseContext } : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"DatabaseNotification"
                                                        object: self
                                                      userInfo: userInfo];
    
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {

    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {

    @synchronized (self) {
        
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Model"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {

                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {

        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
