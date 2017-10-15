




#import "ImageViewController.h"

#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>



@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing:)] ];
    
    self.imageView  = [[UIImageView  alloc] init];
    self.imageView.frame = self.view.frame;
   // self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame: self.view.frame];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale =  1.0;
    self.scrollView.maximumZoomScale = 10.0 ;
    // self.scrollView.bouncesZoom = 0;

    
    //[self createNavigationController];
    
    [self.view addSubview: self.imageView];
    
    [self findLargeImage];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    // ширина изображения
    int width2 = (self.view.frame.size.width);
    
    // выясняем высоту изображения
    int height2 =
    (self.imageView.frame.size.height / ( self.imageView.frame.size.width / width2));
    
    int yPosition2 = (self.view.frame.size.height / 2) - (height2 / 2) ;
    
    [UIView animateWithDuration: 0.3
                     animations: ^(void) {
                         
                         self.imageView.frame =CGRectMake(0,yPosition2,width2,height2);
                         
                     }
                     completion: ^(BOOL finished) { } ];
    
    [self.scrollView addSubview: self.imageView];
    [self.view       addSubview: self.scrollView];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    
    // ширина изображения
    int width = (self.view.frame.size.width - 118);
    
    // выясняем высоту изображения
    int height =
    self.imageView.image.size.height / ( self.imageView.image.size.width / ( self.view.frame.size.width - 118 ));
    
    // переместить  на 70 пикселей от правого края
    int plus70 = self.view.frame.size.width - (self.view.frame.size.width - 118) -70;
    
    [UIView animateWithDuration: 0.2
                     animations: ^(void) {
                         self.imageView.frame =
                         CGRectMake ( plus70 , self.floatImageHeight.integerValue +5 ,  width , height );
                     }
                     completion: ^(BOOL finished) { } ];

}


// получение изображения из библиотеки
-(void)findLargeImage {

    
    
        
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs: @[self.imageURL] options:nil];
    PHAsset *imageAsset = result.firstObject;

   // NSLog(@"%d %d",(int)imageAsset.pixelWidth,(int) imageAsset.pixelHeight);
    
    CGSize cellSize = CGSizeMake(imageAsset.pixelWidth, imageAsset.pixelHeight);
    
    PHImageRequestOptions *
    options = [PHImageRequestOptions new];
    options.synchronous = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset: imageAsset targetSize:cellSize contentMode:PHImageContentModeAspectFill options:options resultHandler: ^(UIImage * _Nullable result, NSDictionary * _Nullable info)
     {
         
         // NSLog(@"- %f %f",result.size.width,result.size.height);
         
         self.imageView.image = result;
         
         // ширина изображения
         int width = (self.view.frame.size.width - 118);
         
         // выясняем высоту изображения
         int height =
         self.imageView.image.size.height / ( self.imageView.image.size.width / ( self.view.frame.size.width - 118 ));
         
         // переместить  на 70 пикселей от правого края
         int plus70 = self.view.frame.size.width - (self.view.frame.size.width - 118) -70;
         
         
         self.imageView.frame =
         CGRectMake ( plus70 , self.floatImageHeight.integerValue +5 ,  width , height );
         
     }];
   
}


- (void)createNavigationController {
    
    // делаем Navigation Контроллер
    UIView *
    view = [[UIView alloc] initWithFrame: CGRectMake( 0, 0, self.view.frame.size.width, 29 )];
    view.backgroundColor =
    [UIColor colorWithRed: 247.0/255.0 green: 247.0/255.0 blue: 247.0/255.0 alpha: 1.0];
    
    
    UINavigationBar *
    bar = [UINavigationBar new];
    bar.frame = CGRectMake( 0, 20, self.view.frame.size.width, 44 );
    
    
    
    UINavigationItem * item = [[UINavigationItem alloc] initWithTitle: @""];
    
    UIBarButtonItem  * btn  = [[UIBarButtonItem alloc]  initWithTitle: @"Отмена"
                                                                style: UIBarButtonItemStylePlain
                                                               target: self
                                                               action: @selector( endEditing: )];
    item.leftBarButtonItem = btn;
    self.navigationItem.leftBarButtonItem = btn;
    [bar pushNavigationItem: item animated:NO];
    
    [ self.view addSubview: view ];
    [ self.view addSubview: bar ];
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {    return self.imageView;   }

- (IBAction)endEditing:(UIBarButtonItem *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated: YES  completion: NULL ];
    
}




@end
