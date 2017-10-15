



#import "CreateMsgElementsProgrammatically.h"




@implementation ChatTableView (CreateMsgElementsProgrammatically)




- (void)nslogImageFrame:(UIImageView *)userImage {
    
    NSLog(@"userImage %3.0f\t%3.0f\t-\t%3.0f\t%3.0f",
        userImage.frame.size.width,
        userImage.frame.size.height,
        userImage.image.size.width,
        userImage.image.size.height);
    
}

// ------------------------------------------------------------------------------------------
- (UIImageView  *)createUserImage:(NSString *)name index:(int)index  {
    
    long intSize = ( ((NSNumber *)[self indx: index key:@"size"]).intValue/2);
    
    CGRect   profileFrameImage;
    UIImage *profileImage;
    
    if( ([name isEqual: @"user2"]) ) {
        profileFrameImage = CGRectMake( 14 , intSize - 17.5 , 35, 35);
        profileImage      = [UIImage imageWithData: self.userBot.photo];
    } else {
        profileFrameImage = CGRectMake( self.view.frame.size.width - 35 - 14 , intSize - 17.5 , 35, 35);
        profileImage      = [UIImage imageWithData: self.userBot.userRegistration.photo] ;
    }
    
    UIImageView *
    profileImgView = [[UIImageView alloc] initWithFrame: profileFrameImage ];
    profileImgView.image = profileImage ;
    
    profileImgView.contentMode = UIViewContentModeScaleAspectFill;
    profileImgView.layer.cornerRadius  = 17;
    profileImgView.layer.masksToBounds = true;
    
    int width = profileImgView.image.size.width / (profileImgView.image.size.height / profileImgView.frame.size.width);
    
    UIGraphicsBeginImageContextWithOptions( CGSizeMake( width, profileImgView.frame.size.width ), YES, 0.0);
    [ profileImgView.image drawInRect: CGRectMake(0, 0, width, profileImgView.frame.size.width) ];
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    profileImgView.image = image2;
    
    
    return profileImgView;
}
// ------------------------------------------------------------------------------------------
- (UITextView   *)createTextMessage:(NSString *)name index:(int)index  {
    
    // текст сообщения
    UITextView *textView =
    [[UITextView alloc] initWithFrame: CGRectMake(70 ,0 ,self.view.frame.size.width -120 , 51 )];
    textView.scrollEnabled   = NO;
    textView.editable        = NO;
    textView.selectable      = 1;
    textView.backgroundColor = [UIColor clearColor];
    textView.attributedText  =
    [[NSMutableAttributedString alloc] initWithString: [self indx: index key:@"msg"] attributes:
     @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14] }];
    
    [textView sizeToFit];
    

    
    if( ([name isEqual: @"user2"]) ) {
        textView.frame = CGRectMake( textView.frame.origin.x ,
                                     textView.frame.origin.y,
                                     textView.frame.size.width ,
                                     textView.frame.size.height);
    }
    else {
        
        textView.frame = CGRectMake( (self.view.frame.size.width -(textView.frame.origin.x +textView.frame.size.width)) ,
                                     textView.frame.origin.y,
                                     textView.frame.size.width ,
                                     textView.frame.size.height);
    }

    
    return textView;
}
// ------------------------------------------------------------------------------------------
- (UIImageView  *)createImageMessage:(NSString *)type index:(int)index {
    
    UIImageView * imgView   =  [UIImageView new];
    UIImage     * photo     =  [self indx: index key:@"img"] ;
    
    int g= 118;
    CGFloat i1 = [ self.classImageEditingMethods  imageRect_MaintainingProportions:photo.size
                                                                           percent:g
                                                                          viewSize:self.view.frame.size ];
    
    imgView.frame = CGRectMake
    ( self.view.frame.size.width - (self.view.frame.size.width - g) - 70  ,
     5 ,
     ( self.view.frame.size.width - g) ,
     i1  );
    
    int width = photo.size. height / (photo.size. width / imgView.frame.size.width )  ;
    UIGraphicsBeginImageContextWithOptions( CGSizeMake( imgView.frame.size.width , width ), YES, 0.0);
    [ photo drawInRect: CGRectMake(0, 0, imgView.frame.size.width , width ) ];
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imgView.image = [ self.classImageEditingMethods imageRoundingEdge: image2 ];
    
    
    imgView.layer.drawsAsynchronously 	= true; // ЦПУ) выполнять отображение слоя в фоновом потоке
    imgView.layer.shouldRasterize 		= true ;     // качество отображения
    imgView.layer.rasterizationScale = 0;		// включить 		(слой рисуется один раз.
    
    
    if ([ type isEqual: @"geo"] ) {
        UIImageView *
        img2 = [UIImageView new];
        img2.image = [UIImage imageNamed: @"pin.png" ];
        img2.frame = CGRectMake( ( imgView.frame.size.width  / 2) - 15 ,
                                 ( imgView.frame.size.height / 2) - 30 ,
                                    35 ,
                                    35 );
        
        [imgView addSubview: img2 ];
    }
    
    
    return imgView;
}
// ------------------------------------------------------------------------------------------
- (UILabel      *)createTextDate:(NSString *)name type:(NSString *)type index:(int)index frame:(CGRect)frame {
    
    
    NSDate *date =  [self indx: index key:@"time"] ;
    NSDateFormatter * dateFormatterStr = [NSDateFormatter new];
    [dateFormatterStr setDateFormat: @"HH:mm"];
    
    UILabel *
    datelabel = [UILabel new];
    datelabel.text       = [ dateFormatterStr stringFromDate: date ] ;
    datelabel.font       = [ datelabel.font fontWithSize:10 ];
    datelabel.textColor  = [ UIColor lightGrayColor ];
    // datelabel.alpha      = 0.6;
    
    if ([ type isEqual: @"msg" ]) {
        datelabel.frame = CGRectMake( ([ name isEqual: @"user2" ]) ?
                                          frame.origin.x +  frame.size.width +15 :
                                          frame.origin.x - 42 ,  frame.size.height -18 ,
                                         30,
                                         15);
    }
    else {
        datelabel.frame = CGRectMake( 10 , frame.size.height -10 , 30, 15);
    }
    
    
    return datelabel;
}
// ------------------------------------------------------------------------------------------
- (UIImageView  *)createBubble:(NSString *)name type:(NSString *)type  frame:(CGRect)frame {
    
    
    UIImageView *bubble = [UIImageView new];
    UIImage     *bubbleImage;
    UIColor     *bubbleColor;
    
    if( ([name isEqual: @"user2"]) ) {
        bubbleImage = [UIImage imageNamed:@"bubble_left.png"];
        bubbleColor = [UIColor colorWithRed: 240.0/255.0 green: 243.0/255.0 blue: 248.0/255.0 alpha: 1.0];
    } else {
        bubbleImage = [UIImage imageNamed:@"bubble_right.png"];
        bubbleColor = [UIColor colorWithRed: 211.0/255.0 green: 232.0/255.0 blue: 253.0/255.0 alpha: 1.0];
    }
    
    bubble.image = [[ bubbleImage resizableImageWithCapInsets:
      UIEdgeInsetsMake(22, 26, 22, 26)] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ];
    
    bubble.tintColor = bubbleColor;
    
    if ([ type isEqual: @"msg" ]) {
        
        bubble.frame = CGRectMake
        ( ([ name isEqual: @"user2" ]) ? frame.origin.x - 16 : frame.origin.x - 11 ,
         frame.origin.y    -  3 ,
         frame.size.width  + 28 ,
         frame.size.height +  7  );
        
    }
    else {
        bubble.frame = CGRectMake
       ( frame.origin.x    -  7.7 ,
         frame.origin.y    -  8   ,
         frame.size.width  + 22.5 ,
         frame.size.height + 16    );
    }

    
    bubble.layer.drawsAsynchronously 	= true;
    bubble.layer.shouldRasterize 		= true ;
    bubble.layer.rasterizationScale     = 0;
    
    
    return bubble;
}



@end
