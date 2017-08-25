//
//  UsersRegistration.h
//  Chat2
//
//  Created by robert on 21.08.17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UsersBot;

@interface UsersRegistration : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * passsword;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSSet *usersBot;
@end

@interface UsersRegistration (CoreDataGeneratedAccessors)

- (void)addUsersBotObject:(UsersBot *)value;
- (void)removeUsersBotObject:(UsersBot *)value;
- (void)addUsersBot:(NSSet *)values;
- (void)removeUsersBot:(NSSet *)values;

@end
