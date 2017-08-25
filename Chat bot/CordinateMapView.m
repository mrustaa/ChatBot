
#import <MapKit/MapKit.h>

#import "CordinateMapView.h"

@implementation SPAnnotationn
@end

@interface CordinateMapView () <MKMapViewDelegate >
{
    double latitude ;
    double longitude ;
    CGFloat screenWidth  ;
    CGFloat screenHeight ;
    MKMapView * _mapView ;
}
@end

@implementation CordinateMapView



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"еще не создан");
    
    // узнаем размер экрана
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth  = screenSize.width;
    screenHeight = screenSize.height;
    // ___________________________________________________________________________________________________
    // устанавливаем карту
    _mapView = [[MKMapView alloc] initWithFrame: CGRectMake(0, 0, screenWidth, screenHeight ) ];
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = true;
    _mapView.scrollEnabled = true;
    _mapView.delegate = self;
    
    [ self.view addSubview: _mapView ];
    
    //dispatch_async(dispatch_get_main_queue(), ^(void) {
        
     //   self.navigationController.navigationBar.backItem.title = @"отмена";
    //});
    
    //[self.navigationController  popViewControllerAnimated: YES];
    // ____________________________________________________________________________________________________

    
    // делаем Navigation Контроллер
    UIView *view1 = [[UIView alloc] initWithFrame: CGRectMake( 0, 0, screenWidth, 29 )];
    view1.backgroundColor =
    [UIColor colorWithRed: 247.0/255.0 green: 247.0/255.0 blue: 247.0/255.0 alpha: 1.0];
    
    
    UINavigationBar *_bar2 = [UINavigationBar new];
    _bar2.frame = CGRectMake( 0, 64, screenWidth, 44 );
    [ self.view addSubview: _bar2 ];
    
    UINavigationBar *_bar3 = [UINavigationBar new];
    _bar3.frame = CGRectMake( 0, 20, screenWidth, 44 );
    
    
    
    UINavigationItem *_item = [[UINavigationItem alloc] initWithTitle: @"Карта"];
    
    UIBarButtonItem  * btn  = [[UIBarButtonItem alloc]  initWithTitle: @"Отмена"
                                                                style: UIBarButtonItemStylePlain
                                                               target: self
                                                               action: @selector( endEditing: )];
    _item.leftBarButtonItem = btn;
    self.navigationItem.leftBarButtonItem = btn;
    [_bar3 pushNavigationItem:_item animated:NO];
    
    [ self.view addSubview: view1 ];
    [ self.view addSubview: _bar3 ];
    // ____________________________________________________________________________________________________
    // делаем  segment
    NSArray *itemArray = [NSArray arrayWithObjects: @"Карта", @"Спутник", @"Гибрид", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray ];
    segmentedControl.frame = CGRectMake(16, 72, screenWidth - 31, 29);
    [segmentedControl addTarget:self
                         action:@selector( segment:)
               forControlEvents: UIControlEventValueChanged];
    [ self.view addSubview: segmentedControl ];
    // ____________________________________________________________________________________________________

    [_mapView setRegion: MKCoordinateRegionMake( CLLocationCoordinate2DMake( latitude  , longitude ) , MKCoordinateSpanMake(0.02, 0.02) )
               animated: true];
    
    SPAnnotationn *anotation = [SPAnnotationn new];
    anotation.coordinate =  CLLocationCoordinate2DMake( latitude , longitude);
    [ _mapView removeAnnotations: _mapView.annotations ];
    [ _mapView addAnnotation: anotation ];
    
}

- (MKAnnotationView *)  mapView: (   MKMapView   *)mapView      // карта
              viewForAnnotation: (id<MKAnnotation>)annotation {   // локация
    //NSLog(@"тут");
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier: @"an"];
    
    MKPinAnnotationView *vieww = [[MKPinAnnotationView alloc] initWithAnnotation: annotation    reuseIdentifier: @"an"];
    vieww.pinColor = MKPinAnnotationColorGreen; // зеленая булавка
    vieww.animatesDrop = 1;                     // анимация падения булавки , каждой следующей
    vieww.annotation = annotation;
    view = vieww;
    
    return  view;
    
}

- (void)location : (Cordinatee *)cirdinate {
  
    latitude  = cirdinate.latitude;
    longitude = cirdinate.longitude;

}

// отмена
- (IBAction)endEditing:(UIBarButtonItem *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated: YES// self.presentingViewController - контроллер который представил этот класс
                                                      completion: NULL ];		// 	dismissViewControllerAnimated 	удаляет с экрана этот класс
    
}

// вид-ы карт
- (IBAction)segment:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0) {
        [_mapView setMapType: MKMapTypeStandard];
    }
    else if(sender.selectedSegmentIndex == 1) {
        [_mapView setMapType: MKMapTypeSatellite];
    }
    else if(sender.selectedSegmentIndex == 2) {
        [_mapView setMapType: MKMapTypeHybrid];
    }
}



@end
