 

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#import "UsersBot.h"
#import "HistoryMessages.h"
#import "UsersRegistration.h"


@interface DataBaseMethod : NSObject



@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext ;
@property (strong, nonatomic) UsersBot * userBot;


// -------------------------------------------------------------------------

// Инициализировать контекст, и бота (в переписку к которому мы заходим)
- (DataBaseMethod *)initContext:(NSManagedObjectContext *)context
                            bot:(UsersBot *)bot;


// -------------------------------------------------------------------------

// Вернуть все сообщения в виде массива, внутри которого словари с данными о 1 сообщении
- (NSMutableArray *)get_allMessage;

// -------------------------------------------------------------------------

// создание главного пользователя
- (void)  create_mainUser_name:(NSString *)name
                      lastname:(NSString *)lastname
                         image:(UIImageView *)imageView;

// редактирование главного пользователя
- (void)    edit_mainUser_name:(NSString *)name
                      lastname:(NSString *)lastname
                         image:(UIImageView *)imageView;

// вернуть главного пользователя
- (UsersRegistration *)get_mainUser;

// -------------------------------------------------------------------------

// создание бота
- (void)  create_bot_name:(NSString *)name
                 lastname:(NSString *)lastname
                    image:(UIImageView *)imageView;

// вернуть всех созданных ботов
- (NSArray *)get_allBots;

// вернуть историю переписки с бом
- (NSArray *)get_bot_chatHistory:(UsersBot *)bot;

// удалить бота
- (void)  delete_bot:(UsersBot *)bot ;

// -------------------------------------------------------------------------

// создать сообщение
- (HistoryMessages *) create_message ;

// стартовый пробел необходим - это первая создающаяся расширенная ячейка,
// благодаря которой, новые ячейки будут создаваться снизу,
// а не сверху, как обычно в tableView по умолчанию.

// создать стартовый пробел , передать размеры его высоты
- (void)  create_messageFirstSpace_size:(int)size;

// редактировать стартовый пробел , передать его размеры
- (void)    edit_messageFirstSpace_size:(int)size;

// -------------------------------------------------------------------------

// создать сообщение тип-текст
- (void) create_messageTypeMsg_user:(NSString *)user
                               size:(int)size
                            message:(NSString *)message ;

// создать сообщение тип-геолокация
- (void) create_messageTypeGeo_user:(NSString *)user
                               size:(int)size
                              image:(UIImage *)image
                           latitude:(int)latitude
                          longitude:(int)longitude ;

// создать сообщение тип-фотография
- (void) create_messageTypeImg_user:(NSString *)user
                               size:(int)size
                              image:(UIImage *)image
                                url:(NSURL *)url ;

@end
