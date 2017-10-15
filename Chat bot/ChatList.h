



#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>



// методы базы данных
#import "DataBaseMethod.h"

// прототип ячейки
#import "ChatListCell.h"

// переходы на контроллеры
#import "RegistrationVC.h" // регистрация
#import "Chat.h" // чат



@interface ChatList : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext ; // контекст базы данных
@property (strong, nonatomic) DataBaseMethod * dataBaseMethod;

@end
