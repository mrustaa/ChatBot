



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface ImageEditingMethods : NSObject

- (UIImage *)overlayImage:(UIImage *)image
                withColor:(UIColor *)color;

- (UIImage *)imageRect:(UIImage *)image2
                  size:(CGSize )size;

- (UIImage *)imageRoundingEdge:(UIImage *)photo;

- (CGFloat)imageRect_MaintainingProportions:(CGSize)size
                                    percent:(NSInteger)g
                                   viewSize:(CGSize)viewSize;

@end
