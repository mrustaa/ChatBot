



#import "RadiusImage.h"


IB_DESIGNABLE
@interface RadiusImage ()


@end

@implementation RadiusImage


- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = self.frame.size.width / 2;

}


@end
