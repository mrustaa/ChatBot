


#import "alertMessageError.h"


@implementation RegistrationVC (alertMessageError)

- (void)alertView_errorMessage:(NSString *)message {
    
    UIAlertController * alertController =
    [UIAlertController alertControllerWithTitle: @"Ошибка" message: message preferredStyle: UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil ]];
    
    [self presentViewController: alertController animated:YES completion:nil];
}

@end
