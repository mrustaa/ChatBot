


#import "AlertAction.h"
#import "ImageLibrary.h"


@implementation ChatTableView (AlertAction)

- (void)alert_ActionSheet_GeoImage {
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle: @"Добавить" message: nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *deleteAction =
    [UIAlertAction actionWithTitle: @"Фотографию из библиотеки"
                             style: UIAlertActionStyleDefault
                           handler: ^(UIAlertAction *action) { [self actionSheet:0]; } ];
    
    UIAlertAction *archiveAction =
    [UIAlertAction actionWithTitle: @"Геолокацию"
                             style: UIAlertActionStyleDefault
                           handler: ^(UIAlertAction *action) { [self actionSheet:1]; } ];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"Отменить" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    
    
    [self presentViewController: alertController animated:YES completion:nil];
}
// делегат UIActionSheet - переход на карту - и библиотеку фотогрфий пользователя _____________________
- (void) actionSheet:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        // библиотека фотографий на устройстве
        ImageLibrary *imglib = [ImageLibrary new];
        imglib.myIndex =1;
        [self presentViewController: imglib animated: YES completion: NULL];
    }
    else if (buttonIndex == 1)  [self performSegueWithIdentifier:@"MapMsg" sender: nil ];
    
    
}


@end
