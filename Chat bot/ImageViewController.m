
#import "ImageViewController.h"
//#import "URLViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
{
    CGFloat screenWidth  ;
    CGFloat screenHeight ;
}
@property(nonatomic, strong)          UIImageView     * imageView;
@property(strong, nonatomic) IBOutlet UIScrollView    * scrollView;
@property(nonatomic, strong)          UIImage         * image;

@end



@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth  = screenSize.width;
    screenHeight = screenSize.height;
    
    _scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 64, screenWidth, screenHeight)];
    [self.view addSubview:_scrollView];
    // делаем Navigation Контроллер
    UIView *view1 = [[UIView alloc] initWithFrame: CGRectMake( 0, 0, screenWidth, 29 )];
    view1.backgroundColor =
    [UIColor colorWithRed: 247.0/255.0 green: 247.0/255.0 blue: 247.0/255.0 alpha: 1.0];
    
    /*
    UINavigationBar *_bar2 = [UINavigationBar new];
    _bar2.frame = CGRectMake( 0, 64, screenWidth, 44 );
    [ self.view addSubview: _bar2 ];*/
    
    UINavigationBar *_bar3 = [UINavigationBar new];
    _bar3.frame = CGRectMake( 0, 20, screenWidth, 44 );
    
    
    
    UINavigationItem *_item = [[UINavigationItem alloc] initWithTitle: @""];
    
    UIBarButtonItem  * btn  = [[UIBarButtonItem alloc]  initWithTitle: @"Отмена"
                                                                style: UIBarButtonItemStylePlain
                                                               target: self
                                                               action: @selector( endEditing: )];
    _item.leftBarButtonItem = btn;
    self.navigationItem.leftBarButtonItem = btn;
    [_bar3 pushNavigationItem:_item animated:NO];
    
    [ self.view addSubview: view1 ];
    [ self.view addSubview: _bar3 ];
    

    _scrollView.minimumZoomScale =  0.1;
    _scrollView.maximumZoomScale = 10.0 ;
    _scrollView.delegate = self;


    _imageView = [ [UIImageView alloc] init];
    
    
    [self findLargeImage];
}



-(void)findLargeImage
{

    
    //
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            
            
            UIImage *largeimage = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:[rep orientation]];
            
            

            
             _imageView.image = largeimage;
             _imageView.frame = CGRectMake(0, 0, largeimage.size.width , largeimage.size.height );

           [_scrollView addSubview: self.imageView];
            
            [_scrollView zoomToRect: _imageView.frame animated: 0 ];
        }
    };
    
    //
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)  {  NSLog(@" Не могу получить фото - %@",[myerror localizedDescription]);  };
    
    if(_imageURL /*&& [_imageURL length]*/ )
    {
        //[largeimage release];
        NSURL *asseturl = _imageURL; // [NSURL URLWithString:_imageURL];
        
        // NSLog(@"%@",asseturl);
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init] ;
        [assetslibrary assetForURL:asseturl
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {    return self.imageView;   }

- (IBAction)endEditing:(UIBarButtonItem *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated: YES// self.presentingViewController - контроллер который представил этот класс
                                                      completion: NULL ];		// 	dismissViewControllerAnimated 	удаляет с экрана этот класс
    
}




@end
