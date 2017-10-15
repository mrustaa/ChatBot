


#import "DataBaseMethod.h"


@implementation DataBaseMethod

- (DataBaseMethod *)initContext:(NSManagedObjectContext *)context bot:(UsersBot *)bot {
    
    self.managedObjectContext = context;
    self.userBot = bot;
    
    return self;
}

// -------------------------------------------------------------------------


- (NSMutableArray *)get_allMessage {
    
    NSMutableArray * arrayAllMessages = [NSMutableArray new];
    
    NSArray *messages = [ self get_bot_chatHistory: self.userBot];
    for( HistoryMessages * message in messages ) {
        
        NSMutableDictionary * dictionaryMessage;
        
        dictionaryMessage = [ @{ @"user" : message.name,
                                 @"size" : message.messageSize,
                                 @"time" : message.time ? message.time : @"" } mutableCopy ];
        
        if (message.messageText) {
            if([message.messageText isEqual:@""] ) {
                [dictionaryMessage setObject: @""                        forKey: @"type" ];
            }
            else {
                [dictionaryMessage setObject: message.messageText        forKey: @"msg"  ];
                [dictionaryMessage setObject: @"msg"                     forKey: @"type" ];
            }
        }
        else {
            [dictionaryMessage setObject: [UIImage imageWithData: message.messagePhoto] forKey: @"img"  ];
            
            if (message.locationCordinate1.doubleValue) {
                [dictionaryMessage setObject: message.locationCordinate1 forKey: @"lat"  ];
                [dictionaryMessage setObject: message.locationCordinate2 forKey: @"lng"  ];
                [dictionaryMessage setObject: @"geo"                     forKey: @"type" ];
            }
            else {
                [dictionaryMessage setObject: [NSURL URLWithString:message.photoURL]  forKey: @"url"  ];
                [dictionaryMessage setObject: @"img"                     forKey: @"type" ];
            }
        }
        
        [ arrayAllMessages addObject: dictionaryMessage ];
    }
    
    
    return arrayAllMessages;
}


// -------------------------------------------------------------------------


// создать главного пользователя
- (void)create_mainUser_name:(NSString *)name
                    lastname:(NSString *)lastname
                       image:(UIImageView *)imageView {
    
    UsersRegistration *newUser =
    [NSEntityDescription  insertNewObjectForEntityForName: @"UsersRegistration"
                                   inManagedObjectContext: _managedObjectContext];
    if ( newUser != nil) 	{
        newUser.name      = name;
        newUser.lastname  = lastname;
        newUser.photo = UIImageJPEGRepresentation(imageView.image,1.0);
        [self.managedObjectContext save: nil];
    }
}

// изменить главного пользователя
-(void)edit_mainUser_name:(NSString *)name
                 lastname:(NSString *)lastname
                    image:(UIImageView *)imageView {
    
    UsersRegistration *mainUsers = [self get_mainUser];
    
    mainUsers.name     =     name ;
    mainUsers.lastname = lastname ;
    mainUsers.photo = UIImageJPEGRepresentation(imageView.image,1.0);
    
    [self.managedObjectContext save: nil];

}

// вернуть из базы даных   главного пользователя
- (UsersRegistration *)get_mainUser {
    
    return [[ self.managedObjectContext executeFetchRequest:
             [NSFetchRequest fetchRequestWithEntityName: @"UsersRegistration"] error: nil ] lastObject];
}
// -------------------------------------------------------------

- (void)create_bot_name:(NSString *)name
               lastname:(NSString *)lastname
                  image:(UIImageView *)imageView {
    
    // 	создать прототип  UserRegistration
    UsersBot *newBot =
    [NSEntityDescription  insertNewObjectForEntityForName: @"UsersBot" 
                                   inManagedObjectContext: self.managedObjectContext];
    
    if ( newBot != nil) 	{
        newBot.name       = name;
        newBot.lastname   = lastname;
        newBot.photo = UIImageJPEGRepresentation( imageView.image,1.0);
        
        newBot.userRegistration = [self get_mainUser];
        
        [self.managedObjectContext save: nil];
    }
}

// вернуть из базы даных   всех ботов
- (NSArray *)get_allBots {
    
    return [ self.managedObjectContext executeFetchRequest:
            [NSFetchRequest fetchRequestWithEntityName: @"UsersBot"] error: nil ];
}

// вернуть из базы даных   историю переписок с ботами
- (NSArray *)get_bot_chatHistory:(UsersBot *)bot {
    
    NSFetchRequest *
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName: @"HistoryMessages" ] ;
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"whoTook = %@", bot ]];
    return  [ self.managedObjectContext executeFetchRequest: fetchRequest  error: nil ];
}


// удалить из базы данных  бота  по переданному индексу
- (void)  delete_bot:(UsersBot *)bot {
    
    [self.managedObjectContext deleteObject: bot];
    [self.managedObjectContext save: nil];
}

// -------------------------------------------------------------------------

- (HistoryMessages *) create_message {
    return [NSEntityDescription insertNewObjectForEntityForName:@"HistoryMessages"
                                         inManagedObjectContext:self.managedObjectContext];
}

- (void) create_messageFirstSpace_size:(int)size {

    HistoryMessages * newMessages = [self create_message];
    
    if ( newMessages != nil ) {
         newMessages.name         = @"";
         newMessages.messageText  = @"";
         newMessages.messageSize  = [NSNumber numberWithInt: size ] ;
         newMessages.whoTook      = self.userBot;
        
        [self.managedObjectContext save: nil];
    }
    
}

- (void) edit_messageFirstSpace_size:(int)size {
    
    NSFetchRequest *
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"HistoryMessages"];
    fetchRequest.predicate  = [NSCompoundPredicate andPredicateWithSubpredicates:
                                @[ [NSPredicate predicateWithFormat: @"whoTook = %@", self.userBot]  ,
                                   [NSPredicate predicateWithFormat: @"name = %@", @"" ] ] ];
    
    HistoryMessages * newMessages = [[ self.managedObjectContext executeFetchRequest: fetchRequest
                                                                               error: nil ] lastObject];
    if (newMessages) 	{
        newMessages.messageSize  = [NSNumber numberWithInteger: size ];
        
        [self.managedObjectContext save: nil];
    }
    
}

- (void) create_messageTypeMsg_user:(NSString *)user
                              size:(int)size
                           message:(NSString *)message  {
    
    HistoryMessages *newMessages = [self create_message];
    
    if (newMessages) 	{
        newMessages.name       = user;
        newMessages.messageText  = message;
        newMessages.messageSize  = [NSNumber numberWithInt: size ] ;
        newMessages.time =  [NSDate date];
        
        newMessages.whoTook = self.userBot;
        
        [self.managedObjectContext save: nil];
    }
    
}

- (void) create_messageTypeGeo_user:(NSString *)user
                              size:(int)size
                             image:(UIImage *)image
                          latitude:(int)latitude
                         longitude:(int)longitude {
    
    HistoryMessages *newMessages = [self create_message];
    
    if (newMessages) 	{
        newMessages.name                =  user;
        newMessages.messagePhoto        =  UIImageJPEGRepresentation( image,1.0);
        newMessages.messageSize         =  [NSNumber numberWithInt: size ] ;
        newMessages.time                =  [NSDate date];
        newMessages.locationCordinate1  =  [NSNumber numberWithDouble:  latitude ];
        newMessages.locationCordinate2  =  [NSNumber numberWithDouble:  longitude ];
        
        newMessages.whoTook =  self.userBot;
        
        [self.managedObjectContext save: nil];
    }
    
}


- (void) create_messageTypeImg_user:(NSString *)user
                              size:(int)size
                             image:(UIImage *)image
                               url:(NSURL *)url {
    
    HistoryMessages *newMessages = [self create_message];
    
    if (newMessages) 	{
        newMessages.name          = user;
        newMessages.messagePhoto  = UIImageJPEGRepresentation( image,1.0);
        newMessages.messageSize   = [NSNumber numberWithInt: size ] ;
        newMessages.time          = [NSDate date];
        newMessages.photoURL      = [url absoluteString] ;
        
        newMessages.whoTook       =  self.userBot;
        
        [self.managedObjectContext save: nil];
    }
    
}




@end
