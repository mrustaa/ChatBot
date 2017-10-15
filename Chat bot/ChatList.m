



#import "ChatList.h"



@implementation ChatList

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // получение контекста Базы Данных
    [[NSNotificationCenter defaultCenter] addObserverForName:@"DatabaseNotification"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[@"Context"];
                                                  }];
}

#pragma  LifeCycle VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataBaseMethod = [[DataBaseMethod alloc] initContext:self.managedObjectContext bot:nil];
    
    // главный пользователь создан? если нет - то переходить на контроллер регистрации - для создания
    if ( ![self.dataBaseMethod get_mainUser] ) { [self createMainUser]; }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}


#pragma  Segue

// программный переход
- (IBAction)  createMainUser                 { [self performSegueWithIdentifier: @"addEditProfile" sender: @"create"  ]; }
- (IBAction)    editMainUser:(id)sender      { [self performSegueWithIdentifier: @"addEditProfile" sender: @"editing" ]; }
- (IBAction)      addBotUser:(id)sender      { [self performSegueWithIdentifier: @"addEditProfile" sender: @"addBot"  ]; }
- (IBAction)segueChatBotUser:(UsersBot *)bot { [self performSegueWithIdentifier: @"segueToChat"    sender: bot        ]; }


// передача данных на переходящую VC
- (void)prepareForSegue: (UIStoryboardSegue *)segue  sender:(id)sender {
    
    if ( [sender isKindOfClass:[NSString class]] ) {

        RegistrationVC *
        vc = segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        
             if ( ([sender isEqual: @"create"  ]) ) vc.creatEdit = 0;
        else if ( ([sender isEqual: @"editing" ]) ) vc.creatEdit = 1;
        else if ( ([sender isEqual: @"addBot"  ]) ) vc.creatEdit = 2;
    }
    else  {
        Chat *
        vc = segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        
        if ([[self.dataBaseMethod get_allBots] count]) vc.userBot = sender;
        
    }
}




#pragma  TableView protocols Delegate, DataSource

// установка кол-ва ячеек
- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    
    return [[self.dataBaseMethod get_allBots ] count];
}

// нажатие 1 ячейки
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self segueChatBotUser: [self.dataBaseMethod get_allBots][indexPath.row] ];
    
}

// удаление 1 ячейки
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // удалить из базы данных  бота  по переданному индексу
    [self.dataBaseMethod delete_bot: [self.dataBaseMethod get_allBots][indexPath.row] ];
    
    // удалить из TableView ячейку  по переданному индексу
    [ tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade ];
}

// создание 1 ячейки
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // вернуть прототип ячейки
    ChatListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];

    
    
    // вернуть всех ботов [из них 1 бота по индексу]
    UsersBot * bot = [self.dataBaseMethod get_allBots][indexPath.row];
    
    cell.label.text  = [NSString stringWithFormat:@"%@ %@",bot.name,bot.lastname];
    cell.image.image = [UIImage imageWithData: bot.photo];
    
    // вернуть историю переписки
    NSArray *histotyMsg = [self.dataBaseMethod get_bot_chatHistory: bot ];
    // если переписка есть
    
    
    if ( [histotyMsg count] >= 2 ) {

        // последнее сообщение
        HistoryMessages * message = [histotyMsg lastObject ] ;
        
        // вывести дату последнего сообщения из истории
              NSDateFormatter * dateFormatterStr = [NSDateFormatter new];
                              [ dateFormatterStr setDateFormat:  @"HH:mm dd/MM" ];
        cell.labelData.text = [ dateFormatterStr stringFromDate: message.time  ];
        
        // если последнее сообщение из истории  есть, но остсутсвует текст - это геолокация. либо фото
        if( !message.messageText ) {
            // если есть конрдинаты, значит это геолокация
            if ( message.locationCordinate1.doubleValue )
                 cell.labelLastMessage.text = @"гелокация";
            else cell.labelLastMessage.text = @"фото";
        }
        else     cell.labelLastMessage.text = message.messageText;
        
        // сдвинуть выше лейбел имени Фамилии бота
        cell.label.frame = CGRectMake( 65 , 0 , self.view.frame.size.width -155 , 41);
    }
    // стереть в любом случае - лейбел даты последнего сообщения, и лейбел последнего сообщения
    else {
        cell.labelData       .text = @"";
        cell.labelLastMessage.text = @"";
        cell.label.frame = CGRectMake( 65 , 0 , self.view.frame.size.width  -65 , 57);
    }


    
    return cell;
}




@end


