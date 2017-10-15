


#import <UIKit/UIKit.h>


// класс методов для работы с базой данных
#import "DataBaseMethod.h"
// класс методов для редактирования изображений
#import "ImageEditingMethods.h"



@interface ChatTableView : UIViewController <UITableViewDelegate,UITableViewDataSource >


// контекст базы данных , и переданный бот в чат.
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext ;
@property (strong, nonatomic) UsersBot * userBot;

@property (strong, nonatomic) DataBaseMethod      * classDataBaseMethods;
@property (strong, nonatomic) ImageEditingMethods * classImageEditingMethods;

// все сообщения
@property (strong, nonatomic) NSMutableArray      * arrayAllMessages;
// сохраненные ячейки. для повторного использования TableView
@property (strong, nonatomic) NSMutableDictionary * cells;


@property (strong, nonatomic) IBOutlet UITableView * tableView;


// краткая форма обращения к массиву, всех сообщений
- (id) indx:(NSInteger)indx key:(NSString *)str;

// обновление ячеек
- (void)update ;


@end

