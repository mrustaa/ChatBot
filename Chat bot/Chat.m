



#import "Chat.h"


// Category

// сообщение Alert действие, отправить геолокацию или фотографию
#import "AlertAction.h"
// нажимая на ячейку/сообщение с изображением, найти и открыть это изображение
#import "FindImageMsg.h"
// таймер с рандомным временем запуска, отправит сообщение от бота
#import "TimerBotSendMsg.h"
// отправить сообщение, сохранить все данные
#import "SendSaveMsgInData.h"
// создать, редактировать 1 сообщение пробел
#import "CreateEditFirstMsgSpace.h"




@implementation Chat 


- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    // титул имя бота
    self.title = [NSString stringWithFormat:@"%@ %@", self.userBot.name , self.userBot.lastname ] ;
    
    
    // Класс методов работы с базой данных
    self.classDataBaseMethods = [[DataBaseMethod alloc]initContext:self.managedObjectContext
                                                               bot:self.userBot];
    // Класс методов для редактирования изображения
    self.classImageEditingMethods = [ImageEditingMethods new];
    
    
    // изъять все сообщения, из базы данных, в массив
    self.arrayAllMessages = [self.classDataBaseMethods get_allMessage];
    
    
    // NSLog(@"%@",self.arrayAllMessages);
    
    
    UITapGestureRecognizer *tapFindImageCell =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFindImage:)];
    tapFindImageCell.delegate = self;
    [self.tableView addGestureRecognizer: tapFindImageCell];

    
    self.messageSendTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.messageSendTextView.scrollEnabled =0;
    [self.messageSendTextView setReturnKeyType:UIReturnKeyDefault];
    self.messageSendTextView.font = [UIFont systemFontOfSize:14];
    
    self.messageSendTextMutableSize = 0;
    
    // если сообщений нет. создать 1 сообщение пробел
    [self createFirstMsgSpace];
    
    [self update];
    
    self.fixMyTouch = 0;
    self.keyboardStatusOpen = 0;
    
    
}

//  передвигать TableView и TextField при открытии клавиатуры, анимированно
- (void)viewWillAppear:   (BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    
    self.keyboardStatusOpen = 1;
    
    [UIView animateWithDuration:[[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] intValue] << 16
                     animations:^{
                         
                         self.messageSendView   .transform = CGAffineTransformMakeTranslation(0,-216  -_messageSendTextMutableSize);
                         self.tableView         .transform = CGAffineTransformMakeTranslation(0,-216  -_messageSendTextMutableSize);
                         
                     } completion:^(BOOL finished) { }];

    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
   self.keyboardStatusOpen = 0;
    
    [UIView animateWithDuration:[[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] intValue] << 16
                     animations:^{
                         
                         self.messageSendView   .transform = CGAffineTransformMakeTranslation(0, -_messageSendTextMutableSize);
                         self.tableView         .transform = CGAffineTransformMakeTranslation(0, -_messageSendTextMutableSize);
                         
                     } completion:^(BOOL finished) { }];
    
    
}

// скроллинг начался
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    
    if(self.tableView == scrollView ) {
    
        // защита от автоматического скролинга - во время отправки нового сообщения/(добавления новой ячейки)
        if(self.fixMyTouch ) {
            // от прикосновения (по сообщениям) закроет клавиатуру
            [ self.messageSendTextField resignFirstResponder];
            [ self.messageSendTextView  resignFirstResponder];
        }
    }
}
// UIGestureRecognizer Delegate - фиксирует прикосновение
//  да, да, да, нельзя просто создать  отдельный метод
//  потому что (жест движение) заблокирует собой    базовый жест tableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    self.fixMyTouch=1;
    
    return YES;
}
// кнопка Done. Return
- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
    
    [ self.messageSendTextField resignFirstResponder];  // выключить клаву
    return YES;
}


// найти и открыть фотографию
- (void)tapGestureFindImage: (UITapGestureRecognizer *) sender {
    if(self.keyboardStatusOpen) {
        [ self.messageSendTextField resignFirstResponder];
        [ self.messageSendTextView  resignFirstResponder];
    }
    else  [self findImage:sender];
}

-(CGFloat)getWidth:(NSString *)text{
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectZero];
    textField.text = text;
    [textField sizeToFit];
    return textField.frame.size.width;
}


- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    if( newFrame.size.height > 200 ) {
        self.messageSendTextView.scrollEnabled =1;
    }
    else{
        self.messageSendTextView.scrollEnabled =0;
        textView.frame = newFrame;
    }
    
    
    UIFont *font = [UIFont boldSystemFontOfSize:14.0];
    
    CGRect rectSize = [ self.messageSendTextView.text boundingRectWithSize: self.messageSendTextView.frame.size
                                                                   options: NSStringDrawingUsesLineFragmentOrigin
                                                                attributes: [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]
                                                                   context: nil ];

    int intNumberOfLines = rectSize.size.height / font.lineHeight;
    
    _messageSendTextMutableSize = (16.75 *  ((intNumberOfLines > 1.) ? intNumberOfLines : 1.) );
    _messageSendTextMutableSize = _messageSendTextMutableSize - 16.75;
    
    
    self.messageSendView   .transform = CGAffineTransformMakeTranslation(0,-216  -_messageSendTextMutableSize);
    self.tableView         .transform = CGAffineTransformMakeTranslation(0,-216  -_messageSendTextMutableSize);

    
    
    
}





#pragma IBAction ###########################


- (IBAction)buttonCloseChat:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// добавить ActionSheet - фото, геолокацию
- (IBAction)buttonSendMessageImageGeo:(id)sender {
    
    [self.messageSendTextField resignFirstResponder];
    
    [self alert_ActionSheet_GeoImage];
}

// отправить сообщение
- (IBAction)buttonSendMessage:(id)sender {
    
    self.fixMyTouch = 0;
    
    NSString * message = self.messageSendTextView.text;// self.messageSendTextField.text ;
    
    
    // удаление пробелов вначале вконце
    message = [message stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet] ];
    
    if ([message isEqualToString: @""]) return;
    
        
    [self sendSaveMsgUser: @"user1" type:@"msg" message1:message message2: nil ];

    
    [self timerBotSendMessage:message];
    
}


- (void)prepareForSegue: (UIStoryboardSegue *)segue // мы получим указатель View на который мы переходим	- это segue
                 sender: (id)sender {
    
    if ([ segue.identifier isEqualToString: @"Map" ]) {
        CordinateMapView *mapview = (CordinateMapView *)segue.destinationViewController;
        [mapview location: sender];
    }
    if ([ segue.identifier isEqualToString: @"Photo" ]) {
        ImageViewController *imgview = (ImageViewController *)segue.destinationViewController;
        imgview.imageURL = sender[0] ;
        imgview.floatImageHeight = sender[1] ;
    }
    
}






@end
