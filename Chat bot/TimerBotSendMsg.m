



#import "TimerBotSendMsg.h"


// отправить сообщение, сохранить все данные
#import "SendSaveMsgInData.h"



@implementation Chat (timerBotSendMsg)



// отправить сообщение
- (void)timerBotSendMessage:(NSString *)message {
    

    int second, rand1 = (arc4random() % 100 );
    
    if ( rand1 < 80 )   { second = (arc4random() %  4); }
    else                { second = (arc4random() % 11); }
    
    if(!second) second = 1;
    
    [NSTimer scheduledTimerWithTimeInterval: second
                                     target: self
                                   selector: @selector(selectorMethod: )
                                   userInfo: message
                                    repeats: NO];		
    
    self.messageSendTextField.text = @"";
    
}

// бот - ответ на мои сообщения, рандомное опоздание
- (void)selectorMethod:(NSTimer*)timer  {
    
    NSString *message = [timer userInfo];
    
    [self sendSaveMsgUser: @"user2" type:@"msg" message1:message message2: nil ];
    
}


@end
