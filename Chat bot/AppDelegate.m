
#import <CoreData/CoreData.h>


#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSManagedObjectContext    *DatabaseContext = [self createMainQueueManagedObjectContext];
    
    //NSLog(@"%@",DatabaseContext);
    
    NSDictionary *userInfo = DatabaseContext ? @{ @"Context" : DatabaseContext } : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"DatabaseNotification"
                                                        object: self
                                                      userInfo: userInfo];
    
    return YES;
}

- (NSManagedObjectContext *)createMainQueueManagedObjectContext{
    
    
    // адресс Бд	Предположим, вы хотит найти путь к каталогу Documents (Документы) вашего приложения. Вот как просто это делается:
    NSArray *urlll = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                            inDomains:NSUserDomainMask];///создает путь к файлам, директории приложения,
    NSURL *urll = [urlll lastObject];//он возвращает массив - но там всего лишь 1 элемент. это адресс
    urll = [urll URLByAppendingPathComponent:@"MOC.sqlite"]; //добавление окончание, к этому адрессу
    
    
    
    // создать кординатор
    NSPersistentStoreCoordinator *per  =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: //  иницилизировать схему Базы Данных    Model.xcdatamodeld
     [[NSManagedObjectModel alloc] initWithContentsOfURL:	// создать схему Базы Данных  	инициализоровать
      [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"]] ]; // по этому адрессу       нашу модель схемы
    
    
    // Добавляет новое персистентное хранилище указанного типа в данном расположении и возвращает новое хранилище.
    [per addPersistentStoreWithType: NSSQLiteStoreType
                      configuration: nil
                                URL: urll   // адресс Бд
                            options: nil
                              error: nil];
    
    NSManagedObjectContext *ma = nil;
    if (per != nil) {
        ma = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType]; // создать контекст - тип: основной поток
        [ma setPersistentStoreCoordinator: per];	// к контексту добавить кординатор
    }
    return ma;
    
}



@end
