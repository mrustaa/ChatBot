//
//  MapViewController.m
//  TestChat2
//
//  Created by robert on 04.08.17.
//  Copyright (c) 2017 robert. All rights reserved.
//

#import "MapViewController.h"

#import <MapKit/MapKit.h>
#import <MapKit/MKPinAnnotationView.h>

#import "Cordinatee.h"

@implementation SPAnnotation
@end

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate >
{
    BOOL flag1;
    BOOL flag2;
    UIView  * _view1;
    UIView  * _view2;
    CGFloat screenWidth  ;
    CGFloat screenHeight ;
    MKMapView * _mapView ;
    
}
@property (nonatomic)  CLLocationCoordinate2D                touchMapCoordinate;    // кординаты - после долгого нажатия

//@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic)               CLLocation          *location;
@property (strong, nonatomic)               CLLocationManager   *locationManager;
// Нам нужно установить наше местоположение self.location.​	 Как мы сможем это сделать?		 Нам необходим менеджера местоположения locationManager
@property (strong, nonatomic)               CLGeocoder          * myGeocoder;
@property (strong, nonatomic)               CLPlacemark         * placemark;

@property (nonatomic) CLLocationCoordinate2D coordinate2;

@end

@implementation MapViewController

- (void)viewDidLoad {
    //[super viewDidLoad];
    flag1= 1;
    flag2= 1;
    
    // узнаем размер экрана
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth  = screenSize.width;
    screenHeight = screenSize.height;
    // ___________________________________________________________________________________________________
    // устанавливаем карту
    _mapView = [[MKMapView alloc] initWithFrame: CGRectMake(0, 108, screenWidth, screenHeight - 45) ];
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = true;
    _mapView.scrollEnabled = true;

    [ self.view addSubview: _mapView ];
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
    
                            _view1 = [[UIView alloc] initWithFrame: CGRectMake(0, screenHeight - 45, screenWidth, 45	)];
                            _view1.backgroundColor =  [UIColor whiteColor];
    
                                     UIButton *buttonSymbol = [UIButton buttonWithType: UIButtonTypeInfoDark ];
                                               buttonSymbol.frame = CGRectMake(17,12 ,22 ,22 );
                          [ _view1 addSubview: buttonSymbol ];
    
                                     UIButton *buttonSymbol2 = [UIButton buttonWithType: UIButtonTypeSystem ];
                                               buttonSymbol2.frame = CGRectMake(0, 0, screenWidth, 45	);
                                             [ buttonSymbol2 setTitle: @"      Отправить текущую геопозицию"
                                                             forState: UIControlStateNormal ] ;
                                             [ buttonSymbol2 addTarget:self
                                                                action:@selector(button1:)
                                                      forControlEvents:UIControlEventTouchUpInside];
                          [ _view1 addSubview: buttonSymbol2 ];
    [ self.view addSubview: _view1 ];
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                     UIImage *image = [[UIImage imageNamed:@"image_name"] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
             [button setImage:image forState:UIControlStateNormal];
              button.tintColor = [UIColor redColor];
    */
    // ____________________________________________________________________________________________________
    
    UIView *vieww  = [[UIView alloc] initWithFrame: CGRectMake(17, 125, 46, 46	)];
            vieww.backgroundColor =  [UIColor whiteColor];
            vieww.layer.cornerRadius = 22;
    /*
            vieww.layer.borderColor = [[UIColor colorWithRed: 0/255.0 green: 122.0/255.0 blue: 255.0/255.0 alpha: 0.5]	CGColor];  		// 1 цвет
            vieww.layer.borderWidth = 0.5; 									// 2 толщина
    */
    
    vieww.layer.shadowOffset 	= CGSizeMake(0, 0);  					// смещение от центра
    vieww.layer.shadowOpacity 	= 0.3; 								// непрозрачность
    vieww.layer.shadowRadius 	= 3;									// уровень размытия
    vieww.layer.shadowColor 		= [ [UIColor colorWithRed: 44.0/255.0	//  цвет тени
                                                  green: 62.0/255.0
                                                   blue: 80.0/255.0
                                                  alpha: 1.0        ] CGColor ];
    
    UIButton *buttonSymbol3 = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image2 = [[UIImage imageNamed:@"geo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
             [buttonSymbol3 setBackgroundImage: image2  forState: UIControlStateNormal];
              buttonSymbol3.frame = CGRectMake(8, 8, 30, 30 );
              buttonSymbol3.tintColor = [UIColor colorWithRed: 0/255.0 green: 122.0/255.0 blue: 255.0/255.0 alpha: 1.0];
            [ buttonSymbol3 addTarget:self
                               action:@selector(button3:)
                     forControlEvents:UIControlEventTouchUpInside];
    [ vieww addSubview: buttonSymbol3 ];
    
    [ self.view addSubview: vieww ];
    // ____________________________________________________________________________________________________
    
    _mapView.delegate = self;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;	// делегает получает = self 	значит необходимо( нет не обязательно - они все optional)
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;	// Затем я устанавливаю точность получения данных о местоположении
    _locationManager.distanceFilter=kCLDistanceFilterNone;
  
    _mapView.showsUserLocation = 1;
    
  //  [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation]; 	// старт обновления локации 	= результат в методе делегата
    // NSLog(@" %@ ",_locationManager);
    
    
    // [_mapView setRegion: MKCoordinateRegionMake( CLLocationCoordinate2DMake( 55.537241 ,37.513494) , MKCoordinateSpanMake(0.1, 0.1) ) animated: true];


    //  [_locationManager  stopUpdatingLocation];  	// стоп обновления
    
    // программный жест - долгое нажатие - и метод запускаемый
      UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget: self   action: @selector(handleLongPress:)];
    [_mapView addGestureRecognizer: lpgr ]; // добавить жест MKMapView : UIView
    
}
// кнопка - приблизить к геолокации
- (void)button3:(UIButton *)btn {
    [_mapView setRegion: MKCoordinateRegionMake( CLLocationCoordinate2DMake( ((CLLocation *)_location).coordinate.latitude    ,
                                                                            ((CLLocation *)_location).coordinate.longitude ) ,
                                                MKCoordinateSpanMake(0.02, 0.02) )
               animated: true];

}
// переход назад - снимок и гелокацию
- (void)button1:(UIButton *)btn {
    
    /*

     */
    
    MKMapSnapshotOptions *
    options = [[MKMapSnapshotOptions alloc] init];
    
    options.region =      MKCoordinateRegionMake( CLLocationCoordinate2DMake( ((CLLocation *)_location).coordinate.latitude    ,
                                                                             ((CLLocation *)_location).coordinate.longitude ) ,
                                                 MKCoordinateSpanMake(0.02, 0.02) );
    
    options.scale  = [UIScreen mainScreen].scale;
    options.size   = CGSizeMake( 213,113 /* self.mapView.frame.size.width  / 1.5 , self.mapView.frame.size.width  / 1.5 */ );
    
    MKMapSnapshotter *
    snapshotter = [[MKMapSnapshotter alloc] initWithOptions: options];
    [snapshotter startWithCompletionHandler: ^(MKMapSnapshot *snapshot, NSError *error) {
        
        dispatch_queue_t queue = dispatch_get_main_queue(); 			// Получение главной очереди ( main queue)
        dispatch_async(queue, ^{
            UIImage *image = snapshot.image;
            
            Cordinatee *cordinatee = [Cordinatee new];
                        cordinatee.latitude  = ((CLLocation *)_location).coordinate.latitude;
                        cordinatee.longitude = ((CLLocation *)_location).coordinate.longitude;
            
           
            
            [ ((ViewController *) ((UINavigationController *)self.presentingViewController).topViewController) geoPhoto: image
                                                                                                              cordinate: cordinatee ];
            
            
            [self.presentingViewController dismissViewControllerAnimated: YES// self.presentingViewController - контроллер который представил этот класс
                                                              completion: NULL ];		// 	dismissViewControllerAnimated 	удаляет с экрана этот класс
            
        });
    }];
    
    
}
- (void)button2:(UIButton *)btn {
    
    // NSLog(@" %@ ",_mapView.annotations);
    
    MKMapSnapshotOptions *
    options = [[MKMapSnapshotOptions alloc] init];
    
   // NSLog(@" %f %f ",((CLLocation *)_location).coordinate.latitude , ((CLLocation *)_location).coordinate.longitude );
   // NSLog(@" %f %f ", ((SPAnnotation *)_mapView.annotations[0]).coordinate.latitude  , ((SPAnnotation *)_mapView.annotations[0]).coordinate.longitude  );
    
    options.region =      MKCoordinateRegionMake( CLLocationCoordinate2DMake( _coordinate2.latitude    ,
                                                                              _coordinate2.longitude ) ,
                                                 MKCoordinateSpanMake(0.02, 0.02) );
    
    
    options.scale  = [UIScreen mainScreen].scale;
    options.size   = CGSizeMake( 213,113 /* self.mapView.frame.size.width  / 1.5 , self.mapView.frame.size.width  / 1.5 */ );
    
    MKMapSnapshotter *
    snapshotter = [[MKMapSnapshotter alloc] initWithOptions: options];
    [snapshotter startWithCompletionHandler: ^(MKMapSnapshot *snapshot, NSError *error) {
        
        dispatch_queue_t queue = dispatch_get_main_queue(); 			// Получение главной очереди ( main queue)
        dispatch_async(queue, ^{
            UIImage *image = snapshot.image;
            
            
            
            Cordinatee *cordinatee = [Cordinatee new];
            cordinatee.latitude  = _coordinate2.latitude ;
            cordinatee.longitude = _coordinate2.longitude  ;
            
            [ ((ViewController *) ((UINavigationController *)self.presentingViewController).topViewController) geoPhoto: image
                                                                                                              cordinate: cordinatee ];
            
            
            
            [self.presentingViewController dismissViewControllerAnimated: YES// self.presentingViewController - контроллер который представил этот класс
                                                              completion: NULL ];		// 	dismissViewControllerAnimated 	удаляет с экрана этот класс
            
        });
    }];
    
    
}
// запускается каждый раз при установке локаций    Annotation     добавляет булавку, выноску-титул, выноску-сабтитул, выноску-кнопку, выноску-изображние.
- (MKAnnotationView *)  mapView: (   MKMapView   *)mapView      // карта
              viewForAnnotation: (id<MKAnnotation>)annotation {   // локация
    
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier: @"an"];
    
    
    //NSLog(@"установка булавки %@",[annotation class]);
    if ([annotation class] == [SPAnnotation class]) {
    
        if(flag2) { flag2 = 0;
            
            
            
            [UIView animateWithDuration:0.3 animations: ^{
                _view1.frame = CGRectMake(0, screenHeight -90, screenWidth, 45 );
            }];
            
            _view2 = [[UIView alloc] initWithFrame: CGRectMake(0, screenHeight , screenWidth , 45 )]; // CGRectMake(0, 435 +45, 320, 45	)];
            _view2.backgroundColor =  [UIColor colorWithRed: 233.0/255.0 green: 233.0/255.0 blue: 233.0/255.0 alpha: 1.0];
            
                                             UIButton *buttonSymbol = [UIButton buttonWithType: UIButtonTypeSystem ];
                                                       buttonSymbol.frame = CGRectMake( 0, 0, 320, 45 );
                                                     [ buttonSymbol setTitle: @"          Отправить выбранную геопозицию"
                                                                    forState: UIControlStateNormal ] ;
                                                     [ buttonSymbol addTarget:self
                                                                       action:@selector(button2:)
                                                             forControlEvents:UIControlEventTouchUpInside];
                                  [ _view2 addSubview: buttonSymbol  ];
            [ self.view addSubview: _view2 ];
            
            
            
            [UIView animateWithDuration:0.3 animations: ^{
                _view2.frame = CGRectMake(0, screenHeight -45, screenWidth , 45 );
            }];
        
        }
        
    // _________________________________________________________________________________________________________
    /*
        CLLocationCoordinate2D coordinate = ((SPAnnotation *)annotation).coordinate;
        
        NSString *latitude  = [ NSString stringWithFormat: @"%.12f", coordinate.latitude  ];
        NSString *longitude = [ NSString stringWithFormat: @"%.12f", coordinate.longitude ];
        
        CLLocation *location1 = [ [CLLocation alloc] initWithLatitude: latitude. floatValue
                                                            longitude: longitude.floatValue ];
        
        self.myGeocoder = [[CLGeocoder alloc] init];
        NSLog(@" ! " );
        [self.myGeocoder reverseGeocodeLocation: location1
                              completionHandler: ^(NSArray *placemarks, NSError *error) {
                                  if (error == nil && [placemarks count] > 0) {
                                      CLPlacemark *k = [placemarks lastObject];
                                    //  NSString * vendorLocation = [NSString stringWithFormat:@"%@ %@", _placemark.locality, _placemark.subLocality];
                                      NSLog(@"%@", k.name  );
                                      NSLog(@"%@", k.thoroughfare);
                                      NSLog(@"%@", k.subThoroughfare  );
                                      NSLog(@"%@", k.locality  );
                                      NSLog(@"%@", k.subLocality );
                                      NSLog(@"%@", k.administrativeArea );
                                      NSLog(@"%@", k.subAdministrativeArea );
                                      NSLog(@"%@", k.postalCode );
                                      NSLog(@"%@", k.ISOcountryCode );
                                      NSLog(@"%@", k.country );
                                      NSLog(@"%@", k.inlandWater );
                                      NSLog(@"___________________________");
                                  }
                              }];
         */
    // _________________________________________________________________________________________________________
        
        SPAnnotation* i = annotation;
        _coordinate2 = i.coordinate;
        
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier: @"an"];
    
    MKPinAnnotationView *vieww = [[MKPinAnnotationView alloc] initWithAnnotation: annotation    reuseIdentifier: @"an"];
                         vieww.pinColor = MKPinAnnotationColorGreen; // зеленая булавка
                         vieww.animatesDrop = 1;                     // анимация падения булавки , каждой следующей
                         vieww.annotation = annotation;
                  view = vieww;
        
    }
    return  view;
}


// метод долгого нажития - программный
- (void)handleLongPress: (UIGestureRecognizer *)gestureRecognizer {
    
    
    // состояние жеста
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) return;
    
    //NSLog(@"тап ");
    // кординаты  на View
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    // кординаты на MapView"
    _touchMapCoordinate = [ _mapView convertPoint: touchPoint
                             toCoordinateFromView:_mapView];
    
        SPAnnotation *anotation = [SPAnnotation new];
                      anotation.coordinate = _touchMapCoordinate ;
    [ _mapView removeAnnotations: _mapView.annotations ];
    [ _mapView addAnnotation: anotation ];
}

- (IBAction)snapshotter:(UIButton *)sender {


    
    MKMapSnapshotOptions *
    options = [[MKMapSnapshotOptions alloc] init];
    options.region = _mapView.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size =  CGSizeMake( _mapView.frame.size.width /* / 2 */, _mapView.frame.size.width /* / 2 */ );
    options.showsPointsOfInterest = 1;
    options.showsBuildings = 1;
    
    MKMapSnapshotter *
    snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler: ^(MKMapSnapshot *snapshot, NSError *error) {
        UIImage *image = snapshot.image;
        //NSData *data = UIImagePNGRepresentation(image);
        //[data writeToFile:[self snapshotFilename] atomically:YES];
        UIImageView *img = [UIImageView new];
        img.image = image;
        img.frame = CGRectMake( _mapView.frame.origin.x , _mapView.frame.origin.y, _mapView.frame.size.width /2, _mapView.frame.size.width /2);
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            [self.view addSubview: img];
        });
    }];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"ff");
    
    CLLocationCoordinate2D coordinate = [ _location coordinate ];
    
    
    NSString *latitude  = [ NSString stringWithFormat: @"%.12f", coordinate.latitude  ];
    NSString *longitude = [ NSString stringWithFormat: @"%.12f", coordinate.longitude ];
    
    CLLocation *location1 = [ [CLLocation alloc] initWithLatitude: latitude. floatValue
                                                        longitude: longitude.floatValue ];
    
    self.myGeocoder = [[CLGeocoder alloc] init];
    
    [self.myGeocoder reverseGeocodeLocation: location1
                          completionHandler: ^(NSArray *placemarks, NSError *error) {
         if (error == nil && [placemarks count] > 0) {
             _placemark = [placemarks lastObject];
             NSString * vendorLocation = [NSString stringWithFormat:@"%@ %@", _placemark.locality, _placemark.subLocality];
             NSLog(@"%@",vendorLocation);
         }
     }];
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

//	метод делегата 		получение локации   Вызов метода startUpdatingLocation
// запустит посылку мне информации о местоположении в методе делегата и позволит определять self.location
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {

    
    // NSLog(@"получение местоположения %d",i);
    
    _location = [locations lastObject];
    
    if (flag1) { flag1=0;
    
    [_mapView setRegion: MKCoordinateRegionMake( CLLocationCoordinate2DMake( ((CLLocation *)locations[0]).coordinate.latitude    ,
                                                                             ((CLLocation *)locations[0]).coordinate.longitude ) ,
                                                MKCoordinateSpanMake(0.02, 0.02) )
               animated: true];
    }

    //NSLog(@"%f",_location.altitude); // высота над уровнем моря
    //NSLog(@"%f",_location.speed);    // скорость
    
    
}






@end
