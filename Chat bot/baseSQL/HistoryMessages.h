



#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



@class UsersBot;


@interface HistoryMessages : NSManagedObject


@property (nonatomic, retain) NSString  * name;
@property (nonatomic, retain) NSNumber  * messageSize;
@property (nonatomic, retain) NSDate    * time;


@property (nonatomic, retain) NSString  * messageText;

@property (nonatomic, retain) NSData    * messagePhoto;
@property (nonatomic, retain) NSString  * photoURL;

@property (nonatomic, retain) NSNumber  * locationCordinate1;
@property (nonatomic, retain) NSNumber  * locationCordinate2;


@property (nonatomic, retain) NSData    * cells;



@property (nonatomic, retain) UsersBot  * whoTook;

@end
