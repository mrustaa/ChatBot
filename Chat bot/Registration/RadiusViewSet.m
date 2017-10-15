


#import "RadiusViewSet.h"

IB_DESIGNABLE
@interface RadiusViewSet ()
@end


@implementation RadiusViewSet

- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = self.frame.size.width / 10;
    
}


@end
