


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



@class HistoryMessages, UsersRegistration;


@interface UsersBot : NSManagedObject

@property (nonatomic, retain) NSString          * name;
@property (nonatomic, retain) NSString          * lastname;
@property (nonatomic, retain) NSData            * photo;
@property (nonatomic, retain) NSSet             * historyMessages;
@property (nonatomic, retain) UsersRegistration * userRegistration;

@end


@interface UsersBot (CoreDataGeneratedAccessors)

- (void)   addHistoryMessagesObject:(HistoryMessages *)value;
- (void)removeHistoryMessagesObject:(HistoryMessages *)value;
- (void)   addHistoryMessages:      (NSSet           *)values;
- (void)removeHistoryMessages:      (NSSet           *)values;

@end
