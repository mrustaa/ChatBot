



#import "ChatTableView.h"



@interface ChatTableView (CreateMsgElementsProgrammatically)

- (void)nslogImageFrame:(UIImageView *)userImage;

- (UIImageView *)createBubble:      (NSString *)name  type:(NSString *)type                      frame:(CGRect)frame ;
- (UIImageView *)createUserImage:   (NSString *)name                         index:(int)index ;
- (UITextView  *)createTextMessage: (NSString *)name                         index:(int)index ;
- (UIImageView *)createImageMessage:                       (NSString *)type  index:(int)index ;
- (UILabel     *)createTextDate:    (NSString *)name  type:(NSString *)type  index:(int)index    frame:(CGRect)frame ;



@end
