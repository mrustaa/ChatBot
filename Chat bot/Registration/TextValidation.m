


#import "TextValidation.h"


@implementation TextValidation


- (NSString *)textValidation:(NSString *)name {
    
    // если будут обнаружены пробелы - на местах пробелов       разбобъет на отдельные объекты   в массив
    NSArray *words1 = [name componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( [words1 count] != 1 ) return @"Введите корректно Имя и Фамилию";
    if ( 3 > [name length] )   return @"Слишком короткое Имя и Фамилия";
    if ( [name length] > 9 )   return @"Слишком длинное Имя и Фамилия";
    
    return nil;
}



- (NSString *)textValidation:(NSString *)name
                    lastname:(NSString *)lastname
                       image:(UIImageView *)imageView {
    
    // удаляет пробелы вначале и в конце
    name     = [name     stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet] ];
    lastname = [lastname stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet] ];
    
    NSString *message;
    
    BOOL i1 = ( !imageView.image );
    BOOL i2 = [ name     isEqualToString: @"" ];
    BOOL i3 = [ lastname isEqualToString: @"" ];
    
         if (  i1 &&  i2 &&  i3 ) { message = @"Поля для заполнения пустые";    }
    else if (  i1 &&  i2 && !i3 ) { message = @"Добавьте Имя и фотографию";     }
    else if (  i1 && !i2 &&  i3 ) { message = @"Добавьте Фамилию и фотографию"; }
    else if ( !i1 &&  i2 &&  i3 ) { message = @"Добавьте Имя и Фамилию";        }
    else if (  i1 && !i2 && !i3 ) { message = @"Добавьте фотографию";           }
    else if ( !i1 &&  i2 && !i3 ) { message = @"Добавьте Имя";                  }
    else if ( !i1 && !i2 &&  i3 ) { message = @"Добавьте Фамилию";              }
    
    
    if(!message) message = [self textValidation:name];
    if(!message) message = [self textValidation:lastname];
    
    
    return message;
 
}




@end
