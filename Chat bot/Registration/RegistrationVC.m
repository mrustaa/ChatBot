


#import "RegistrationVC.h"    
#import "alertMessageError.h"
#import "ChatList.h"


@implementation RegistrationVC



- (void)viewDidLoad {
    [super viewDidLoad];

    self.classDataBaseMethod = [[DataBaseMethod alloc] initContext:self.managedObjectContext bot:nil];
    
    self.classTextValidationMethod = [TextValidation new];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    
    self.imageView.image = nil;
    
    if(self.creatEdit == 1){
        self.rightBarButtonItem.title = @"Изменить";
        [self initMainUser];
    }
    else {
        if (self.creatEdit == 0) {
            self.leftBarButtonItem.enabled = NO;
            self.leftBarButtonItem.title = @"";
        }
    }
}
- (void)initMainUser {
    
    UsersRegistration *mainUser = [self.classDataBaseMethod get_mainUser];
    self.name.text     = mainUser.name;
    self.lastname.text = mainUser.lastname;
    self.imageView.image = [UIImage imageWithData: mainUser.photo];
    
    [self.addPhotoButton setImage:nil forState:UIControlStateNormal];
}


- (IBAction)endEditing:(UIBarButtonItem *)sender {
    
    self.name    .text = @"";
    self.lastname.text = @"";
    [ ((ChatList *)((UINavigationController *)self.presentingViewController).topViewController).tableView reloadData ];
    [self.presentingViewController dismissViewControllerAnimated: YES completion: NULL ];
}

- (IBAction)addEditUser {

    NSString * message;
    message = [self.classTextValidationMethod textValidation: self.name.text lastname: self.lastname.text image: self.imageView] ;
    
    if( !message ) {
        switch (self.creatEdit) {
            case 0: [self.classDataBaseMethod create_mainUser_name:self.name.text lastname:self.lastname.text image:self.imageView];break;
            case 1: [self.classDataBaseMethod   edit_mainUser_name:self.name.text lastname:self.lastname.text image:self.imageView];break;
            case 2: [self.classDataBaseMethod      create_bot_name:self.name.text lastname:self.lastname.text image:self.imageView];break;
            default: break;
        }
        [self endEditing:nil];
    }
    else {
        [self alertView_errorMessage: message];
    }
}


// Модальный запуск  библиотеки фотографий
- (IBAction)addEditPhoto:(UIButton *)sender {
    ImageLibrary *imglib = [ImageLibrary new];
    imglib.myIndex =0;
    [self presentViewController: imglib animated: YES completion: NULL];
}

// получение изображения из библиотеки
- (void)saveImage: (UIImage  *)image {

    
    int width  = self.imageView.frame.size.width;
    int height = image.size.height / (image.size.width / width)  ;
    
    UIGraphicsBeginImageContextWithOptions( CGSizeMake( width, height), YES, 0.0);
    [ image drawInRect: CGRectMake(0, 0, width, height) ];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = resizedImage;
    
    
    
    
    [self dismissViewControllerAnimated: YES  completion: NULL];
    [self.addPhotoButton setImage:nil forState:UIControlStateNormal];
}



// прикосновение, скрыть клавиатуру
- (void)dismissKeyboard {
    
    [_name      resignFirstResponder];
    [_lastname  resignFirstResponder]; // выключить клаву
}

// по нажатию "Done" клавиатура пряталась
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



@end
