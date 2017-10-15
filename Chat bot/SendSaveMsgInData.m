



#import "Chat.h"


// отправить сообщение, сохранить все данные
#import "SendSaveMsgInData.h"

// создать, редактировать 1 сообщение пробел
#import "CreateEditFirstMsgSpace.h"




@implementation Chat (SendSaveMsgInData)

- (void)sendSaveMsgUser: (NSString *)user
                   type: (NSString *)type
               message1: (id)obj1
               message2: (id)obj2 {
    
    int size;
    NSString    * message;
    UIImage     * image;
    NSURL       * url;
    Cordinatee *cordinate;
    NSString *cordi;
    
    if ([ type isEqual: @"msg" ]) {
        
        message = obj1;
        // ---------------------------------------------------------------------------------------------------------
        UITextView * textView = [UITextView new];
        textView.frame = CGRectMake(70, 10 , self.view.frame.size.width -120 , 51 );
        // ---------------------------------------------------------------------------------------------------------
        textView.attributedText =
        [[NSMutableAttributedString alloc] initWithString: message attributes:
         @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14] }];
        [textView sizeToFit];
        // ---------------------------------------------------------------------------------------------------------
        
        size = (10 + textView.frame.size.height);
        
        
    }
    else {
        
        image = obj1;
        
        // предел
        int width  = ( self.view.frame.size.width - 118);
        // w1000 / (понизить до)100 = 10     h2500 / 10 = 250
        int height = image.size.height / (image.size.width / width)  ;
        

        
        UIGraphicsBeginImageContextWithOptions( CGSizeMake( width, height), YES, 0.0);
        [ image drawInRect: CGRectMake(0, 0, width, height) ];
        UIImage * image2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        image = image2;
        
        size = 54;
        if ( image.size.height > 30 ) size = 12 + 7 + image.size.height;


        
        
    }
    
    [self editSizeFirstMsgSpace: size ];
    
    
    if ([ type isEqual: @"msg" ]) {
        
        [self.arrayAllMessages addObject: @{ @"user" : user,
                                             @"size" : [NSNumber numberWithInt: size ],
                                             @"time" : [NSDate date],
                                             @"type" : @"msg",
                                             @"msg"  : message } ];
        // -----------------------------------------------------------------------------------------
        [self.classDataBaseMethods create_messageTypeMsg_user: user
                                                         size: size
                                                      message: message ];
    }
    else if ([ type isEqual: @"geo" ]) {
        
        cordinate = obj2;
        cordi = [NSString stringWithFormat:@"%f %f",cordinate.latitude,cordinate.longitude];
        
        [self.arrayAllMessages addObject: @{ @"user" : @"user1",
                                             @"size" : [NSNumber numberWithInt: size ],
                                             @"time" : [NSDate date],
                                             @"type" : @"geo",
                                             @"img"  : image,
                                             @"lat"  : [NSNumber numberWithInt: cordinate.latitude] ,
                                             @"lng"  : [NSNumber numberWithInt: cordinate.longitude] } ];
        // -----------------------------------------------------------------------------------------
        [self.classDataBaseMethods create_messageTypeGeo_user: user
                                                         size: size
                                                        image: image
                                                     latitude: cordinate.latitude
                                                    longitude: cordinate.longitude ];
    }
    else {
        
        url = obj2;
        
        [self.arrayAllMessages addObject: @{ @"user" : @"user1",
                                             @"size" : [NSNumber numberWithInt: size ],
                                             @"time" : [NSDate date],
                                             @"type" : @"img",
                                             @"img"  : image,
                                             @"url"  : url } ];
        // -----------------------------------------------------------------------------------------
        [self.classDataBaseMethods create_messageTypeImg_user: user
                                                         size: size
                                                        image: image
                                                          url: url ];
        
    }
    
    
    [self update];
    
}


@end
