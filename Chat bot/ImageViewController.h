



#import <UIKit/UIKit.h>
#import "ImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageViewController : UIViewController
<UIScrollViewDelegate, UISplitViewControllerDelegate>

@property(nonatomic, strong) NSURL      *imageURL;
@property(nonatomic, strong) NSNumber * floatImageHeight;

@property(nonatomic, strong)  UIImageView     * imageView;
@property(strong, nonatomic)  UIScrollView    * scrollView;

@end

