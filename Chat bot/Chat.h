



#import "ChatTableView.h"


#import "Cordinatee.h"
#import "MapViewController.h"

#import "CordinateMapView.h"
#import "ImageViewController.h"

#import "ImageLibrary.h"


@interface Chat : ChatTableView <
UIGestureRecognizerDelegate ,
UITextFieldDelegate         ,
UITextViewDelegate          >



// поле для отправки текста
@property (strong, nonatomic) IBOutlet UIView       * messageSendView;
@property (strong, nonatomic) IBOutlet UITextField  * messageSendTextField;
@property (strong, nonatomic) IBOutlet UITextView   * messageSendTextView;

@property  CGFloat messageSendTextMutableSize;


@property BOOL fixMyTouch;
@property BOOL keyboardStatusOpen;



@end
