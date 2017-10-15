


#import "CoreLocation/CoreLocation.h"
#import <MapKit/MapKit.h>

#import "Chat.h"



@interface SPAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end

@interface MapViewController : UIViewController

@end
