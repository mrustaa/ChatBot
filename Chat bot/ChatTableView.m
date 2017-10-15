



#import "ChatTableView.h"


// Category

// создать программно все элементы одной ячейки/сообщения .
#import "CreateMsgElementsProgrammatically.h"



@implementation ChatTableView



// краткая форма обращения к массиву, всех сообщений
- (id) indx:(NSInteger)indx key:(NSString *)str {
    
    return [self.arrayAllMessages[indx] objectForKey: str];
}

// обновление ячеек
- (void)update {
    [ self.tableView reloadData];
    
    [ self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[ self.arrayAllMessages count]-1 inSection:0]
                           atScrollPosition:UITableViewScrollPositionBottom
                                   animated:1];
}

#pragma UITableViewDelegate

// Задать колличество ячеек
- (NSInteger)           tableView:(UITableView *)tableView
            numberOfRowsInSection:(NSInteger)section {
    
    return [ self.arrayAllMessages count];
}

// Задавать расчетную высоту для ячеек
- (CGFloat)             tableView:(UITableView *)tableView
 estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ((NSNumber *)[self indx:indexPath.row key:@"size"]).floatValue;
}

- (CGFloat)             tableView:(UITableView *)tableView
          heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ((NSNumber *)[self indx:indexPath.row key:@"size"]).floatValue;
    
}

// Создание каждой ячейки проходит через этот метод
- (UITableViewCell *)   tableView:(UITableView *)tableView
            cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault   reuseIdentifier: nil];
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *type = [self indx:indexPath.row key:@"type"];
    NSString *name = [self indx:indexPath.row key:@"user"];
    
    if ([ type isEqual: @"" ]) {
        //cell.backgroundColor = [UIColor blackColor];
        return  cell;
    }
    
    
    if ( [ self.cells objectForKey: indexPath] ) {  cell = [ self.cells objectForKey: indexPath]; }
    else {
        
        cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
        
        /*
         if ([type isEqual: @"msg"]) {
         if ([name isEqual: @"user1"]) cell.backgroundColor = [UIColor yellowColor];
         if ([name isEqual: @"user2"]) cell.backgroundColor = [UIColor greenColor];
         }
         else if ([type isEqual: @"img"]) cell.backgroundColor =[UIColor blueColor];
         else cell.backgroundColor =[UIColor redColor];
         */
        
        
        CGRect myFrame;
        UIImageView *userImage = [self createUserImage: name index:(int)indexPath.row]; // аватарка
        
        UITextView  * textView;
        UIImageView * imgView;
        if ([ type isEqual: @"msg" ]) {
            textView = [self createTextMessage:name index:(int)indexPath.row]; // текст сообщения
            myFrame = textView.frame;
        } else {
            imgView = [self createImageMessage:type index:(int)indexPath.row];
            myFrame = imgView.frame;
        }
        
        UILabel * datelabel  = [self createTextDate: name type:type index:(int)indexPath.row frame: myFrame];
        UIImageView * bubble = [self createBubble: name type:type frame: myFrame];
        

        
        // ------------------------------------------------------------------------------------------
        [cell addSubview: userImage];
        [cell addSubview: bubble];
        
        if   ([ type isEqual: @"msg" ]) { [cell addSubview: textView]; }
        else                            { [cell addSubview: imgView ]; }
        [cell addSubview: datelabel];
        
        [ self.cells setObject: cell forKey: indexPath  ];

        // ------------------------------------------------------------------------------------------
    }
    
    return  cell;
    
}






@end

