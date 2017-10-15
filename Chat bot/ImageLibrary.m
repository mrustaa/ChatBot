


#import "ImageLibrary.h"

#import "Chat.h"
#import "RegistrationVC.h"

#import "SendSaveMsgInData.h"

@interface ImageLibrary () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIBarButtonItem * cancelButton ;
}
@end

@implementation ImageLibrary



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
   // self.navigationBar.translucent = NO;
   // self.navigationBar.barTintColor = [UIColor colorWithRed:0.147 green:0.413 blue:0.737 alpha:1];
   // self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
   // self.navigationBar.tintColor = [UIColor redColor];
   // self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    cancelButton = [[UIBarButtonItem alloc] initWithTitle: @"Отмена"
                                                    style: UIBarButtonItemStylePlain
                                                   target: self
                                                   action: @selector(showLibrary:)];
    
    
    [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
    self.navigationItem.title = @"Фотографии";
}

- (void)viewDidAppear:	  (BOOL)animated {
    [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
}

// navigationController - переход на библиотеку фотографий - добвление кнопки Отмена - и титул Фотографии
- (void) navigationController: (UINavigationController *) navigationController
       willShowViewController: (UIViewController *) viewController
                     animated: (BOOL) animated {
    
    [viewController.navigationItem setRightBarButtonItem:cancelButton animated:NO];
    viewController.navigationItem.title = @"Фотографии";
}
- (void) showLibrary: (id) sender {
     [self dismissViewControllerAnimated: YES completion: NULL];
}

// возращает изображение - из библитеки фотографий
- (void)imagePickerController: (UIImagePickerController *)picker
didFinishPickingMediaWithInfo: (NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSURL   *url   = info[UIImagePickerControllerReferenceURL ];
    
    if(!self.myIndex) {
        [((RegistrationVC*) (UINavigationController *)self.presentingViewController)
         saveImage: image ];
    }
    else {
    
    [ ((Chat *) ((UINavigationController *)self.presentingViewController).topViewController)
     sendSaveMsgUser: @"user1" type:@"img" message1:image message2: url ];

    }
    
    [self dismissViewControllerAnimated: YES completion: NULL];
}




@end


