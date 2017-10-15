



#import "CreateEditFirstMsgSpace.h"



@implementation Chat (CreateEditFirstMsgSpace)


// если сообщений нет. создать 1 сообщение пробел
- (void)createFirstMsgSpace {
    
    if (![self.arrayAllMessages count])  {
        
        int size = self.view.frame.size.height -110;
        
        
        [self.arrayAllMessages addObject: [ @{ @"user":@"" ,
                                               @"type":@"" ,
                                               @"time":@"" ,
                                               @"size":[NSNumber numberWithInt: size]   ,
                                               @"msg" :@"" } mutableCopy] ];
        
        [self.classDataBaseMethods create_messageFirstSpace_size: size ];
        
    }
    
}

// изменить размер 1 сообщения
- (void)editSizeFirstMsgSpace:(int)minusSize {
    
    
    int intSpaceSize = ((NSNumber *)[self indx: 0 key:@"size"]).floatValue;
    
    
    int size = intSpaceSize - minusSize ;
    if ( size > 5 ) {
        NSNumber *numberSize = [NSNumber numberWithInt: size];
        NSMutableDictionary *dict = self.arrayAllMessages[0];
        [dict setObject: numberSize forKey:@"size"];
        [self update];
    }
    else {
        
        size = 5;
        [self.arrayAllMessages[0] setObject:[NSNumber numberWithInt: size] forKey:@"size"];
        [self update];
    }
    
    [self.classDataBaseMethods edit_messageFirstSpace_size: size ];
    
}

@end
