


#import "FindImageMsg.h"



@implementation Chat (FindImageMsg)




- (void)findImage: (UITapGestureRecognizer *) sender {
    

        
        //--------------------------------------------------------------------------------
        
        // вернет позицию на экране, после нажатия на экран, в виде Point
        CGPoint touchPoint = [sender locationInView: self.tableView ];
        
        // вернет индекс ячейки, исходя из позиции Point
        NSIndexPath * indexPath = [ self.tableView indexPathForRowAtPoint: touchPoint ];
        // вернет ячейку, по указанному индексу
        //UITableViewCell * cell  = [self.tableView cellForRowAtIndexPath:indexPath];
        
        // вернет позицию и размер, который предатвляет из сеюя, суммированную высотову всех ячеек , до указаного индекса
        CGRect rectOfCellInTableView = [self.tableView rectForRowAtIndexPath: indexPath];
        // вернет позицию и размер ячейки, по указанному  рамеру  (суммированная высотову всех ячеек до указаного индекса)
        CGRect rectOfCellInSuperview = [self.tableView convertRect: rectOfCellInTableView toView: self.tableView.superview];
        
        
        //--------------------------------------------------------------------------------
        
        // если ячека есть
        if ( indexPath ) {
            // задевает ли моя указанная позиция , размеров фотографии - и не выходит ли за пределы
            if ( (42 < touchPoint.x) && (touchPoint.x < (42 + self.view.frame.size.width - 110)) ) {
                
                // сообщение является изображением ?
                id obj = [self indx:indexPath.row key:@"img"];
                
                if ([obj class] == [UIImage class]) {
                    
                    if ( [self indx:indexPath.row key:@"url"] ) {
                        //--------------------------------------------------------------------------------
                        NSURL   *url = [self indx:indexPath.row key:@"url"];

                    
                        NSNumber *floatImageHeight = [NSNumber numberWithFloat:rectOfCellInSuperview.origin.y];
                        
                        // запуск перехода - передать изображение
                        [self performSegueWithIdentifier: @"Photo" sender: @[url,floatImageHeight] ];
                        
                        
                    } //--------------------------------------------------------------------------------
                    if ( [self indx:indexPath.row key:@"lat"] ) {
                        Cordinatee *cordinatee = [Cordinatee new];
                        cordinatee.latitude  = ((NSNumber *)[self indx:indexPath.row key:@"lat"]).doubleValue;
                        cordinatee.longitude = ((NSNumber *)[self indx:indexPath.row key:@"lng"]).doubleValue;
                        
                        [self performSegueWithIdentifier: @"Map" sender: cordinatee ];
                    }
                    
                }
            }
        }
        
        
    
    
}


@end
