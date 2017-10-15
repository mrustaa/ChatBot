

#import "CoreLocation/CoreLocation.h"
#import <UIKit/UIKit.h>

#import "CoreLocation/CoreLocation.h"
#import <MapKit/MapKit.h>

#import "Cordinatee.h"

@interface SPAnnotationn : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end

@interface CordinateMapView : UIViewController
- (void)location : (Cordinatee *)cirdinate ;
@end
