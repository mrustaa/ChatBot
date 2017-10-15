


#import "RadiusView.h"


IB_DESIGNABLE
@interface RadiusView ()

@end

@implementation RadiusView

- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.borderColor = [[UIColor colorWithRed: 219.0/255.0 green: 219.0/255.0 blue: 214.0/255.0 alpha: 1.0] CGColor]; // 1 цвет
    self.layer.borderWidth = 0.7; // 2 толщина
    
}
@end

