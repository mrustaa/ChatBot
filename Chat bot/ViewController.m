
/*
 
 self.messageView.frame = CGRectMake( _messageView.frame.origin.x  ,
 _messageView.frame.origin.y ,
 _messageView.frame.size.width     ,
 _messageView.frame.size.height    );
 
 [ UIView  animateWithDuration: 1.0
                        delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                        animations: ^{
                            self.messageView.frame = CGRectMake( 0  , 220     ,
                                                        _messageView.frame.size.width     ,
                                                        _messageView.frame.size.height    );
                        }
                        completion: ^(BOOL fin){ if(fin){  } }];
 
 [ UIView animateWithDuration: 1.3 animations: ^{ _view2.frame = CGRectMake(0, 220, 320, 46	); } ];
 
 NSLog(@" %f %f %f %f ",
 _messageView.frame.origin.x    ,
 _messageView.frame.origin.y    ,
 _messageView.frame.size.width  ,
 _messageView.frame.size.height  );
 
 [_audioPlayer play];
 
 [UIColor colorWithRed: 224.0/255.0 green: 255.0/255.0 blue: 196.0/255.0 alpha: 1.0];
 */

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <sys/sysctl.h>

#import <CoreData/CoreData.h>   // БД

#import "UsersRegistration.h"   // БД сущность - единственный юзер
#import "UsersBot.h"            // БД сущность - боты
#import "HistoryMessages.h"     // БД сущность - история сообщений

#import "ViewController.h"

#import "Cordinatee.h"
#import "MapViewController.h"

#import "CordinateMapView.h"
#import "ImageViewController.h"

#import "MyCollectionViewCell.h"


@interface ViewController () <
UITableViewDelegate             ,
UITableViewDataSource           ,

UICollectionViewDataSource      ,
UICollectionViewDelegateFlowLayout ,

UIGestureRecognizerDelegate     ,
UITextFieldDelegate             ,

AVAudioSessionDelegate          ,
AVAudioPlayerDelegate           ,

UIActionSheetDelegate          ,
UINavigationControllerDelegate  ,
UIImagePickerControllerDelegate     >
{
    
    
    UITableView    * _tableView;
    UITextField    * _messageTextField2;
    
    NSMutableArray * _arrayUserName;        // имя
    NSMutableArray * _arrayUserMessage;     // сообщение текст - фотография
    NSMutableArray * _arrayUserMessageSize; // размер ячейки
    NSMutableDictionary * _cells;           // сохраненные ячейки - для производительности - что бы не загружал данные - с уже ранее загруженнрой ячейки
    NSMutableDictionary * _arrayPhotoURL;   // сохраненные ячейки - для производительности - что бы не загружал данные - с уже ранее загруженнрой ячейки
    NSMutableDictionary * _arrayLocationCoordinate ;
    NSMutableDictionary * _arrayDate ;
    //AVAudioPlayer  * _audioPlayer;

    BOOL _keyboardOpen;
    BOOL _keyboardOpenStart;
    
    UIView  * _view2;
    
    UIImage * _backgroundImage1;
    UIImage * _backgroundImage2;
    
    NSString * user1;
    NSString * user2;
    
    NSString * _MyName1;
    NSString * _MyName2;
    UIImage * _MyPhoto1;
    UIImage * _MyPhoto2;
    
    CGFloat screenWidth  ;
    CGFloat screenHeight ;
    
    NSMutableArray *cELLL_index ;
    NSMutableDictionary *cELLL_imageViews ;
    
    UIImageView * cELLL;
    
    UIImagePickerController *imagePickerController;
}


@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
 @property ( nonatomic, weak )  NSTimer *timerKeyboard;
@property (strong, nonatomic ) UICollectionView    * collectionVieww;


@end


@implementation ViewController

- (NSInteger)collectionView: (UICollectionView *)collectionView
     numberOfItemsInSection: (NSInteger)section {
    
    return [_arrayUserMessage count];
}


- (CGRect )autoCorrection_text:(NSString *)text size:(CGSize)size  {
    
    return [text
     boundingRectWithSize: size
     options: NSStringDrawingUsesLineFragmentOrigin
     attributes: @{ NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody] }
     context: nil];
}

- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView
                  cellForItemAtIndexPath: (NSIndexPath *)indexPath {
    
    CGRect me = [self autoCorrection_text: _arrayUserMessage[indexPath.row]
                                     size: CGSizeMake(230, 1000) ];



    
    MyCollectionViewCell *
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell"forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor clearColor];

    
    //                320                     -  255  =65      -20 - 10 = 30
    // CGRectMake( self.view.frame.size.width -  me.size.width -20 - 10 ,0 , me.size.width + 20 , me.size.height + 20   );
    CGRect rectt_init = CGRectMake( 55  , 0 ,me.size.width +15 /* 245 */, me.size.height + 20 );
    
    //UIColor *lightGreenColor =  [UIColor colorWithRed: 224.0/255.0 green: 255.0/255.0 blue: 196.0/255.0 alpha: 1.0];
    
    
    BOOL textView_not_created =YES;
    
    // Search  textView  in  cell.subview
    for ( id obj in cell.subviews ) {

        if ([ [obj class ] isEqual: [UITextView class]] ) {     textView_not_created = NO;
            
            ((UITextView *)obj).text =  _arrayUserMessage[indexPath.row];
            ((UITextView *)obj).frame = rectt_init;
        }
        
        if ([ [obj class ] isEqual: [UIImageView class]] ) {
            ((UIView *)obj).frame = rectt_init;
        }
        
    }
    
    if (textView_not_created) {
        
        UIView *
        viiew = [UIView new];
        viiew.frame = rectt_init; // 0> 0v  >> vv
        viiew.backgroundColor = [UIColor redColor];
        viiew.layer.cornerRadius = 15;
        [cell addSubview:viiew ];
        
        
        /*
        UIImageView *
        imageView = [UIImageView new];
        imageView.image =  [[ _backgroundImage1 resizableImageWithCapInsets: UIEdgeInsetsMake(22, 26, 22, 26) ]
                            imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ];
        imageView.frame = rectt_init;
        imageView.tintColor = [UIColor whiteColor];
        [cell  addSubview: imageView];
        */
        
        /*
        UIImageView *
        imageView = [UIImageView new];
        imageView.frame = CGRectMake( 15  , 0 , 30 , 30 );
        imageView.image = [UIImage imageNamed:@"diana.jpg"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
       // imageView.layer.cornerRadius  = 15;
        //imageView.layer.masksToBounds = true;
        [cell addSubview: imageView];
        */
        
        UITextView *
        messageTextView = [UITextView new];
        messageTextView.font =  [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageTextView.text = _arrayUserMessage[indexPath.row];
        messageTextView.frame = rectt_init;
         messageTextView.backgroundColor = [UIColor clearColor];
        messageTextView.selectable = 0;
       // messageTextView.layer.cornerRadius = 15;
        [cell addSubview: messageTextView];
    
        
        
        
    }
    
    NSString *name = _arrayUserName[indexPath.row];
    

    
    
         if ([ name isEqualToString: user1   ] ) { }
    else if ([ name isEqualToString: user2   ] ) { }
    



    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    CGRect es = [self autoCorrection_text: _arrayUserMessage[indexPath.row]
                                     size: CGSizeMake(230, 1000) ];

        CGSize size =  CGSizeMake(self.view.frame.size.width, es.size.height +20 );

        return size;
}
/*
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(8, 0, 0, 0);
}
*/


- (void) create_collectionView {
    
    self.collectionVieww = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 0 +65, self.view.frame.size.width  , self.view.frame.size.height - 110  )
                                              collectionViewLayout: [UICollectionViewFlowLayout new]];
    self.collectionVieww.dataSource   = self;
    self.collectionVieww.delegate     = self;
    [self.collectionVieww registerClass: [MyCollectionViewCell class] forCellWithReuseIdentifier: @"MyCell"];
    
    self.collectionVieww.backgroundColor = [UIColor clearColor];
    
    
    [ self.view addSubview: self.collectionVieww ];
}

- (void) create_tableView:(CGRect)rect color:(UIColor *)color {
    
    _tableView = [[UITableView alloc] initWithFrame: rect style: UITableViewStylePlain ];
    _tableView.dataSource   = self;
    _tableView.delegate     = self;
    _tableView.allowsSelection= 0;
    _tableView.allowsSelectionDuringEditing= 0;
    _tableView.allowsMultipleSelection = 0;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = color;
    /*
     _tableView.layer.drawsAsynchronously = false;  // ЦПУ) выполнять отображение слоя в фоновом потоке
     _tableView.layer.shouldRasterize = 1 ;         //true слой рисуется один раз. Всякий раз при его анимировании, он не будет перерисовываться
     _tableView.layer.rasterizationScale = 0;       // = [UIScreen mainScreen].scale;
     */
    
    [ self.view addSubview: _tableView ];
}

- (void) self_view_frame {
    //NSLog(@"Device         %@ " , [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"iPhone" : @"iPad" );
    
    size_t size;
    sysctlbyname("hw.machine", NULL,          & size,    NULL,   0);
    char * machine = malloc(size);
    sysctlbyname("hw.machine", machine,       & size,    NULL,   0);
    //                                 NSString *platform = [NSString stringWithCString: machine encoding: NSUTF8StringEncoding];
    // NSLog(@"iPhone Device  %@" ,[self platformType:platform]);
    // NSLog(@"SystemVersion  iOS %@" , [[UIDevice currentDevice] systemVersion] );
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth  = screenSize.width;
    screenHeight = screenSize.height;
    
    // NSLog(@"size %f %f " , screenWidth , screenHeight ); NSLog(@" ________________ " );
    
}
- (void) create_background_image:(NSString *)nameFile {
    
    UIImageView *imm = [UIImageView new];
    imm.image = [ UIImage imageNamed: @"background.jpg" ];
    imm.frame = CGRectMake(0,0, screenWidth,screenHeight);
    
    imm.layer.drawsAsynchronously = 0; // ЦПУ) выполнять отображение слоя в фоновом потоке
    imm.layer.shouldRasterize = 1 ;
    imm.layer.rasterizationScale = 1;
    
    [ self.view addSubview: imm ];
    
}
- (void) create_field_textInput {
    
    _view2 = [[UIView alloc] initWithFrame: CGRectMake(0, screenHeight - 46 , screenWidth , 66	)];
    _view2.backgroundColor =  [UIColor colorWithRed: 233.0/255.0 green: 233.0/255.0 blue: 233.0/255.0 alpha: 1.0];
    
    
    _messageTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(37, 8, screenWidth - 127, 30)];
    _messageTextField2.borderStyle = UITextBorderStyleRoundedRect;
    _messageTextField2.font = [UIFont systemFontOfSize:14];
    _messageTextField2.placeholder = @"Написать...";
    _messageTextField2.autocorrectionType = UITextAutocorrectionTypeNo;  // отключить подсказки в клавиатуре - которые ее расширяют
    _messageTextField2.keyboardType = UIKeyboardTypeDefault;
    _messageTextField2.returnKeyType = UIReturnKeyDone;
    _messageTextField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    _messageTextField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _messageTextField2.delegate = self;
    [_view2 addSubview: _messageTextField2 ];
    
    UIButton * button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [button addTarget:self  action:@selector(buttonMethod1)  forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Отправить"  forState:UIControlStateNormal];
    [button setExclusiveTouch:YES];
    button.frame = CGRectMake(screenWidth - 85, 8, 77, 30);
    [ _view2 addSubview: button];
    
    UIButton *button2 = [UIButton buttonWithType: UIButtonTypeContactAdd];
    [button2 addTarget:self  action:@selector(buttonMethod2)  forControlEvents:UIControlEventTouchUpInside];
    [button2 setExclusiveTouch:YES];
    button2.frame = CGRectMake(7, 12, 22, 22);
    [ _view2 addSubview: button2];
    
    [ self.view addSubview: _view2 ];
    
}
- (void) create_all_array_massive {

    
    // ________________________________________________________________________________________________
    uuu = 1;
    _keyboardOpen       = 0;
    _keyboardOpenStart  = 1;
    
    _arrayUserName              = [ NSMutableArray       new ];
    _arrayUserMessageSize       = [ NSMutableArray       new ];
    _arrayUserMessage           = [ NSMutableArray       new ];  // text or photo
    
    _cells                      = [ NSMutableDictionary  new ];
    _arrayPhotoURL              = [ NSMutableDictionary  new ];
    _arrayLocationCoordinate    = [ NSMutableDictionary  new ];
    _arrayDate                  = [ NSMutableDictionary  new ];
    
    cELLL_index                 = [ NSMutableArray       new ];
    cELLL_imageViews            = [ NSMutableDictionary  new ];
    // ________________________________________________________________________________________________
    // bubble
    
    _backgroundImage1 = [UIImage imageNamed: @"bubble_gray.png"];
    _backgroundImage2 = [UIImage imageNamed: @"bubble_blue.png"];
    // ________________________________________________________________________________________________
    
    user1 = @"user1" ;
    user2 = @"user2" ;
    
    _MyName2  = [NSString stringWithFormat: @"%@ %@" ,_userBot.name , _userBot.password ];
    _MyName1  = [NSString stringWithFormat: @"%@ %@" , _userBot.userRegistration.name , _userBot.userRegistration.passsword ];
    // ________________________________________________________________________________________________

    _MyPhoto2 = [UIImage imageWithData: _userBot.photo];
    _MyPhoto1 = [UIImage imageWithData: _userBot.userRegistration.photo];
    
    //NSLog(@"%@",_MyPhoto1);
    
    
    CGFloat i1;
    
    i1 = _MyPhoto1.size.width  / 75; // i_10 = 2000 /  200
    i1 = _MyPhoto1.size.height / i1; //  128 = 1280 / i_10
    
    _MyPhoto1 = [ self imageRect: _MyPhoto1
                            size: CGSizeMake( 75 , i1 ) ];   //  NSLog(@"%f %f",image.size.width,image.size.height);
    
    i1 = _MyPhoto2.size.width  / 75; // i_10 = 2000 /  200
    i1 = _MyPhoto2.size.height / i1; //  128 = 1280 / i_10
    
    _MyPhoto2 = [ self imageRect: _MyPhoto2
                            size: CGSizeMake( 75 , i1 ) ];   //  NSLog(@"%f %f",image.size.width,image.size.height);
    
    
    // ________________________________________________________________________________________________

}
- (void) create_gesture_hide_keyboard {
    // создание прикосновения
    
    UITapGestureRecognizer * touchHold = [ UITapGestureRecognizer alloc ];
    touchHold.delegate = self;
    [ _tableView addGestureRecognizer: touchHold ];
    
    [ self.view addGestureRecognizer:[ [UITapGestureRecognizer  alloc] initWithTarget: self action: @selector(tapPress: )] ];
    // [ self.view addGestureRecognizer:[ [UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(longPress: )] ];
}
- (void) create_audio_player {
    NSURL * soundURL = [[NSBundle mainBundle] URLForResource: @"button2" withExtension: @"mp3"];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: soundURL error: nil ];

}
- (void) load_historyMessage_in_database {
    
    // ________________________________________________________________________________________________
    // 1 добавление сообщений от бота  textview
    
    //NSLog(@"загрузка истории из бд ");
    
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName: @"HistoryMessages"];
    fetchRequest2.predicate = [NSPredicate predicateWithFormat: @"whoTook = %@",_userBot];
    // 	И применяем запрос к контексту - возращает массив с данными
    NSArray *userMessages = [ _managedObjectContext executeFetchRequest: fetchRequest2  error: nil ];
    // NSLog(@"%@ ",userMessages);
    for ( HistoryMessages * messages in userMessages  ) {
        
        [ _arrayUserName    addObject: messages.name ];
        
        if (messages.time) {
            //NSLog(@"_____%@ %@",messages.time, [NSString stringWithFormat:@"%d",[_arrayUserName count] ]);
            
            [_arrayDate setObject: messages.time
                           forKey: [NSString stringWithFormat:@"%d",[_arrayUserName count] ] ];
        }
        
        //[ _;arrayDate  ];
        
        if (!!messages.messageText) { [ _arrayUserMessage addObject: messages.messageText ];    }
        else                        { [ _arrayUserMessage addObject: [UIImage imageWithData: messages.messagePhoto]  ];
            
            if (  messages.locationCordinate1.doubleValue ) { NSLog(@"есть локация %d",!!messages.locationCordinate1);
                Cordinatee *cordinate = [Cordinatee new] ; NSLog(@"есть локация %f", messages.locationCordinate1.doubleValue);
                cordinate.latitude  = messages.locationCordinate1.doubleValue;
                cordinate.longitude = messages.locationCordinate2.doubleValue;
                
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow: [_arrayUserName count]-1 inSection: 0 ];
                [ _arrayLocationCoordinate setObject: cordinate
                                              forKey: indexPath ];
            }
            else {
                
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow: [_arrayUserName count]-1 inSection:0];
                
                [ _arrayPhotoURL     setObject: [NSURL URLWithString: messages.photoURL ]   forKey: indexPath ];
                
            }
        }
        /*
         
         if (messages.)*/
        
        [ _arrayUserMessageSize addObject:  [NSIndexPath indexPathForRow: ((NSNumber *) messages.messageSize).integerValue inSection:0] ];
        
    }
    
    /*
    [self specialMethod: user1  subtitle: @"Татарскими детьми"  ];
    
    [self specialMethod: user2  subtitle: @"Твоя родственница?" ];
    [self specialMethod: user2  subtitle: @"Тебе нравится играть с детьми?" ];
    [self specialMethod: user2  subtitle: @"Вопрос без подвоха )))" ];
    
    [self specialMethod: user1  subtitle: @"Да это дочь моего двоюродного брата , к которому я как раз поехал"];
    
    [self specialMethod: user1  subtitle: @"Ну с 1-ой стороны дети тупые хуесосы ебаные...\n\
    Особенно матери - овуляторы, поехавшие на теме детей ...\n\
    \n\
    А с другой стороны, дети милые прекрасные позитивные ... Постоянно ржут, прыгают , зовут ловить с ними бабочек )))))00)00))\n\
    \n\
    Там еще вторая её сестра есть , она забрала себе бабочку ...\n\
    После этого она заплакала , типа какого хуя мою бабочку отобрали\n\
    \n\
     На фотке, мы домик из игральных карт собираем"];
    */
    
    // [self specialMethod:@"Ди на Шурыгина" subtitle: @"Как дела ?" ];
    // [self specialMethod:@"Диан  Шурыгина" subtitle:  @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda." ];
    
    
    
}
- (void) load_first_Space_in_database {
    
    NSFetchRequest * fetchRequest3 = [[NSFetchRequest alloc] initWithEntityName: @"HistoryMessages"];
    fetchRequest3.predicate = [NSPredicate predicateWithFormat: @"whoTook = %@",_userBot];
    NSArray *messages = [ _managedObjectContext executeFetchRequest: fetchRequest3  error: nil ];
    
    
    if ([messages count] == 0) { // если есть хоть 1 сообщение не добавлять больше пробела      тоесть если есть 1 пробел - 2 уже не зайдет
        
        // NSLog(@"добавление пробела 1 раз    %d ", (int)screenHeight - 110);
        CGFloat y = screenHeight - 110 ; // 480 - 220 + 60
        NSIndexPath *newIndexPath2 = [NSIndexPath indexPathForRow: y inSection:0];
        [ _arrayUserMessageSize addObject: newIndexPath2  ];
        [ _arrayUserMessage     addObject: @"" ];
        [ _arrayUserName        addObject: @"" ];
        
        
        // 	создать прототип  UserRegistration
        HistoryMessages *newMessages = [NSEntityDescription  insertNewObjectForEntityForName: @"HistoryMessages" // поиск сущности по имени
                                                                      inManagedObjectContext: _managedObjectContext];	// контекст
        if ( newMessages != nil) 	{	// если найден
            newMessages.name         = @"";	// добавить данные
            newMessages.messageText  = @"";
            newMessages.messageSize  = [NSNumber numberWithInteger:  newIndexPath2.row];
            
            newMessages.whoTook = _userBot;
            
            [self.managedObjectContext save: nil];  // сохранение, контекста  	не обязательно - он и так сохраняет
        }
        
    }
}

#pragma "###############################################################################################################"
#pragma "###############################################################################################################"

#pragma '_____ инициализаторы #################################################################################'

#pragma         расшифровка версий iOS
- (NSString *) platformType:(NSString *)platform {
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator x86 32";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator x64";
    return platform;
}
- (IBAction)endChat:(UIBarButtonItem *)sender { [self.navigationController popToRootViewControllerAnimated:YES]; }
#pragma         какой текущий девайс ? его размеры
#pragma         создать  фоновое изображение
#pragma         создать  TableView
#pragma         создать  прикосновение, что бы скрыть клаву
#pragma         создать  view и TextField, внизу, для ввода сообщений
#pragma         создать  звук сообщения
#pragma         загрузить прототип изображения  bubble
#pragma         BOOL значения, 1-ое для октрытия клавиатуры при старте - 2-ое для того что бы прикосновение не реагировало на клаву дважды-трижды
#pragma         создать  все массивы, задача которых, хранить значения каждой отдельной ячейки
#pragma         добавить  начальные сообщения от бота
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    UIView *viiew = [UIView new];
    viiew.frame = CGRectMake(0,70,55,2); // 0> 0v  >> vv
    viiew.backgroundColor = [UIColor redColor];
    [self.view addSubview:viiew ];
    
    UIView *viiew2 = [UIView new];
    viiew2.frame = CGRectMake(55,75,self.view.frame.size.width - 55 - 10 ,2); // 0> 0v  >> vv
    viiew2.backgroundColor = [UIColor redColor];
    [self.view addSubview:viiew2 ];
    */
//            viiew
    
    
    self.title = [NSString stringWithFormat:@"%@ %@", _userBot.name , _userBot.password ] ;

    [self self_view_frame];
   // [self create_background_image:@"background.jpg"];   // установка фонового изображения
   // [self create_collectionView];
   // [self create_tableView: CGRectMake(0, 0 +65, screenWidth, screenHeight - 110 ) color:[UIColor clearColor] ];
    
    [self create_gesture_hide_keyboard]; // создание прикосновения
    [self create_field_textInput];  // установка поля для ввода

    [self create_audio_player];         // установка звука          - ошибка возникает иза того что    Breakpoint ставишь в Xcode
    [self create_all_array_massive]; // установка всех массивов
    
    [self load_historyMessage_in_database ]; // загрузка истории из бд
    // ________________________________________________________________________________________________
    if ([_arrayUserMessage count] != 0) {  [self update]; }
    [self load_first_Space_in_database];    // загрузка пробела
    if ([_arrayUserMessage count] != 0) {  [self update]; }
    
    
}
#pragma  открыть фотографию
-(void)tapPress  : (UITapGestureRecognizer*) gestureRecognizer {

    
    // выясняем позицию на экране
    CGPoint touchPoint = [gestureRecognizer locationInView: _tableView ];
    // какая ячейка исходя из позиции
    NSIndexPath * indexPath = [ _tableView  indexPathForRowAtPoint: touchPoint ];  //NSLog(@"номер ячейки = %d",(int)indexPath.row);
    
    
    // если ячека есть
    if ( indexPath ) {
        // задевает ли позиция , размеров фотографии
        if ( (42 < touchPoint.x) && (touchPoint.x < (42 + screenWidth - 110)) ) { //NSLog(@" задевает ли позиция = 1" );
            
            // сообщение является изображением ?
            id obj =  _arrayUserMessage[indexPath.row] ;
            if ([obj class] == [UIImage class]) {               //NSLog(@" сообщение является изображением = 1" );
                
                if ( [  _arrayPhotoURL objectForKey: indexPath] ) {
                    NSURL *url  = [ _arrayPhotoURL objectForKey: indexPath];
                    //NSLog(@"%@",url);
                    // запуск перехода - передать изображение
                    [self performSegueWithIdentifier: @"Photo"
                                              sender: @[url] ];
                }
                if ( [  _arrayLocationCoordinate objectForKey: indexPath] ) {
                    Cordinatee *cordinatee = [ _arrayLocationCoordinate objectForKey: indexPath];

                    [self performSegueWithIdentifier: @"Map"
                                              sender: cordinatee ];
                }
            }

        }

    }

}
-(void)longPress : (UILongPressGestureRecognizer *)longPressGestureRecognizer {
    
    if ( longPressGestureRecognizer.state == UIGestureRecognizerStateBegan   ) {
        
        CGPoint touchPoint = [longPressGestureRecognizer locationInView: _tableView];
        
        //cELLL.tintColor = [UIColor clearColor];
        
        NSIndexPath * indexPath = [ _tableView  indexPathForRowAtPoint: touchPoint ];
        if ( indexPath ) {
            
            for ( NSIndexPath *index in cELLL_index ) {
                if (indexPath.row == index.row) return;
            }
            

            
            // NSLog(@"TYT1 %d",indexPath.row);
            UITableViewCell * cell =[ _tableView  cellForRowAtIndexPath: indexPath ];
            
            NSArray *subviewws = [cell subviews];

            UIImageView *imageView = [UIImageView new];
            
            NSString *obj =  _arrayUserName[indexPath.row] ;
            if ( [obj isEqualToString: user2] ) {
            imageView.image =  [[ _backgroundImage1
                                 resizableImageWithCapInsets: UIEdgeInsetsMake(22, 26, 22, 26) ]
                                imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ];
            //-14 -3 +24 +6
            imageView.frame = CGRectMake( ((UIView *)subviewws[2]).frame.origin.x - 14,
                                         ((UIView *)subviewws[2]).frame.origin.y - 3 ,
                                         ((UIView *)subviewws[2]).frame.size.width + 24,
                                         ((UIView *)subviewws[2]).frame.size.height + 6);
            
            imageView.tintColor = [UIColor colorWithRed: 0/255.0 green: 122.0/255.0 blue: 255.0/255.0 alpha: 0.3];

            
            
            [cell addSubview:imageView];
            }
            else if ( [obj isEqualToString: user1] ) {
                imageView.image =  [[ _backgroundImage2
                                     resizableImageWithCapInsets: UIEdgeInsetsMake(22, 26, 22, 26) ]
                                    imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ];
                imageView.frame = CGRectMake( ((UIView *)subviewws[2]).frame.origin.x - 10,
                                             ((UIView *)subviewws[2]).frame.origin.y - 3 ,
                                             ((UIView *)subviewws[2]).frame.size.width + 26,
                                             ((UIView *)subviewws[2]).frame.size.height + 6);
                
                imageView.tintColor = [UIColor colorWithRed: 0/255.0 green: 122.0/255.0 blue: 255.0/255.0 alpha: 0.3];
                
                
                
                [cell addSubview:imageView];
            
            }
            
            [cELLL_index        addObject: indexPath];
            [cELLL_imageViews   setObject: imageView forKey:indexPath];
            
     
          //  UIView *bgColorView = [[UIView alloc] init];
          //  cell.backgroundColor =   [UIColor colorWithRed: 0/255.0 green: 122.0/255.0 blue: 255.0/255.0 alpha: 0.5];
          //  [cell setSelectedBackgroundView:bgColorView];
     
        }
    }
    
    
}

#pragma '_____ клавиатура  #################################################################################'

#pragma _____ Показываем клавиатуру, как только попадаем на контроллер  ________________________________________
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // NSLog(@" входит 2  ");
    
    if ( _keyboardOpenStart ) { _keyboardOpenStart=0 ;
    //static dispatch_once_t once;
    //dispatch_once(&once, ^{
        [_messageTextField2 becomeFirstResponder];
    //});
    }
}

#pragma _____ переместить TableView и TextField при открытии клавиатуры, анимированно ________________________________
- (void)viewWillAppear:   (BOOL)animated {
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    
    int i=0;
    for ( NSIndexPath *index in _arrayUserMessageSize) {
        //NSLog(@"%d",index.row);
        i = i + index.row;
    }
    //NSLog(@"%d",i);
    int y;
    if(((screenHeight-262)-i) < 65 ) y = 65;
    else y = ((screenHeight-262)-i);
    
    int x; // NSLog(@"%d",i);
    if(i > 153 ) x = 153;
    else x = i;
    

    //_tableView.backgroundColor = [UIColor colorWithRed: 155.0/255.0 green: 55.0/255.0 blue: 233.0/255.0 alpha: 0.3];
    //_view2.backgroundColor = [UIColor colorWithRed: 15.0/255.0 green: 55.0/255.0 blue: 13.0/255.0 alpha: 0.2];
    
    NSDictionary *userInfo = [notification userInfo];
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] intValue] << 16
                     animations:^{

                             _view2.frame = CGRectMake( 0 , screenHeight - 262, screenWidth , 66          );
                         _tableView.frame = CGRectMake( 0 , 0 -152 , screenWidth ,  screenHeight - 110 );
                         
                       /*  NSLog(@" %f %f %f %f ",
                               _tableView.frame.origin.x    ,
                               _tableView.frame.origin.y    ,
                               _tableView.frame.size.width  ,
                               _tableView.frame.size.height  );*/
                         
                     } completion:^(BOOL finished) {  }];
    


    
    
    // [self update];
                     //[NSTimer scheduledTimerWithTimeInterval: 1.6/*0.25*/ target: self selector: @selector(timer_method_update2 ) userInfo: nil repeats: NO];
   // _timerKeyboard = [NSTimer scheduledTimerWithTimeInterval: 0.4/*0.5 */ target: self selector: @selector(timer_method_update  ) userInfo: nil repeats: NO];
}
- (void) timer_method_update2 {
    [self update];
}
- (void) timer_method_update  {
    //_tableView.frame     = CGRectMake( 0 , 65 /*57*/                , screenWidth , screenHeight - 327	);/* NSLog(@" _tableView.frame  ^ 3.5 sec");*/
    //[self update];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    int i=0;
    for ( NSIndexPath *index in _arrayUserMessageSize) {
        //NSLog(@"%d",index.row);
        i = i + index.row;
    }
    //NSLog(@"%d",i);
    
    int y;
    if(((screenHeight-45)-i) < 65 ) y = 65;
    else y = ((screenHeight-45)-i);
    
    int x; //NSLog(@"%d",i);
    if(i > 370 ) x = 370;
    else x = i;
    



    
    NSDictionary *userInfo = [notification userInfo];
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] intValue] << 16
                     animations:^{
                         _view2.frame     = CGRectMake( 0 , screenHeight - 45 , screenWidth  , 66     );
                         _tableView.frame = CGRectMake( 0 ,  0 + 65 , screenWidth  , screenHeight - 110 ); // 305
                         
                        /* NSLog(@" %f %f %f %f ",
                               _tableView.frame.origin.x    ,
                               _tableView.frame.origin.y    ,
                               _tableView.frame.size.width  ,
                               _tableView.frame.size.height  );*/
                         
                   } completion:^(BOOL finished) {  }];
    

    
    
    //[NSTimer scheduledTimerWithTimeInterval: 0.5/*0.25*/ target: self selector: @selector(timer_method_update2 ) userInfo: nil repeats: NO];
}

#pragma _____ обновление ячеек ____________________________________________________________________________________
- (void)update { //
    
    // NSLog(@"=2=");
    [_tableView reloadData];
    // передвигает ячейки после заполнения  TableView
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[ _arrayUserName count]-1 inSection:0]
                      atScrollPosition:UITableViewScrollPositionBottom
                              animated:1];
}

#pragma _____ запускается клава ________________________________________________________________________________
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [ UIView  animateWithDuration: 0.3
                            delay: 0.0
                          options: UIViewAnimationOptionCurveEaseInOut
                       animations: ^{
                           
                           // _view2.frame = CGRectMake(0, 220, 320, 46	);
                       }
                       completion: ^(BOOL fin){ if(fin){ }
                       }];
    _keyboardOpen = 1;
    
}
#pragma _____ приксновение ________________________________________________________________________________
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch  {
    
    [self keyboardOff];
    return YES;
 
}

#pragma _____ скролинг начался ________________________________________________________________________________
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    
    for ( NSIndexPath *index in cELLL_index ) {
        UIImageView *imageView = [cELLL_imageViews objectForKey: index];
                     imageView.tintColor = [UIColor clearColor];
    }
    [cELLL_imageViews removeAllObjects];
    [cELLL_index removeAllObjects];
    //cELLL.tintColor = [UIColor clearColor];

}
#pragma _____ кнопка Return ________________________________________________________________________________
- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
    [self keyboardOff]; return YES;
    
}
#pragma _____ клава выключается ________________________________________________________________________________
- (void)keyboardOff {
    
    if (_keyboardOpen) {
        
        [ _timerKeyboard invalidate];	// отключить таймер

         [_messageTextField2 resignFirstResponder];  // выключить клаву
        _keyboardOpen = 0;
        
    }
    
    
}



#pragma '_____ фото редакторы  #################################################################################'

#pragma _____ перекрашивание изображения _________________________________________________________________________
- (UIImage *)overlayImage:(UIImage *)image
                withColor:(UIColor *)color {
    
    //  Create rect to fit the PNG image
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    //  Start drawing
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    //  Fill the rect by the final color
    [color setFill];
    CGContextFillRect(context, rect);
    
    //  Make the final shape by masking the drawn color with the images alpha values
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    [image drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1];
    
    //  Create new image from the context
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    //  Release context
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma _____ уменьшение размеров изображения _____________________________________________________________________
- (UIImage *)imageRect:(UIImage *)image2
                  size:(CGSize )size {
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);     // Создает графический контекст (размер, не-прозрачный, масштаб)
    [ image2 drawInRect: CGRectMake(0, 0, size.width, size.height)];    // масштабируется изображение (self) для подгонки
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();    			// вернет — представление текущего контекста в качестве изображения
    UIGraphicsEndImageContext();                                //  закрыть контекст
    
    return resizedImage;
}


#pragma ' бот сообщения ###########################################################################################'

#pragma _____ отправить сообщение ________________________________________________________________________________
- (void)buttonMethod1 {
    /*
    int c = [_arrayUserMessageSize count];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:c-1 inSection:0];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [_tableView scrollToRowAtIndexPath:indexPath
                                           atScrollPosition:UITableViewScrollPositionTop
                                                   animated:NO];
                     }];
    */


    
    
    
    NSString * message = _messageTextField2.text ;
    
    message = [message stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet] ];
    
    if (!( [message isEqualToString: @""] )) {
        
        // NSLog(@"отправить сообщение");
        
        [self specialMethod: user1
                   subtitle: message ];
        
        [self update];

        
        // _______________________________________________
        int i;
        int d1 = (arc4random() % 100 );
        if ( d1 < 80 ) { i = (arc4random() %  4); } //NSLog(@"=1");
        else           { i = (arc4random() % 11); } //NSLog(@"=2"); }

        if(i==0) i=1;
        // NSLog(@"рандом %d",i);
        [NSTimer scheduledTimerWithTimeInterval: i 	// таймер на 1 секунду
                                         target: self
                                       selector: @selector(timer_method: ) 	// метод запускаемый
                                       userInfo: message
                                        repeats: NO];					// повторять
        _messageTextField2.text = @"";
        
        
    }
    
}

#pragma _____ бот - ответ на мои сообщения, рандомное опоздание ___________________________________________________
- (void)timer_method:(NSTimer*)timer  {
    NSString *i = [timer userInfo];
    //NSLog(@"! %@",i);
    
    [self specialMethod: user2
               subtitle: i ];
    
    [self update];
    //NSLog(@"%@",_audioPlayer);
  
    [_audioPlayer play];
}



#pragma ' бибилиотека фото и геолокация ##########################################################################'

#pragma _____ добавить ActionSheet - фото, геолокацию ______________________________________________________________
- (void)buttonMethod2 {
    [self keyboardOff];

    
    // пример создание 		Если ты хочешь создать предупреждение
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Добавить"
                                                       delegate:self
                                              cancelButtonTitle:@"Отменить"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Фотографию из библиотеки",@"Геолокацию",  nil];
    // popup.tag = 1;
    [popup showInView: self.view];
    
}

#pragma _____ делегат UIActionSheet - переход на карту - и библиотеку фотогрфий пользователя _____________________
- (void) actionSheet:(UIActionSheet *)popup
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        // NSLog(@"0");
          //  dispatch_sync	(queue, ^{ });

        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        //uiipc.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie]; // тип файла (формат сохранения)
        //  мы установим тип источника, равный Camera
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // Тип интерфейса, который будет отображаться
        //uiipc.allowsEditing = YES; // Логическое значение, указывающее, разрешено ли пользователю редактировать изображение

        //dispatch_queue_t queue = dispatch_queue_create("name",NULL);
       // dispatch_async( queue , ^{
            
        
        [self presentViewController: imagePickerController  // Модальный запуск - либо фотокамеры/видео  либо библиотеки
                           animated: YES
                         completion: NULL];
       // });
        
    }
    else if (buttonIndex == 1) {
        // NSLog(@"1");
        //  когда програмно хотим осуществить переход 		 нужно запустить  prepareForSegue: sender: ↓
        [self performSegueWithIdentifier:@"123" 	// и передаем ему идентификатор
                                  sender: nil ];  			// и объект который хотим передать
        
    }
    
}
#pragma _______________________________________________________________________________________________
- (void)prepareForSegue: (UIStoryboardSegue *)segue // мы получим указатель View на который мы переходим	- это segue
                 sender: (id)sender {
    
   // NSLog(@"%@", segue.identifier);
    
    if ([ segue.identifier isEqualToString: @"Map" ]) {

        CordinateMapView *mapview = (CordinateMapView *)segue.destinationViewController;
        Cordinatee *cordinatee = sender;
        [mapview location: cordinatee];
    }
    if ([ segue.identifier isEqualToString: @"Photo" ]) {
        ImageViewController *imgview = (ImageViewController *)segue.destinationViewController;
        imgview.imageURL = sender[0] ;
        
    }

    
}

#pragma ' бибилиотека фото'

#pragma _____ navigationController - переход на библиотеку фотографий - добвление кнопки Отмена - и титул Фотографии ___
- (void) navigationController: (UINavigationController *) navigationController
       willShowViewController: (UIViewController *) viewController
                     animated: (BOOL) animated {
    /*
    if (imagePickerController.sourceType ==  UIImagePickerControllerSourceTypeCamera) {
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                target:self
                                                                                action:@selector(showCamera:)];
        viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:button];
    } else { */
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle: @"Отмена"
                                                               style: UIBarButtonItemStylePlain
                                                              target: self
                                                              action: @selector(showLibrary:)];
    
    viewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:button];
    viewController.navigationItem.title = @"Фотографии";
 // viewController.navigationController.navigationBarHidden = NO; // important
    
}

#pragma _____ navigationController - перемещение назад - из бибилиотеки фотографий ______________________________________
- (void) showLibrary: (id) sender {

    [self.presentedViewController dismissViewControllerAnimated: YES // контроллер который представил этот класс 	UIViewController
                                                     completion: NULL ]; // 	dismissViewControllerAnimated 	удаляет с экрана этот класс
}

#pragma _____ возращает изображение - из библитеки фотографий ____ преобразуем в сообщение от моего имени ________________
- (void)imagePickerController: (UIImagePickerController *)picker
didFinishPickingMediaWithInfo: (NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSURL *url   = info[UIImagePickerControllerReferenceURL ];
    
    
    
    [ self specialMethod3: @"фото"
                    image: image//[image fixOrientation]
                      url: url ]; // оригиналом

    
    [self update];
    
    [ self dismissViewControllerAnimated: YES
                              completion: NULL];
}

#pragma '  геолокация'

#pragma _____ метод для геолокации - возращает скиншот карты _____ преобразуем в сообщение от моего имени_________________
- (void)geoPhoto:(UIImage *)image
       cordinate:(Cordinatee *)cordinate  {
    


    
    [ self specialMethod3: @"гео"
                    image: image
                cordinate: cordinate]; // оригиналом
    [self update];
    
    [ self dismissViewControllerAnimated: YES
                              completion: NULL];
}


#pragma "###############################################################################################################"
#pragma "###############################################################################################################"


#pragma 'ячейки - расчет размеров #################################################################################'


#pragma _____ узнать размер для ячейки   и создать  bubble ________________________________________________________
- (void)specialMethod: (NSString *)title
             subtitle: (NSString *)subtitle {
    
    
    
    //NSLog(@"сохранение в бд");
    // ____________________________________________________________________________________________________________________
    //NSLog(@"создание пробела один раз в бд");
    
                                                     NSFetchRequest * fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName: @"HistoryMessages"];
                                                                      fetchRequest2.predicate = [NSPredicate predicateWithFormat: @"whoTook = %@", _userBot];
    NSArray * messages = [ _managedObjectContext executeFetchRequest: fetchRequest2 error: nil ];
    if (     [messages count    ] == 0) {
                                                                                 CGFloat y = screenHeight -220 +60 ;
                             NSIndexPath * newIndexPath2 = [NSIndexPath indexPathForRow: y inSection:0];
        [ _arrayUserMessageSize addObject: newIndexPath2  ];
        [ _arrayUserMessage     addObject: @"" ];
        [ _arrayUserName        addObject: @"" ];
 
        // 	создать прототип  UserRegistration
        HistoryMessages *
             newMessages = [ NSEntityDescription insertNewObjectForEntityForName: @"HistoryMessages" inManagedObjectContext: _managedObjectContext ];
        if ( newMessages != nil ) {	// если найден
             newMessages.name         = @"";	// добавить данные
             newMessages.messageText  = @"";
             newMessages.messageSize  = [ NSNumber numberWithInteger: newIndexPath2.row ];

             newMessages.whoTook      = _userBot;
            
            [self.managedObjectContext save: nil];  // сохранение, контекста  	не обязательно - он и так сохраняет
        }
        
    }
    // ____________________________________________________________________________________________________________________
    
    [ _arrayUserName    addObject: title    ];
    [ _arrayUserMessage addObject: subtitle ];
    
    
     //NSLog(@"%@", [NSString stringWithFormat:@"%d",[_arrayUserName count] ] );
    [ _arrayDate    setObject: [NSDate date]
                       forKey: [NSString stringWithFormat:@"%d",[_arrayUserName count] ] ];
    

    
    // ---------------------------------------------------------------------------------------------------------
    UITextView *textView = [UITextView new];
    textView.frame = CGRectMake(0, 70,(screenWidth - 120), 413); //   320 - 16 = 304 	 480         320 - 184  = 136
    
    NSString *text1 = [ NSString stringWithFormat:@"%@\n", title ];
    NSString *text2 =  subtitle;
    // ---------------------------------------------------------------------------------------------------------
    UIFont *text1Font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    NSMutableAttributedString *attributedString1 =
    [[NSMutableAttributedString alloc] initWithString:text1 attributes:@{ NSFontAttributeName : text1Font }];
    // ---------------------------------------------------------------------------------------------------------
    UIFont *text2Font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    NSMutableAttributedString *attributedString2 =
    [[NSMutableAttributedString alloc] initWithString:text2 attributes:@{NSFontAttributeName : text2Font }];
    // ---------------------------------------------------------------------------------------------------------
    
    [attributedString1 appendAttributedString: attributedString2];
    
    // ---------------------------------------------------------------------------------------------------------
    textView.attributedText = attributedString1;
    
    // ---------------------------------------------------------------------------------------------------------
    [textView sizeToFit];
    
    
    
    // ---------------------------------------------------------------------------------------------------------
    
                                                                            CGFloat y = 54;
                                              if (textView.frame.size.height > 30 ) y = 10 + textView.frame.size.height;
                         NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow: y inSection:0];
    [ _arrayUserMessageSize addObject: newIndexPath  ]; //NSLog(@"%f",y);
    [self endterSize:(int)newIndexPath.row ];
    // ---------------------------------------------------------------------------------------------------------
    
    // 	создать прототип  UserRegistration
    HistoryMessages *newMessages = [NSEntityDescription  insertNewObjectForEntityForName: @"HistoryMessages" // поиск сущности по имени
                                                                  inManagedObjectContext: _managedObjectContext];	// контекст
    if ( newMessages != nil) 	{	// если найден
        newMessages.name       = title;	// добавить данные
        newMessages.messageText  = subtitle;
        newMessages.messageSize  = [NSNumber numberWithInteger:  newIndexPath.row];
        newMessages.time =  [NSDate date];
      //  NSLog(@" %d ", !!!!!!!!!!!!newMessages.messagePhoto );
        /*
        newMessages.photoURL;
        newMessages.locationCordinate1;
        newMessages.locationCordinate2;*/
        
        
        newMessages.whoTook = _userBot;
        
        [self.managedObjectContext save: nil];  // сохранение, контекста  	не обязательно - он и так сохраняет
        
        
    }
    
}
// ____________________________________________________________________________________________________________
int uuu = 1;
- (IBAction)endterSize:(int)minus {
    
    if (uuu) {
        
        NSIndexPath *newIndexPath = _arrayUserMessageSize[ 0 ];
        int i =     (int)newIndexPath.row - minus ;    // NSLog(@"уменьшение пробела  saveБД  %d - %d = %d", newIndexPath.row , minus , i );
        if ( i > 5 ) { //  2
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow: i inSection:0];
            _arrayUserMessageSize[ 0 ] = indexPath;
            [self update];
        }
        else {         // NSLog(@"предел пробела      saveБД  %d",5);
            uuu = 0;
            i = 5;
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow: 5 inSection:0];
            _arrayUserMessageSize[ 0 ] =  indexPath;
            [self update];
        }
        
        NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] initWithEntityName: @"HistoryMessages"];
        
        
        NSPredicate *compoundPredicate  = [NSCompoundPredicate andPredicateWithSubpredicates:
                                           @[ [NSPredicate predicateWithFormat: @"whoTook = %@",_userBot]  ,
                                              [NSPredicate predicateWithFormat: @"name = %@", @"" ] ]
                                           ];
        
        fetchRequest3.predicate = compoundPredicate;
        // 	И применяем запрос к контексту - возращает массив с данными
                               NSArray *messages = [ _managedObjectContext executeFetchRequest: fetchRequest3  error: nil ];
        HistoryMessages *newMessages = [messages lastObject];
        if ( newMessages != nil) 	{	// если найден
             newMessages.messageSize  = [NSNumber numberWithInteger: i ];
            
            [self.managedObjectContext save: nil];  // сохранение, контекста  	не обязательно - он и так сохраняет
        }
        
        
    }
}

// _____________________________________________________________________________________________________________
- (UITableViewCell *)specialMethod2: (NSString *)title
                           subtitle: (NSString *)subtitle
                               cell: (UITableViewCell *)cell
                              index: (NSInteger)index {
    
    UIView *vieww = [UIView new];
    
    
    // ---------------------------------------------------------------------------------------------------------
    UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(70, 0 , (screenWidth - 120) , 613 )];
    // textView.frame = CGRectMake(70, 0 , 200, 413 );
    
    // textView.text = [ NSString stringWithFormat:@"%@\n %@", title, subtitle ];
    textView.scrollEnabled = NO;
    textView.editable = NO;
    textView.selectable = NO;
    textView.backgroundColor = [UIColor clearColor];
    
    // ---------------------------------------------------------------------------------------------------------
    NSString *text1 = [ NSString stringWithFormat:@"%@\n", title ];
    NSString *text2 =  subtitle;
    // ---------------------------------------------------------------------------------------------------------
    UIFont *text1Font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString: text1
                                                                                          attributes: @{ NSFontAttributeName : text1Font }];
    // ---------------------------------------------------------------------------------------------------------
    UIFont *text2Font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    NSMutableAttributedString *attributedString2 =
    [[NSMutableAttributedString alloc] initWithString:text2 attributes:@{NSFontAttributeName : text2Font }];
    // ---------------------------------------------------------------------------------------------------------
    [attributedString1 appendAttributedString: attributedString2];
    // ---------------------------------------------------------------------------------------------------------
    textView.attributedText = attributedString1;
    
    
    // ---------------------------------------------------------------------------------------------------------
    [textView sizeToFit];
    // ---------------------------------------------------------------------------------------------------------
    
    
    //NSLog(@"%@", [NSString stringWithFormat:@"%d",index+1] );
    NSDate *date = [_arrayDate  objectForKey: [NSString stringWithFormat:@"%d",index +1] ];
  //  NSLog(@"%@ %@ %@",date,title,subtitle);
    
    UILabel * label2 = [UILabel new];

            NSDateFormatter * dateFormatterStr = [NSDateFormatter new];
    [ dateFormatterStr setDateFormat: @"HH:mm"];
    
    label2.text       = [ dateFormatterStr stringFromDate: date ] ;
    label2.font       = [ label2.font fontWithSize:10];
    label2.textColor  = [ UIColor darkGrayColor];
    label2.alpha = 0.6;
    
    if ( [title  isEqual: _MyName2 ] ) {
        
        vieww.frame  = CGRectMake( textView.frame.origin.x   - 7  ,
                                  textView.frame.origin.y        ,
                                  textView.frame.size.width + 14 ,
                                  textView.frame.size.height       );
        
        
        label2.frame = CGRectMake(  textView.frame.size.width +20 , textView.frame.size.height - 17  , 30, 15);
        [vieww addSubview: label2];
        
    }
    else {
        // зеленый цвет
        // vieww.backgroundColor = [UIColor colorWithRed: 224.0/255.0 green: 255.0/255.0 blue: 196.0/255.0 alpha: 1.0];
        
        // выравнивание по правому краю
        textView.frame = CGRectMake(  (screenWidth - ( textView.frame.origin.x + textView.frame.size.width )) ,
                                    textView.frame.origin.y    ,
                                    textView.frame.size.width  ,
                                    textView.frame.size.height   );
        
        vieww.frame  = CGRectMake( textView.frame.origin.x   - 7  ,
                                  textView.frame.origin.y        ,
                                  textView.frame.size.width + 14 ,
                                  textView.frame.size.height       );
        

        label2.frame = CGRectMake( - 35 , textView.frame.size.height - 17 , 30, 15);
        [vieww addSubview: label2];
        
    }
    

    
    UIImageView  *backgroundImage = [UIImageView new]; NSIndexPath *newIndexPath = _arrayUserMessageSize[ index ];
                  backgroundImage.frame = CGRectMake( -3.5 ,        newIndexPath.row - 40 , 35, 35);
    
    vieww.backgroundColor = [UIColor clearColor];
    
    
    

    
    
    
    
    if ( [title  isEqual: _MyName2 ] ) {

        

        
        UIImageView *imageView = [UIImageView new];
        
        imageView.image =  [[ _backgroundImage1
                             resizableImageWithCapInsets: UIEdgeInsetsMake(22, 26, 22, 26) ]
                            imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ];
        
        imageView.frame = CGRectMake( -7 , -3,
                                     textView.frame.size.width  + 24,
                                     textView.frame.size.height +  6 );

        imageView.tintColor = [UIColor whiteColor];
        
        [vieww addSubview: imageView];
        
        

        

    }
    else                                       {
        

        
        UIImageView *imageView = [UIImageView new];
        
        imageView.image =  [[  _backgroundImage2
                             resizableImageWithCapInsets: UIEdgeInsetsMake(22, 26, 22, 26) ]
                            imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ];
        
        imageView.frame = CGRectMake( -3 , -3,
                                     textView.frame.size.width+26,
                                     textView.frame.size.height +6 );
        //textView.textColor = [UIColor whiteColor];
        imageView.tintColor = [UIColor colorWithRed: 224.0/255.0 green: 255.0/255.0 blue: 196.0/255.0 alpha: 1.0];
        [vieww addSubview: imageView];
        //vieww.layer.borderColor = [[UIColor colorWithRed:142.0/255.0 green:192.0/255.0 blue:164.0/255.0 alpha:1.0]CGColor];
        
    }
    
    
    // vieww.layer.borderWidth = 0.5; 		// 2 толщина
    
    
    
    [cell addSubview: vieww ];
    [cell addSubview: textView];
    
    // ---------------------------------------------------------------------------------------------------------
    
    return cell ;
}
// ________________________________________________________________________________________________________________
- (void)specialMethod3: (NSString   *)title
                 image: (UIImage    *)image
             cordinate: (Cordinatee *)cordinate {
    
    
                                               NSIndexPath * indexPath = [NSIndexPath indexPathForRow: [_arrayUserName count] inSection:0];
    [ _arrayLocationCoordinate setObject: cordinate  forKey: indexPath ];
    
    
    
    // NSLog(@" %f %f ", image.size.width, image.size.height);
    UIImageView *img = [UIImageView new];
    
    int g = 118;
    CGFloat i1;
    if ( image.size.width > (screenWidth - g) ) {
        i1 = image.size.width  / (screenWidth - g); // i_10 = 2000 /  200
        i1 = image.size.height /  i1; //  128 = 1280 / i_10
    }
    else                          {
        i1 = (screenWidth - g) / image.size.width; //  i_10 = 200 /  20
        i1 = image.size.height * i1; // i_120 = 12 * i_10
    }
    img.frame = CGRectMake(0 , 0 , (screenWidth - g) , i1 );
    
    //NSLog(@"%f %f",image.size.width,image.size.height);
    
    image = [ self imageRect: image size: CGSizeMake( (screenWidth - g), i1) ];   //  NSLog(@"%f %f",image.size.width,image.size.height);
    
    
    img.image = image ;
    
    //NSLog(@" %f %f ",img.frame.size.width,img.frame.size.height);
    
    
     
     CGFloat y = 54;
     if ( img.frame.size.height > 30 ) y = 17 +32 + img.frame.size.height;
     NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow: y inSection:0];
     [ _arrayUserMessageSize addObject: newIndexPath ];NSLog(@"!!!!!!!!!!!%f",y);
     [self endterSize:(int)newIndexPath.row ];
     
     
    
    /* CGFloat y = 54;
    if (img.frame.size.height > 30 ) y = 33 + img.frame.size.height;
    NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow: y inSection:0];
    [ _arrayUserMessageSize addObject: newIndexPath ]; */
    
    
    [ _arrayUserName    addObject: title ];
    [ _arrayUserMessage addObject: image ];
    
    [_arrayDate setObject: [NSDate date]
                   forKey:  [NSString stringWithFormat:@"%d",[_arrayUserName count] ] ];

    
    // 	создать прототип  UserRegistration
    HistoryMessages *newMessages = [NSEntityDescription  insertNewObjectForEntityForName: @"HistoryMessages" // поиск сущности по имени
                                                                  inManagedObjectContext: _managedObjectContext];	// контекст
    if ( newMessages != nil) 	{	// если найден
        newMessages.name                =  title;	// добавить данные
        newMessages.messagePhoto        =  UIImageJPEGRepresentation( image,1.0);
        newMessages.messageSize         = [NSNumber numberWithInteger: newIndexPath.row];
        newMessages.time =  [NSDate date];
        newMessages.locationCordinate1  = [NSNumber numberWithDouble:  cordinate.latitude ];
        newMessages.locationCordinate2  = [NSNumber numberWithDouble:  cordinate.longitude ];

        newMessages.whoTook = _userBot;
        
        [self.managedObjectContext save: nil];  // сохранение, контекста  	не обязательно - он и так сохраняе
    }
    
    // CGRectMake(0, 0 , 200 >, 413 );
    
}
// _____________________________________________________________________________________________________________
- (void)specialMethod3: (NSString   *)title
                 image: (UIImage    *)image
                   url: (NSURL      *)url   {
    
    
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow: [_arrayUserName count] inSection:0];
    [ _arrayPhotoURL setObject: url  forKey: indexPath ];

    
    // NSLog(@" %f %f ",image.size.width,image.size.height);
    UIImageView *img = [UIImageView new];
    
    
    
    int g= 118;
    CGFloat i1;
    if ( image.size.width  > (screenWidth - g) ) {
        i1 = image.size.width  / (screenWidth - g); // i_10 = 2000 /  200
        i1 = image.size.height /  i1; //  128 = 1280 / i_10
    }
    else                                         {
        i1 = (screenWidth - g) / image.size.width; //  i_10 = 200 /  20
        i1 = image.size.height * i1; // i_120 = 12 * i_10
    }
    
    img.frame = CGRectMake(0 , 0 , (screenWidth - g) , i1 );
    

    
    image = [ self imageRect: image size: CGSizeMake( (screenWidth - g), i1) ];   //  NSLog(@"%f %f",image.size.width,image.size.height);
    
    
    img.image = image ;
    
    //NSLog(@" %f %f ",img.frame.size.width,img.frame.size.height);
    
                                                                            CGFloat y = 54;
                                                  if ( img.frame.size.height > 30 ) y = 17+32 + img.frame.size.height;
                         NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow: y inSection:0];
    [ _arrayUserMessageSize addObject: newIndexPath ];
    [self endterSize:             (int)newIndexPath.row ];

    
    
    
    [ _arrayUserName    addObject: title ];
    [ _arrayUserMessage addObject: image ];
    
    [_arrayDate setObject: [NSDate date]
                   forKey:  [NSString stringWithFormat:@"%d",[_arrayUserName count] ] ];
    
    // 	создать прототип  UserRegistration
    HistoryMessages *newMessages = [NSEntityDescription  insertNewObjectForEntityForName: @"HistoryMessages" // поиск сущности по имени
                                                                  inManagedObjectContext: _managedObjectContext];	// контекст
    if ( newMessages != nil) 	{	// если найден
        newMessages.name          = title;	// добавить данные
        newMessages.messagePhoto  = UIImageJPEGRepresentation( image,1.0);
        newMessages.messageSize   = [NSNumber numberWithInteger: newIndexPath.row];
        newMessages.time            =  [NSDate date];
        newMessages.photoURL      =  [url absoluteString] ;
        
        
        newMessages.whoTook       = _userBot;
        
        [self.managedObjectContext save: nil];  // сохранение, контекста  	не обязательно - он и так сохраняет
    }
    
    
}

#pragma 'ячейки - UITableViewDelegate #################################################################################'

#pragma ___ 'высота ячеек _ их колличетсво' _________________________________________________________

#pragma  'Расчетная высота для строки на пути указателя _____________________________________________________________'
- (CGFloat)             tableView:(UITableView *)tableView
 estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *newIndexPath = _arrayUserMessageSize[ indexPath.row ];
    return newIndexPath.row;
}

#pragma  'Высота для строки на пути указателя _______________________________________________________________________'
- (CGFloat)             tableView:(UITableView *)tableView
          heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *newIndexPath = _arrayUserMessageSize[ indexPath.row ];
    
    return newIndexPath.row;
}

#pragma  'колличество ячеек ________________________________________________________________________________________'
- (NSInteger)           tableView:(UITableView *)tableView
            numberOfRowsInSection:(NSInteger)section {
    
    return [ _arrayUserName count];
}

#pragma ___ 'ячейка _______________________________________________________________________________________________'
- (UITableViewCell *)   tableView:(UITableView *)tableView
            cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    NSString *name = _arrayUserName[indexPath.row];
    
         if ([ name isEqualToString: user2   ] ) {
             
             UITableViewCell * cell2;
             
             

             
             if ( [_cells objectForKey: indexPath] ) {   cell2 = [_cells objectForKey: indexPath];
             }
             else {
             
                 cell2 = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault   reuseIdentifier: @"My2Cell"];

                 cell2.backgroundColor = [UIColor clearColor];

                 cell2 = [self specialMethod2: _MyName2
                                     subtitle: _arrayUserMessage[indexPath.row]
                                         cell: cell2
                                        index: indexPath.row ];
             
                 [self accessoryView: _MyPhoto2 cell: cell2 index: _arrayUserMessageSize[ indexPath.row ]];

        
                 [ _cells setObject: cell2 forKey: indexPath  ];

             }
             NSLog(@"_____________");
             for ( id obj in cell2.subviews ) {
                 NSLog(@"%@",[obj class]);
             }
        return  cell2;
    }
    else if ([ name isEqualToString: user1   ] ) {
        
        
        UITableViewCell * cell3;
        
        

        
        if ( [_cells objectForKey: indexPath] ) {
            cell3 = [_cells objectForKey: indexPath]; // NSLog(@"есть %d",indexPath.row);
        }
        else {  // NSLog(@"еще не существует - добавляет cell %d",indexPath.row);
        

       cell3 = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"My2Cell"];
       cell3.backgroundColor = [UIColor clearColor];

        
        cell3 = [self specialMethod2: _MyName1
                            subtitle: _arrayUserMessage[indexPath.row]
                                cell: cell3
                               index: indexPath.row];
        
        // ______________________________________________________________________________________
        
            [self accessoryView: _MyPhoto1 cell:cell3 index: _arrayUserMessageSize[ indexPath.row ]];
            
         [ _cells setObject: cell3 forKey: indexPath  ];		// добавляет элемент в словарь
            
        }
        NSLog(@"_____________");
        for ( id obj in cell3.subviews ) {
            NSLog(@"%@",[obj class]);
        }
        return  cell3;
    }
    else if ([ name isEqualToString: @"фото" ] || [ name isEqualToString: @"гео"  ] ) {
        
        UITableViewCell * cell3;
        
        

        
        if ( [_cells objectForKey: indexPath] ) {   cell3 = [_cells objectForKey: indexPath];   }
        else {
        
            cell3 = [ [UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"My2Cell" ];
            cell3.backgroundColor = [ UIColor clearColor ];
            

            UIImageView * imgView   =  [UIImageView new];
            UIImage     * photo     =  _arrayUserMessage[indexPath.row] ;
        
   
            imgView.frame = [ self image_auto_fit:      photo  intt:118 ];
            imgView.image = [ self image_rounding_edge: photo ];
            
            UIImageView *bubble = [self bubble_create_user: 1
                                                   imgView: imgView ];

            
            NSDate *date = [_arrayDate  objectForKey: [NSString stringWithFormat:@"%d",indexPath.row +1] ];
            //NSLog(@"%@  ",date );
            
            UILabel * label2 = [UILabel new];
            
            NSDateFormatter * dateFormatterStr = [NSDateFormatter new];
                            [ dateFormatterStr setDateFormat: @"HH:mm"];
            
            label2.text       = [ dateFormatterStr stringFromDate: date ] ;
            label2.font       = [ label2.font fontWithSize:10];
            label2.textColor  = [ UIColor darkGrayColor];
            label2.alpha = 0.6;

            label2.frame = CGRectMake( 12 , imgView.frame.size.height -12+32, 30, 15);
            
            
            
            
            
            [cell3 addSubview: bubble ];
            
            [cell3  addSubview: label2];
            
            
            if ([ _arrayUserName[indexPath.row] isEqualToString: @"гео"  ] ) {
                [cell3 addSubview: [ self add_pin_geolocation:
                                    CGRectMake( ( imgView.frame.size.width / 2) + 33, ( imgView.frame.size.height / 2) - 30+32 , 35 , 35 )] ];
            }
            

       
        // ______________________________________________________________________________________
            [self accessoryView: _MyPhoto1 cell:cell3 index: _arrayUserMessageSize[ indexPath.row ] ];
        

            
            [ _cells setObject: cell3 forKey: indexPath  ];
        }
        NSLog(@"_____________");
        for ( id obj in cell3.subviews ) {
            NSLog(@"%@",[obj class]);
        }
        return  cell3;
        
    }
    else                                         {
        UITableViewCell * cell4 = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault   reuseIdentifier: @"My2Cell"];
                          cell4.backgroundColor = [UIColor clearColor];
        NSLog(@"_____________");
        for ( id obj in cell4.subviews ) {
            NSLog(@"%@",[obj class]);
        }
        
        return  cell4;
    }
    
    return  cell;
    
}

#pragma  округление краев пикчи ___________________________________________________________________________________
- (UIImage *)image_rounding_edge:(UIImage *)photo {
    
     UIImageView * roundView = [[UIImageView alloc] initWithImage: photo ];
     UIGraphicsBeginImageContextWithOptions( roundView.bounds.size, NO, [UIScreen mainScreen].scale );
     
     [[UIBezierPath bezierPathWithRoundedRect: roundView.bounds
     cornerRadius: roundView.frame.size.width / 13] addClip];
     
     [photo drawInRect: roundView.bounds];
     
    UIImage *photo_end = UIGraphicsGetImageFromCurrentImageContext();
                         UIGraphicsEndImageContext();
    
    return photo_end;
}
#pragma  автокорекция размера изображения __________________________________________________________________________
- (CGRect)image_auto_fit:(UIImage *)photo intt:(int)g {
    CGFloat i1;
    
    if (     photo.size.width >  (screenWidth - g) ) {
        i1 = photo.size.width  / (screenWidth - g); // i_10 = 2000 /  200
        i1 = photo.size.height /  i1; //  128 = 1280 / i_10
        return  CGRectMake(0 , 0 , (screenWidth - g) , i1 );
    }
    else                                          {
        i1 = (screenWidth - g) / photo.size.width; //  i_10 = 200 /  20
        i1 = photo.size.height * i1; // i_120 = 12 * i_10
       return CGRectMake(0 , 0 , (screenWidth - g) , i1 );
    }
}
#pragma  bubble  создать ___________________________________________________________________________________________
- (UIImageView *)bubble_create_user:(BOOL)user    imgView:(UIImageView *)imgView {
    
    
    UIFont *text1Font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString: _MyName1
                                                                                          attributes: @{ NSFontAttributeName : text1Font }];
    UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(10, 4 , (screenWidth - 120) , 613 )];
    // textView.frame = CGRectMake(70, 0 , 200, 413 );
    
    // textView.text = [ NSString stringWithFormat:@"%@\n %@", title, subtitle ];
    textView.scrollEnabled = NO;
    textView.editable = NO;
    textView.selectable = NO;
    textView.backgroundColor = [UIColor clearColor];
    
        textView.attributedText = attributedString1;
   
    
    UIImageView *bubble = [UIImageView new];
    
    
    
    UIImage *bubble_image ;
    if (user)bubble_image = _backgroundImage2;
    else     bubble_image = _backgroundImage1;
    
    bubble.image =  [[ bubble_image
                      resizableImageWithCapInsets: UIEdgeInsetsMake(22, 26, 22, 26) ]
                     imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ];
    
    
    if (user) {
        bubble.frame = CGRectMake( 44 , -4 , imgView.frame.size.width +20 , imgView.frame.size.height +14+32 );
        bubble.tintColor = [UIColor colorWithRed: 224.0/255.0 green: 255.0/255.0 blue: 196.0/255.0 alpha: 1.0];
       
        imgView.frame = CGRectMake( 7 , 7+32 , imgView.frame.size.width  , imgView.frame.size.height  );
    }
    else {
        bubble.frame = CGRectMake( 53.5 , -4 , imgView.frame.size.width +20 , imgView.frame.size.height +14+32 );
        bubble.tintColor =  [UIColor whiteColor];
        
        imgView.frame = CGRectMake( 12 , 7+32 , imgView.frame.size.width  , imgView.frame.size.height  );
    }
    
    
    
     [bubble addSubview: textView];
    [bubble addSubview: imgView  ];
    
    return bubble;
}
#pragma  добавить пин для геофотки _________________________________________________________________________________
- (UIImageView *)add_pin_geolocation:(CGRect)frame {
    
    UIImageView * img2 = [UIImageView new];
    img2.image = [UIImage imageNamed: @"pin.png" ];
    img2.frame = frame;
    return img2;
}
#pragma  добавить изображение справа _______________________________________________________________________________
- (void)accessoryView: (UIImage *)photo
                 cell: (UITableViewCell *)cell
                index: (NSIndexPath *)newIndexPath {
    
    if ( photo == _MyPhoto1 ) {
        CGPoint y = CGPointMake( 33, newIndexPath.row / 2 );
       NSLog(@"%d",newIndexPath.row / 2);
        
        
        UIImageView *imagge = [[UIImageView alloc]  initWithFrame: CGRectMake( self.view.frame.size.width -  y.x - 17.5 , y.y - 17.5 , 35, 35) ];
        NSLog(@"%f %f %f %f",imagge.frame.origin.x,imagge.frame.origin.y,imagge.frame.size.width,imagge.frame.size.height);
        imagge.image = _MyPhoto1;// [ self imageRect: [UIImage imageNamed: @"jpg"] size: CGSizeMake(35, 35) ];
        imagge.contentMode = UIViewContentModeScaleAspectFill;
        imagge.layer.cornerRadius  = 17;
        imagge.layer.masksToBounds = true;
        
        [cell addSubview: imagge];
    }
    else {
        CGPoint y = CGPointMake( 33, newIndexPath.row / 2 );
        // imagge.frame = CGRectMake( y.x - 17.5 ,y.y - 17.5 , 35, 35);
        
        UIImageView *imagge = [[UIImageView alloc]  initWithFrame: CGRectMake( y.x - 17.5 ,y.y - 17.5 , 35, 35) ];
        imagge.image = _MyPhoto2;// [ self imageRect: [UIImage imageNamed: @"jpg"] size: CGSizeMake(35, 35) ];
        imagge.contentMode = UIViewContentModeScaleAspectFill;
        imagge.layer.cornerRadius  = 17;
        imagge.layer.masksToBounds = true;
        
        [cell addSubview: imagge];
    }
}

// не то - выбор ячейки _______________________________________________________________________________________________
- (void)	  tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"сидим тута ");
    
    
    id obj =  _arrayUserMessage[indexPath.row] ;
    if ([obj class] == [UIImage class]) {

        [self performSegueWithIdentifier: @"Photo"
                                  sender: nil /*buf.useer*/];
    }
    else {

    }
}

#pragma "###############################################################################################################"
#pragma "###############################################################################################################"



@end








































