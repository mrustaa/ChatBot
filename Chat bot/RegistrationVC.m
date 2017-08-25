
#import <CoreData/CoreData.h>   // БД

#import "UsersRegistration.h"   // БД сущность - единственный юзер
#import "UsersBot.h"            // БД сущность - боты
#import "HistoryMessages.h"     // БД сущность - история сообщений

#import "ChatList.h"            // список ботов - TableVC - тут не нужны протоколы и установка делегатов
#import "RegistrationVC.h"      // специальное поле - добавить фото имя фамилию  - для модального перехода - вьюха для создание ботов и пользователя


// специальное поле - добавить фото имя фамилию  - для модального перехода - вьюха для создание ботов и пользователя
@interface RegistrationVC () <  
UITextFieldDelegate,    // скрыть клавиатуру
UINavigationControllerDelegate  , UIImagePickerControllerDelegate > // доступ к фото библиотеке пользователя
{
    UIImagePickerController *imagePickerController; // фото библиотеке пользователя
    
    UIImageView * imageView; 
    
    CGFloat screenWidth  ; 
    CGFloat screenHeight ;
}


@property (strong, nonatomic) UITextField  * name     ; // имя
@property (strong, nonatomic) UITextField  * password ; // фамилия


@end

@implementation RegistrationVC

#pragma  *  "демонтрация - Удаления, Создания, Просмотра содержимого - Базы Данных"
- (IBAction)sqlDelete:(UIButton *)sender {
  
    // найти всех UsersRegistration
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"UsersRegistration"];
    NSArray *users = [_managedObjectContext  executeFetchRequest: fetchRequest // И применяем запрос к контексту - возращает массив с данными
                                                           error: nil];
    // Убеждаемся, что получили массив.
    if ([users count] != 0){
                          UsersRegistration *lastUsers = [users lastObject];
        [_managedObjectContext deleteObject: lastUsers ];	// Удаляем последний объект из массива.
    }
}
- (IBAction)sqlCreate:(UIButton *)sender {
    
    // 	создать прототип  UserRegistration
    UsersRegistration *newUser = [NSEntityDescription  insertNewObjectForEntityForName: @"UsersRegistration" // поиск сущности по имени
                                                                inManagedObjectContext: _managedObjectContext];	// контекст
                  if ( newUser != nil) 	{	// если найден
                      newUser.name       = _name.text;	// добавить данные
                      newUser.passsword  = _password.text;
                      
                      [self.managedObjectContext save: nil];  // сохранение, контекста  	не обязательно - он и так сохраняет 
                  }
    
}
- (IBAction)sqlShow:  (UIButton *)sender {
    //NSLog(@"%@",_managedObjectContext);

    
    // найти всех UsersRegistration
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"UsersRegistration"];
    // 	И применяем запрос к контексту - возращает массив с данными
    NSArray *userRegistration = [ _managedObjectContext executeFetchRequest: fetchRequest
                                                                      error: nil ];
    
    
    
    if ([userRegistration count] != 0) {		//	 Убеждаемся, что получили массив.
        int counter = 1;
        for (UsersRegistration * user in userRegistration) {		//	 По порядку перебираем все контакты, содержащиеся в массиве.

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
            
            for ( UsersBot * userbot in userBot  ) {
            
                NSLog(@"   %@ " , [userbot class]);
                NSLog(@"   Name       = %@"  , userbot.name);
                NSLog(@"   Passsword  = %@"  , userbot.password);
            
            }

            counter++;
        }
    }
}


#pragma         какой текущий девайс ? его размеры
#pragma         создание кнопок и назначения для них селекторов - создания пользователя - создания бота - изменения пользователя 
#pragma         создание UI  круга добавления изображения с тенью - и полей textField  имя и фамилия
#pragma         создание прикосновение - скрывает клавиатуру
- (void)viewDidLoad {    [super viewDidLoad];
    

    
    //__________________________________________________________________________________________________
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    // ____________________________________________________________________________________________________
    
    
    // делаем Navigation Контроллер
    UIView *view1 = [[UIView alloc] initWithFrame: CGRectMake( 0, 0, screenWidth, 29 )];
            view1.backgroundColor = [UIColor colorWithRed: 247.0/255.0 green: 247.0/255.0 blue: 247.0/255.0 alpha: 1.0];

    
    UINavigationBar *_bar3 = [UINavigationBar new];
                     _bar3.frame = CGRectMake( 0, 20, screenWidth, 44 );
    
    
    
    UINavigationItem *_item = [[UINavigationItem alloc] initWithTitle: @""];
     // ____________________________________________________________________________________________________
    if(_creatEdit == 1) {
                 UIBarButtonItem * btn2 = [[UIBarButtonItem alloc] initWithTitle: @"Создать"  style: UIBarButtonItemStylePlain target: self
                                                                          action: @selector( buttonMethod1 )];
        _item.rightBarButtonItem = btn2;    self.navigationItem.rightBarButtonItem = btn2;
    }
    else if (_creatEdit == 0) {  // ____________________________________________________________________________________________________
        UIBarButtonItem * btn1 = [[UIBarButtonItem alloc] initWithTitle: @"Отмена"  style: UIBarButtonItemStylePlain target: self
                                                                 action: @selector( endEditing: )];
        UIBarButtonItem * btn2 = [[UIBarButtonItem alloc] initWithTitle: @"Изменить"  style: UIBarButtonItemStylePlain target: self
                                                                 action: @selector( buttonMethod3 )];
    
        _item.leftBarButtonItem  = btn1;    self.navigationItem.leftBarButtonItem  = btn1;
        _item.rightBarButtonItem = btn2;    self.navigationItem.rightBarButtonItem = btn2;
    } // ____________________________________________________________________________________________________
    else if (_creatEdit == 2) {  // ____________________________________________________________________________________________________
        UIBarButtonItem * btn1 = [[UIBarButtonItem alloc] initWithTitle: @"Отмена"  style: UIBarButtonItemStylePlain target: self
                                                                 action: @selector( endEditing: )];
        UIBarButtonItem * btn2 = [[UIBarButtonItem alloc] initWithTitle: @"Создать"  style: UIBarButtonItemStylePlain target: self
                                                                 action: @selector( buttonMethod4 )];
        
        _item.leftBarButtonItem  = btn1;    self.navigationItem.leftBarButtonItem  = btn1;
        _item.rightBarButtonItem = btn2;    self.navigationItem.rightBarButtonItem = btn2;
    } // ____________________________________________________________________________________________________
    
    
    [_bar3 pushNavigationItem: _item
                     animated: NO];
    
    [ self.view addSubview: view1 ];
    [ self.view addSubview: _bar3 ];

    
    //__________________________________________________________________________________________________
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    //__________________________________________________________________________________________________
    
    self.view.backgroundColor =  [UIColor colorWithRed: 239.0/255.0 green: 239.0/255.0 blue: 244.0/255.0 alpha: 1.0];
    //__________________________________________________________________________________________________
        int sizeView2 = 110;
    UIView *view2 = [[UIView alloc] initWithFrame: CGRectMake( (screenWidth / 2)- (sizeView2 / 2)  , 40, sizeView2, sizeView2)];
            view2.backgroundColor =  [UIColor whiteColor];
            view2.layer.cornerRadius = (sizeView2 / 2);
            view2.layer.borderColor = [[UIColor colorWithRed: 219.0/255.0 green: 219.0/255.0 blue: 214.0/255.0 alpha: 1.0]	CGColor];  // 1 цвет
            view2.layer.borderWidth = 0.7; 									// 2 толщина
        // тень
            view2.layer.shadowOffset 	= CGSizeMake(0, 2);  					// смещение от центра
            view2.layer.shadowOpacity 	= 0.3; 								// непрозрачность
            view2.layer.shadowRadius 	= 2;									// уровень размытия
            view2.layer.shadowColor 	= [ [UIColor colorWithRed: 44.0/255.0  green: 62.0/255.0  blue: 80.0/255.0  alpha: 1.0  ] CGColor ]; //  цвет тени
    [ self.view addSubview: view2 ];
    //__________________________________________________________________________________________________
        int sizeButton2 = 80;
    UIButton *button2 = [UIButton buttonWithType: UIButtonTypeRoundedRect];
             [button2 addTarget:self  action:@selector(buttonMethod2)  forControlEvents:UIControlEventTouchUpInside];
             [button2 setExclusiveTouch:YES];
              button2.frame = CGRectMake( (sizeView2 / 2) - (sizeButton2/2) , (sizeView2 / 2) - (sizeButton2/2) - 5 , sizeButton2, sizeButton2);
              button2.tintColor = [UIColor lightGrayColor];
             [button2 setImage: [UIImage imageNamed:@"photoAdd.png"] forState:UIControlStateNormal];
    [view2 addSubview: button2];

    //__________________________________________________________________________________________________
    
    
    _name = [[UITextField alloc] initWithFrame:CGRectMake(30, 172, screenWidth - 60, 30)];
    _name.borderStyle = UITextBorderStyleRoundedRect;
    _name.font = [UIFont systemFontOfSize:14];
    _name.placeholder = @"Имя...";
    _name.autocorrectionType = UITextAutocorrectionTypeNo;  // отключить подсказки в клавиатуре - которые ее расширяют
    _name.keyboardType = UIKeyboardTypeDefault;
    _name.returnKeyType = UIReturnKeyDone;
    _name.clearButtonMode = UITextFieldViewModeWhileEditing;
    _name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _name.delegate = self;
    
    [self.view addSubview: _name ];
    //__________________________________________________________________________________________________

    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(30, 210, screenWidth - 60, 30)];
    _password.borderStyle = UITextBorderStyleRoundedRect;
    _password.font = [UIFont systemFontOfSize:14];
    _password.placeholder = @"Фамилия...";
    _password.autocorrectionType = UITextAutocorrectionTypeNo;  // отключить подсказки в клавиатуре - которые ее расширяют
    _password.keyboardType = UIKeyboardTypeDefault;
    _password.returnKeyType = UIReturnKeyDone;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _password.delegate = self;
    [self.view addSubview: _password ];


    if (_creatEdit == 0) [self editingProfile];
    
}

#pragma     если главный пользователь уже есть -
#pragma       заполнение - ячеек textField и фотографии - о нашем профиле - "сохранеными данными из БД"
- (void)editingProfile {
    

    // найти и вернуть 1 главного пользователя
    UsersRegistration *user = [[_managedObjectContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"UsersRegistration"]error:nil] lastObject];

    
        _name.text = user.name       ;	// добавить данные
    _password.text = user.passsword  ;
    
    int sizeImage2 = 105;
    imageView = [[UIImageView alloc]  initWithFrame: CGRectMake( (screenWidth / 2)- (sizeImage2 / 2)-0.5  , 42.5, sizeImage2, sizeImage2)];
    imageView.image = [UIImage imageWithData: user.photo];// [ self imageRect: [UIImage imageNamed: @"diana.jpg"] size: CGSizeMake(35, 35) ];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius  = sizeImage2 / 2;
    imageView.layer.masksToBounds = true;
    
    [self.view addSubview: imageView];
    
    
    
}

#pragma     < отмена  - просто переход назад в  'ChatList'
- (void)endEditing:(id)btn {
    [self.presentingViewController dismissViewControllerAnimated: YES//  контроллер который представил этот класс 	UIViewController
                                                      completion: NULL ];// 	dismissViewControllerAnimated 	удаляет с экрана этот класс
}


#pragma     Создание главного пользователя  "сохранение в БД" -  Стартовый запуск -  добавить - имя фамилия фото
#pragma         КУЧА проверок - обязательно должны быть имя фамилия фото пробелы - что бы было все ЧЕТКО
- (void)buttonMethod1 {
    
    NSString *message;
    
    NSString *     name = _name.text;
    NSString * lastname = _password.text;
    
    NSArray *words1 = [name componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSIndexSet *separatorIndexes1 = [words1 indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) { return [obj isEqualToString:@""]; }];
    
    NSArray *words2 = [lastname componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSIndexSet *separatorIndexes2 = [words2 indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) { return [obj isEqualToString:@""]; }];
    
    
    int alertView_show=0;
    
    
    if ( ( _managedObjectContext ) && ( imageView ) &&
        !( [name      isEqualToString: @""] ) &&       // проверка не пустое ли имя
        !( [lastname  isEqualToString: @""] )    ) {   // проверка не пустой ли пароль
        
        if (( ([words1 count] - [separatorIndexes1 count]) != 1 ) || ( ([words2 count] - [separatorIndexes2 count]) != 1 ) ) {
            alertView_show=1; message = @"Введите корректно Имя и Фамилию";
        }
        else {
            
            name =      [    name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet] ];
            lastname =  [lastname stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet] ];
            
            if ( ([name length] + [lastname length]) > 18 ) { alertView_show=1; message = @"Слишком длинное Имя и Фамилия"; }
            else {
            
            // найти всех зарегестрированных
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UsersRegistration"];
            // равных по имени textField
            request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name ];
            
            // вернет массив
            NSArray *matches = [_managedObjectContext executeFetchRequest: request
                                                                    error: nil ];
            
            // массив не создан || в массиве элементов больше 2-ух  это невозможно
            if (!matches || ([matches count] > 1)) { }
            // в массиве элементов 1-ин значит уже существует , вернуть
            else if ([matches count]) {   message = @"пользователь с таким именем уже существует" ; alertView_show =1; }
            // в массиве элементов пусто  - значит создать
            else {
                // 	создать прототип  UserRegistration
                UsersRegistration *newUser = [NSEntityDescription  insertNewObjectForEntityForName: @"UsersRegistration" // поиск сущности по имени
                                                                            inManagedObjectContext: _managedObjectContext];	// контекст
                if ( newUser != nil) 	{	// если найден
                    newUser.name      = name;	// добавить данные
                    newUser.passsword = lastname;
                    newUser.photo = UIImageJPEGRepresentation(imageView.image,1.0);
                    [self.managedObjectContext save: nil];  // сохранение, контекста  	не обязательно - он и так сохраняет
                }
                _name.text = @"";
                _password.text = @"";
                // переход
                [self.presentingViewController dismissViewControllerAnimated: YES// - контроллер который представил этот класс 	UIViewController
                                                                  completion: NULL ];// 	dismissViewControllerAnimated 	удаляет с экрана этот класс
            }
            }
            
        }
    }
    else if ( !imageView && [name isEqualToString: @""] && [lastname isEqualToString: @""] ) { alertView_show=1; message = @"Поля для заполнения пустые";}
    else if ( !imageView && [name     isEqualToString: @""]  ) { alertView_show=1; message = @"Добавьте Имя и фотографию";}
    else if ( !imageView && [lastname isEqualToString: @""]  ) { alertView_show=1; message = @"Добавьте Фамилию и фотографию";}
    else if ( [name isEqualToString: @""]  && [lastname isEqualToString: @""]  ) { alertView_show=1; message = @"Добавьте Имя и Фамилию";}
    else if ( !imageView )                              { alertView_show=1; message = @"Добавьте фотографию"; }
    else if ( [name     isEqualToString: @""] )   { alertView_show=1; message = @"Добавьте Имя"; }
    else if ( [lastname isEqualToString: @""] )   { alertView_show=1; message = @"Добавьте Фамилию"; }
    else                                                { alertView_show=1; message = @"Поля для заполнения пустые";   }
    
    if( alertView_show ) { //NSLog(@"че за хуйня");
        // пример создание 		Если ты хочешь создать предупреждение
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Отмена"
                                                        message: message
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];		// показать
        alertView_show =0;
    }
}

#pragma     Сохранение Изменений  главного пользователя "сохранение в БД"
#pragma         кУЧА проверок - обязательно должны быть имя фамилия фото пробелы - что бы было все ЧЕТКО
- (void)buttonMethod3 {
    
    
    NSString *     name = _name.text;
    NSString * lastname = _password.text;
    
    
    NSArray *words1 = [name componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSIndexSet *separatorIndexes1 = [words1 indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) { return [obj isEqualToString:@""]; }];
    
    NSArray *words2 = [lastname componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSIndexSet *separatorIndexes2 = [words2 indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) { return [obj isEqualToString:@""]; }];
    
    
    
    
    int alertView_show = 0;
    NSString *message;
    
    
    
    BOOL i1 = ( !imageView );
    BOOL i2 = [ name     isEqualToString: @"" ];
    BOOL i3 = [ lastname isEqualToString: @"" ];
    
    if (  i1 &&  i2 &&  i3 ) { alertView_show=1; message = @"Поля для заполнения пустые";}
    else if (  i1 &&  i2 && !i3 ) { alertView_show=1; message = @"Добавьте Имя и фотографию";}
    else if (  i1 && !i2 &&  i3 ) { alertView_show=1; message = @"Добавьте Фамилию и фотографию";}
    else if ( !i1 &&  i2 &&  i3 ) { alertView_show=1; message = @"Добавьте Имя и Фамилию";}
    else if (  i1 && !i2 && !i3 ) { alertView_show=1; message = @"Добавьте фотографию"; }
    else if ( !i1 &&  i2 && !i3 ) { alertView_show=1; message = @"Добавьте Имя"; }
    else if ( !i1 && !i2 &&  i3 ) { alertView_show=1; message = @"Добавьте Фамилию"; }
    else {
        // 1 != 1   =0    ||        2 != 1   =1
        if (( ([words1 count] - [separatorIndexes1 count]) != 1 ) || ( ([words2 count] - [separatorIndexes2 count]) != 1 ) ) {
            alertView_show=1; message = @"Введите корректно Имя и Фамилию";
        }
        else {
            
            
            name = [    name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet] ];
            lastname = [lastname stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet] ];
            
            if ( ([name length] + [lastname length]) > 18 ) { alertView_show=1; message = @"Слишком длинное Имя и Фамилия"; }
            else {
            
            
            // найти всех UsersRegistration
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"UsersRegistration"];
            NSArray *users = [_managedObjectContext  executeFetchRequest: fetchRequest // И применяем запрос к контексту - возращает массив с данными
                                                                   error: nil];
            // Убеждаемся, что получили массив.
            if ([users count] != 0){
                UsersRegistration *lastUsers = [users lastObject];
                
                lastUsers.name      =     name ;	// добавить данные
                lastUsers.passsword = lastname ;
                lastUsers.photo = UIImageJPEGRepresentation(imageView.image,1.0);
                
                [self.managedObjectContext save: nil];  // сохранение, контекста  	не обязательно - он и так сохраняет
            }
            _name.text      = @"";
            _password.text  = @"";
            // переход
            [self.presentingViewController dismissViewControllerAnimated: YES// - контроллер который представил этот класс 	UIViewController
                                                              completion: NULL ];// 	dismissViewControllerAnimated 	удаляет с экрана этот класс
            }
        }
    }
    
    if( alertView_show ) { // NSLog(@"че за хуйня");
        // пример создание 		Если ты хочешь создать предупреждение
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Отмена"
                                                        message: message
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];		// показать
        alertView_show = 0;
    }
    
}

#pragma     Создание бота "сохранение в БД" 
#pragma         КУЧА проверок - обязательно должны быть имя фамилия фото пробелы - что бы было все ЧЕТКО
- (void)buttonMethod4 {
     

    
    NSString *     name = _name.text;
    NSString * lastname = _password.text;
    
    
    NSArray *words1 = [name componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSIndexSet *separatorIndexes1 = [words1 indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) { return [obj isEqualToString:@""]; }];
    
    NSArray *words2 = [lastname componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSIndexSet *separatorIndexes2 = [words2 indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) { return [obj isEqualToString:@""]; }];
    
    

    
    
    int alertView_show =0;
    NSString *message;
    
    BOOL i1 = (!imageView);
    BOOL i2 = [ name     isEqualToString: @"" ];
    BOOL i3 = [ lastname isEqualToString: @"" ];
    
         if (  i1 &&  i2 &&  i3 ) { alertView_show=1; message = @"Поля для заполнения пустые";}
    else if (  i1 &&  i2 && !i3 ) { alertView_show=1; message = @"Добавьте Имя и фотографию";}
    else if (  i1 && !i2 &&  i3 ) { alertView_show=1; message = @"Добавьте Фамилию и фотографию";}
    else if ( !i1 &&  i2 &&  i3 ) { alertView_show=1; message = @"Добавьте Имя и Фамилию";}
    else if (  i1 && !i2 && !i3 ) { alertView_show=1; message = @"Добавьте фотографию"; }
    else if ( !i1 &&  i2 && !i3 ) { alertView_show=1; message = @"Добавьте Имя"; }
    else if ( !i1 && !i2 &&  i3 ) { alertView_show=1; message = @"Добавьте Фамилию"; }
    else {
        // 1 != 1   =0    ||        2 != 1   =1
        if (( ([words1 count] - [separatorIndexes1 count]) != 1 ) || ( ([words2 count] - [separatorIndexes2 count]) != 1 ) ) {
            alertView_show=1; message = @"Введите корректно Имя и Фамилию";
        }
        else {
        
                name =  [    name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet] ];
            lastname =  [lastname stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet] ];
            
            if ( ([name length] + [lastname length]) > 18 ) { alertView_show=1; message = @"Слишком длинное Имя и Фамилия"; }
            else {
            
        // 	создать прототип  UserRegistration
        UsersBot *newUser = [NSEntityDescription  insertNewObjectForEntityForName: @"UsersBot" // поиск сущности по имени
                                                                    inManagedObjectContext: _managedObjectContext];	// контекст
        if ( newUser != nil) 	{	// если найден
            newUser.name       = name;	// добавить данные
            newUser.password   = lastname;
            newUser.photo = UIImageJPEGRepresentation(imageView.image,1.0);
            
            // найти всех UsersRegistration
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"UsersRegistration"];
            NSArray *users = [_managedObjectContext  executeFetchRequest: fetchRequest // И применяем запрос к контексту - возращает массив с данными
                                                                   error: nil];
            // Убеждаемся, что получили массив.
            if ([users count] != 0){
                        UsersRegistration *lastUsers = [users lastObject];
                newUser.userRegistration = lastUsers;
            }
            
            
            
            [self.managedObjectContext save: nil];  // сохранение, контекста  	не обязательно - он и так сохраняет
        }
        
        
        

        _name.text      = @"";
        _password.text  = @"";
        // переход
        

        [ ((ChatList *) ((UINavigationController *)self.presentingViewController).topViewController) update ];
        
        [self.presentingViewController dismissViewControllerAnimated: YES// - контроллер который представил этот класс 	UIViewController
                                                          completion: NULL ];// 	dismissViewControllerAnimated 	удаляет с экрана этот класс
        }
        }
    }
    
    if( alertView_show ) { // NSLog(@"че за хуйня");
        // пример создание 		Если ты хочешь создать предупреждение
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Отмена"
                                                        message: message
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];		// показать
        alertView_show = 0;
    }
    
}




#pragma     'фото библиотека'
#pragma      изменить аватарку - вызывает библиотеку фотографий
- (void)buttonMethod2 {
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // Тип интерфейса, который будет отображаться
    
    [self presentViewController: imagePickerController  // Модальный запуск - либо фотокамеры/видео  либо библиотеки
                       animated: YES
                     completion: NULL];
}
#pragma      получение изображения из библиотеки
- (void)imagePickerController: (UIImagePickerController *)picker
didFinishPickingMediaWithInfo: (NSDictionary *)info {
    
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    //NSURL   * url   = info[UIImagePickerControllerReferenceURL ];
    
    if (!(imageView)) {
    
        int sizeImage2 = 105;
    imageView = [[UIImageView alloc]  initWithFrame: CGRectMake( (screenWidth / 2)- (sizeImage2 / 2)-0.5  , 42.5, sizeImage2, sizeImage2)];
    imageView.image = image;// [ self imageRect: [UIImage imageNamed: @"diana.jpg"] size: CGSizeMake(35, 35) ];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius  = sizeImage2 / 2;
    imageView.layer.masksToBounds = true;
    
    [self.view addSubview: imageView];
    }
    else {
        imageView.image = image;
    }
    
    [ self dismissViewControllerAnimated: YES
                              completion: NULL];
}


#pragma     'скрыть клаву'
#pragma      прикосновение - скрыть клаву
- (void)dismissKeyboard {
    [_name      resignFirstResponder];
    [_password  resignFirstResponder]; // выключить клаву
}
#pragma      Сделаем так, чтобы по нажатию "Done" клавиатура пряталась
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



@end






























