

#import <CoreData/CoreData.h>   // БД

#import "UsersRegistration.h"   // БД сущность - единственный юзер
#import "UsersBot.h"            // БД сущность - боты
#import "HistoryMessages.h"     // БД сущность - история сообщений

#import "ChatList.h"            // список ботов - TableVC - тут не нужны протоколы и установка делегатов 
#import "RegistrationVC.h"      // специальное поле - добавить фото имя фамилию  - для модального перехода - вьюха для создание ботов и пользователя
#import "ViewController.h"      // чат - вьюха сообщений


// список ботов - TableVC - тут не нужны протоколы и установка делегатов
@interface ChatList ()
{   NSMutableArray * _botName;      // имя       бота
    NSMutableArray * _botLastName;  // фамилия   бота
    NSMutableArray * _MyPhoto2;     // фотогрфия бота
    
    CGFloat screenWidth  ;          // размеры версии айфона по горизонтали
    CGFloat screenHeight ;     }    // размеры версии айфона по вертикали
@property (strong, nonatomic) NSManagedObjectContext    * managedObjectContext ; // БД контекст

@end




@implementation ChatList

#pragma   " обновление Базы Данных"
- (void)update {
    
    [ _botName     removeAllObjects ];
    [ _botLastName removeAllObjects ];
    [ _MyPhoto2    removeAllObjects ];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"UsersRegistration"];
    NSArray *userRegistration = [ _managedObjectContext executeFetchRequest: fetchRequest error: nil ];
    if ([userRegistration count] != 0) {		//	 Убеждаемся, что получили массив.

        for (UsersRegistration * user in userRegistration) {		//	 По порядку перебираем все контакты, содержащиеся в массиве.
            
            NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName: @"UsersBot"];
                            fetchRequest2.predicate = [NSPredicate predicateWithFormat:@"userRegistration = %@",user];
            NSArray *userBot = [ _managedObjectContext executeFetchRequest: fetchRequest2  error: nil ];
            if ([userBot count] != 0) {
                for ( UsersBot * userbot in userBot  ) {
                    
                    [_botName     addObject: userbot.name];
                    [_botLastName addObject: userbot.password];
                    [_MyPhoto2    addObject: [UIImage imageWithData: userbot.photo]];
                    
                    //imageView.image = [UIImage imageWithData: user.photo];
                    //imageView.contentMode = UIViewContentModeScaleAspectFill;
                }
            }
        }
    }
    [self.tableView reloadData];
    
}

#pragma   " показать содержимое Базы Данных - 2 уровня  Пользователь > его Боты  >X "  сообщений нет
- (IBAction)sqlCreate:(UIButton *)sender {
    
    
    // найти всех UsersRegistration
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"UsersRegistration"];
    // 	И применяем запрос к контексту - возращает массив с данными
    NSArray *userRegistration = [ _managedObjectContext executeFetchRequest: fetchRequest
                                                                      error: nil ];
    
    
    
    if ([userRegistration count] != 0) {		//	 Убеждаемся, что получили массив.
        int counter = 1;
        for (UsersRegistration * user in userRegistration) {		//	 По порядку перебираем все контакты, содержащиеся в массиве.
            NSLog(@"_______________________________________");
            NSLog(@" %d %@ " , counter, [user class]);
            NSLog(@"   Name       = %@"  , user.name);
            NSLog(@"   Passsword  = %@"  , user.passsword);
            
            //NSLog(@"   Photo      = %d"  , !(!(user.photo)));
            //NSLog(@"◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘");
            
            
            NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName: @"UsersBot"];
            fetchRequest2.predicate = [NSPredicate predicateWithFormat:@"userRegistration = %@",user];
            // 	И применяем запрос к контексту - возращает массив с данными
            NSArray *userBot = [ _managedObjectContext executeFetchRequest: fetchRequest2
                                                                     error: nil ];
            int counter2 = 1;
            for ( UsersBot * userbot in userBot  ) {
                
                NSLog(@"_____________");
                
                NSLog(@"    %d %@ " , counter2, [userbot class]);
                NSLog(@"      Name       = %@"  , userbot.name);
                NSLog(@"      Passsword  = %@"  , userbot.password);
                
                counter2++;
            }
            
            counter++;
        }
        NSLog(@"_______________________________________");
    }
}

#pragma   " получение  контекста Базы Данных  через  уведомление  от AppDelegate   "
- (void)awakeFromNib {
    
    // queue:nil        очередь, в которой выполняется блок. nil​, что означает очередь, на которой я сейчас
    // object:nil       это кто посылает уведомление, мы ставим nil​, что означает “кто бы не прислал его мне
    // usingBlock:^     Я могу сказать и [NSOperationQueue mainQueue]
    [[NSNotificationCenter defaultCenter] addObserverForName:@"DatabaseNotification"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      // NSLog(@" ChatList.m > awakeFromNib  получение контекста  ");
                                                      _managedObjectContext = note.userInfo[@"Context"];
                                                  }];
    
    
}

#pragma    обновление tableView  как только попадаем на  эту  VC
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

#pragma         какой текущий девайс ? его размеры
#pragma         создать  все массивы,   "Имя бота "  " фотографии ботов"     _botName;  _botLastName; _MyPhoto2
#pragma         " База данных " создать 1  пользователя  "1 переход"
#pragma         обновление tableView
- (void)viewDidLoad {    [super viewDidLoad];
    

    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    // _______________________________
    
    _botName     = [NSMutableArray new];
    _botLastName = [NSMutableArray new];
    _MyPhoto2    = [NSMutableArray new];
    
    
    
    // найти всех зарегестрированных
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UsersRegistration"];
    NSArray *matches = [_managedObjectContext executeFetchRequest: request
                                                            error: nil ];
    if ([matches count] != 0) { } // 0 != 0 = 0     1 != 0 = 1
    else {
        
        [self  performSegueWithIdentifier: @"addNamePhoto" sender:  @"create" ];
    }
    [self update];
}

#pragma         изменить свой профиль - вызывает         "2 переход"
- (IBAction)buttonEditProfile:(UIBarButtonItem *)sender {

    [self performSegueWithIdentifier: @"addNamePhoto" sender: @"editing" ];
}
#pragma         добавить бота - вызывает                 "3 переход"
- (IBAction)addBot:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier: @"addNamePhoto" sender: @"addBot" ];
}

#pragma  *   'когда кликнил по ячейке'                   "4 переход" к  соощениям с этим ботом   в ViewController
- (void)      tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier: @"bot" sender:  indexPath ];
    
}


#pragma  *  "! переход"  в RegistrationVC  для Создания единственого главного пользователя |  изменения своего профиля   | создания Бота
- (void)prepareForSegue: (UIStoryboardSegue *)segue
                 sender: (id)sender { 						// а SENDER  это передаваемый объект

    if ( [sender isKindOfClass:[NSString class]] ) {
        
        if  ( ([sender  isEqualToString:  @"editing" ]) ) { // NSLog(@" ChatList.m > prepareForSegue: sender: Редактирование  ");
            
            RegistrationVC *rVC = segue.destinationViewController;
            rVC.creatEdit = 0;
            rVC.managedObjectContext = _managedObjectContext;
        }
        else if ( ([sender  isEqualToString: @"create" ]) )  {
            RegistrationVC *rVC = segue.destinationViewController;
            rVC.creatEdit = 1;
            rVC.managedObjectContext = _managedObjectContext;
        }
        else if ( ([sender  isEqualToString: @"addBot" ]) )  {
            RegistrationVC *rVC = segue.destinationViewController;
            rVC.creatEdit = 2;
            rVC.managedObjectContext = _managedObjectContext;
        }
        
    }
    else  {
        
        
        ViewController *VC = segue.destinationViewController;
        NSIndexPath *index = sender;
        
        NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName: @"UsersBot"];
        NSArray *userBot = [ _managedObjectContext executeFetchRequest: fetchRequest2  error: nil ];
        if ([userBot count] != 0) {
            VC.userBot = userBot[index.row]; }
        
        VC.managedObjectContext = _managedObjectContext;
    
    }
    
    
}



#pragma  *   'удаление ячейки' "удаление с Базы Данных  бота "
- (void) tableView: (UITableView *)tableView
commitEditingStyle: (UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath: (NSIndexPath *)indexPath { // _________________________________________________________________________________
    
    
    // bot 0 < 1 = 1    1 < 1 = 0
    // элементов в массиве 2        для индекса 2 = 1
    if ([_botName count] < indexPath.row+1 ) {
        
    }
    else {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [_botName removeObjectAtIndex:indexPath.row];
            
            // найти всех UsersRegistration ____________________________________________________________________________________________________
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"UsersBot"];
            NSArray *users = [_managedObjectContext  executeFetchRequest: fetchRequest // И применяем запрос к контексту - возращает массив с данными
                                                                   error: nil];
            // Убеждаемся, что получили массив. ______
            if ([users count] != 0){
                UsersBot *lastUsers = users[indexPath.row];
                // NSLog(@"%@",lastUsers); //[self sqlCreate:nil];
                [_managedObjectContext deleteObject: lastUsers ];	// Удаляем последний объект из массива.
                
                [self.managedObjectContext save: nil];  // сохранение, контекста  	не обязательно - он и так сохраняет
            }// _________________________________________________________________________________________________________________________________
            
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            //NSLog(@"Unhandled editing style! %d", editingStyle);
        }
    }
    // ___________________________________________________________________________________________________________________________
}


#pragma  *   'колличество ячеек ' [_botName count]
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return [_botName count];
}

#pragma  *   'создание ячеек '  " База Данных   и последнее сообщение с ним "   - имя бота - фотография бота    _botName;  _botLastName; _MyPhoto2;
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault
                                                   reuseIdentifier: @"CellIdentifier"];
    
    
    
    
                                                         NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName: @"UsersBot"];
    NSArray *userBotArray = [ _managedObjectContext executeFetchRequest: fetchRequest2  error: nil ];
    UsersBot * userbot = userBotArray[indexPath.row];
    
    NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] initWithEntityName: @"HistoryMessages"];
                    fetchRequest3.predicate = [NSPredicate predicateWithFormat: @"whoTook = %@", userbot];
    NSArray *histotyMessageArray = [ _managedObjectContext executeFetchRequest: fetchRequest3  error: nil ];
    
    
    
    UILabel * label = [ UILabel new ];
    //label.backgroundColor = [UIColor blueColor]; label.alpha = 0.5;
    if([histotyMessageArray count]) {
        
        
        HistoryMessages * message = histotyMessageArray[[histotyMessageArray count]-1];
    
        
        
    
        NSString *messageText = message.messageText; //NSLog(@"%@",messageText);
    
        if(!message.messageText) {
            if (  message.locationCordinate1.doubleValue ) messageText = @"гелокация";
            else                                           messageText = @"фото";
        }
        
        
        
        NSDateFormatter * dateFormatterStr = [NSDateFormatter new];
                        [ dateFormatterStr setDateFormat: @"HH:mm dd/MM"];
        
                  UILabel * label3 = [ UILabel new ];
                            label3.frame = CGRectMake( screenWidth-80 , 0 , 78, 45);
                            label3.text  = [ dateFormatterStr stringFromDate: message.time ] ;
                            label3.font  = [ label3.font fontWithSize: 12 ];
                         // label3.backgroundColor = [UIColor greenColor]; label3.alpha = 0.5;
                            label3.textColor = [UIColor lightGrayColor];
         [ cell addSubview: label3];
        
    
                  UILabel * label2 = [ UILabel new ];
                            label2.frame = CGRectMake( 65 , 17 , screenWidth-80, 45);
                            label2.text  = messageText;
                            label2.font  = [ label2.font fontWithSize: 12 ];
                         // label2.backgroundColor = [UIColor redColor]; label2.alpha = 0.5;
                            label2.textColor = [UIColor lightGrayColor];
         [ cell addSubview: label2];
        
        if ( [message.messageText isEqualToString:@"" ] )   label.frame = CGRectMake( 65 ,  6 , 320             , 45);
        else                                                label.frame = CGRectMake( 65 , -2 , screenWidth-155 , 45);
        
        
    }
    else  {
        label.frame = CGRectMake( 65 , 6 , 320, 45 );
    }
    
    
    
        
                      label.text = [ NSString stringWithFormat: @"%@ %@", _botName[indexPath.row], _botLastName[indexPath.row] ];
    [cell addSubview: label];
    

    
    UIImageView *imagge = [[UIImageView alloc]  initWithFrame: CGRectMake(  17.5 , 12 , 35, 35) ];
                 imagge.image = _MyPhoto2[indexPath.row];
                 imagge.contentMode = UIViewContentModeScaleAspectFill;
                 imagge.layer.cornerRadius  = 18;
                 imagge.layer.masksToBounds = true;
    
    [cell addSubview: imagge];
    
    return cell;
}




@end


































