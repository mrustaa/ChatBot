



#import "ImageEditingMethods.h"



@implementation ImageEditingMethods


// перекрашивание изображения
- (UIImage *)overlayImage:(UIImage *)image
                withColor:(UIColor *)color {
    
    //  Create rect to fit the PNG image
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    //  Start drawing
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    //  Fill the rect by the final color
    [color setFill];
    CGContextFillRect(context, rect);
    
    //  Make the final shape by masking the drawn color with the images alpha values
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    [image drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1];
    
    //  Create new image from the context
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    //  Release context
    UIGraphicsEndImageContext();
    
    return img;
}

// уменьшение размеров изображения
- (UIImage *)imageRect:(UIImage *)image2
                  size:(CGSize )size {
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);     // Создает графический контекст (размер, не-прозрачный, масштаб)
    [ image2 drawInRect: CGRectMake(0, 0, size.width, size.height)];    // масштабируется изображение (self) для подгонки
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();    			// вернет — представление текущего контекста в качестве изображения
    UIGraphicsEndImageContext();                                //  закрыть контекст
    
    return resizedImage;
}

//  округление краев изображения
- (UIImage *)imageRoundingEdge:(UIImage *)photo {
    
    UIImageView * roundView = [[UIImageView alloc] initWithImage: photo ];
    UIGraphicsBeginImageContextWithOptions( roundView.bounds.size, NO, [UIScreen mainScreen].scale );
    
    [[UIBezierPath bezierPathWithRoundedRect: roundView.bounds
                                cornerRadius: roundView.frame.size.width / 13] addClip];
    
    [photo drawInRect: roundView.bounds];
    
    UIImage *photo_end = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return photo_end;
}


- (CGFloat)imageRect_MaintainingProportions:(CGSize)size
                                   percent:(NSInteger)g
                                  viewSize:(CGSize)viewSize {
    
    
    
    CGFloat i1;
    
    if (     size.width >  ( viewSize.width - g) ) {
        i1 = size.width  / ( viewSize.width - g); // i_10 = 2000 /  200
        i1 = size.height /  i1; //  128 = 1280 / i_10
        return i1;
    }
    else {
        i1 = ( viewSize.width - g) / size.width; //  i_10 = 200 /  20
        i1 = size.height * i1; // i_120 = 12 * i_10
        return i1;
    }
}
@end
