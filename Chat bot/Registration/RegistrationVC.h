

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "ImageEditingMethods.h"

// методы проверки текста
#import "TextValidation.h"

// методы базы данных
#import "DataBaseMethod.h"


@interface RegistrationVC : UIViewController
<UITextFieldDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property int creatEdit;

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext ;

@property (strong, nonatomic) DataBaseMethod * classDataBaseMethod;
@property (strong, nonatomic) TextValidation * classTextValidationMethod;
@property (strong, nonatomic) ImageEditingMethods * classImageEditingMethods;

@property (strong, nonatomic) IBOutlet UIImageView      * imageView;

@property (strong, nonatomic) IBOutlet UITextField      * name;
@property (strong, nonatomic) IBOutlet UITextField      * lastname;

@property (strong, nonatomic) IBOutlet UIBarButtonItem  * rightBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem  * leftBarButtonItem;

@property (strong, nonatomic) IBOutlet UIButton *addPhotoButton;

- (void)initMainUser;
- (void)saveImage: (UIImage  *)image;

@end
