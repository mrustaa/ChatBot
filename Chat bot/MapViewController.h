
#import "CoreLocation/CoreLocation.h"
#import <MapKit/MapKit.h>

#import "ViewController.h"

@interface SPAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end

@interface MapViewController : UIViewController

@end
