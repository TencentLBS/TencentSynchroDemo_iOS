//
//  PassengerSynchroViewController.m
//  TLSLocusSynchroDubugging
//
//  Created by 薛程 on 2018/11/27.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "PassengerSynchroViewController.h"

#import "TrafficPolyline.h"
#import "RouteLocation.h"
#import "Constants.h"

#import <QMapKit/QMapkit.h>
#import <QMapSDKUtils/QMUMapUtils.h>

typedef NS_ENUM(NSInteger, SynchroStatus)
{
    SynchroStatusNone            = 0,    ///< 未知态.
    SynchroStatusStarted         = 1,    ///< 同步已经启动.
    SynchroStatusStoped          = 2     ///< 同步已经结束.
};

@interface PassengerSynchroViewController ()
<QMapViewDelegate>

@property (nonatomic, assign) SynchroStatus synchroStatus;

@property (nonatomic, strong) TLSPassengerOrder *order;

@property (nonatomic, strong) QMapView *mapView;

@property (nonatomic, strong) UIBarButtonItem *startFetch;

@property (nonatomic, strong) UIBarButtonItem *stopFetch;

@property (nonatomic, assign) NSTimeInterval lastLocationTimestamp;

@property (nonatomic, strong) NSString *currentRouteID;

@property (nonatomic, strong) TrafficPolyline *route;

@property (nonatomic, strong) NSArray<QSegmentStyle *> *routeTraffic;

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) QPointAnnotation *driverPoint;

@end

@implementation PassengerSynchroViewController

#pragma mark -  setup

- (void)setupMap
{
    self.mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.overlookingEnabled = NO;
    
    [self.view addSubview:self.mapView];
}

- (void)setupOrder
{
    self.order = [[TLSPassengerOrder alloc] init];
    self.order.orderID = kSynchroOrderID;
    self.order.orderStatus = 3;
}

- (void)setupInfoLabel
{
    CGRect labelFrame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    
    self.infoLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.textColor     = [UIColor blackColor];
    self.infoLabel.textAlignment = NSTextAlignmentLeft;
    self.infoLabel.text = @"";
    
    [self.view addSubview:self.infoLabel];
}

- (void)setupSynchro
{
    TLSPassengerConfigPreference *config = [[TLSPassengerConfigPreference alloc] init];
    
    config.key = kSynchroKey;
    config.accountID = kSynchroPassengerAccountID;

    self.synchro = [[TLSLocusSynchro alloc] initWithConfigPreference:config];
    
    self.synchro.syncEnabled = NO;
    self.synchro.delegate = self;
    self.synchro.dataSource = self;
    
    [self.synchro start];
}

- (void)setupToolbar
{
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.startFetch    = [[UIBarButtonItem alloc] initWithTitle:@"启动同步" style:UIBarButtonItemStyleDone target:self action:@selector(handleStartFetch:)];
    self.stopFetch     = [[UIBarButtonItem alloc] initWithTitle:@"停止同步" style:UIBarButtonItemStyleDone target:self action:@selector(handleStopFetch:)];
    
    self.toolbarItems = @[flexble, self.startFetch,
                          flexble, self.stopFetch,
                          flexble];
}

#pragma mark - synchro delegate

- (TLSOrder *)orderForLocusSynchro:(TLSLocusSynchro *)synchro
{
    return self.order;
}

- (void)locusSynchro:(TLSLocusSynchro *)synchro didUpdateSyncData:(TLSSyncData *)data
{
    // 更新路线需重新绘制.
    if([self.currentRouteID isEqualToString:data.route.routeID] == NO)
    {
        // 重新绘制路线.
        [self updateRoute:data.route];
    }
    // 相同路线更新路况.
    else
    {
        if(data.route.routeTraffic != nil)
        {
            [self updateRouteTraffic:data.route.routeTraffic];
        }
    }
    
    // 更新位置.
    [self updateLocation:data.locations];

    // 更新信息.
    [self updateInfoLabel:data.order];
}

#pragma mark - map delegate

- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation fromHeading:(BOOL)fromHeading
{
    if(self.synchroStatus != SynchroStatusStarted)
    {
        NSTimeInterval timestamp = [userLocation.location.timestamp timeIntervalSince1970];
        
        if(timestamp == self.lastLocationTimestamp)
        {
            return;
        }

        TLSLocation *location = [[TLSLocation alloc] init];
        location.location = userLocation.location;
        
        [self.synchro updateLocation:location];
        
        self.lastLocationTimestamp = timestamp;
    }
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[TrafficPolyline class]])
    {
        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        
        polylineRender.segmentStyle = self.routeTraffic;
        polylineRender.borderColor  = [UIColor colorWithRed:0 green:0.8 blue:0 alpha:0.15];
        polylineRender.lineWidth    = 10;
        polylineRender.borderWidth  = 1;
        polylineRender.strokeColor  = [UIColor colorWithRed:1 green:0 blue:0 alpha:.248];
        polylineRender.drawSymbol   = YES;
        
        return polylineRender;
    }
    
    return nil;
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *annotationView = (QAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        UIImage *img = [UIImage imageNamed:@"map_icon_driver"];
        
        annotationView.image = img;
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - actions

- (void)updateLocation:(NSArray<TLSLocation *> *)locations
{
    if(locations == nil || locations.count == 0)
    {
        return;
    }
    
    if(self.driverPoint == nil)
    {
        self.driverPoint = [[QPointAnnotation alloc] init];
        self.driverPoint.coordinate = [self driverCoordinate:locations.firstObject];

        [self.mapView addAnnotation:self.driverPoint];
    }
    
    NSMutableArray <RouteLocation *> *locationData = [NSMutableArray new];
    
    RouteLocation *location = [[RouteLocation alloc] init];
    
    QAnnotationViewLayer *layer = (QAnnotationViewLayer *)[self.mapView viewForAnnotation:self.driverPoint].layer;
    
    location.coordinate = CLLocationCoordinate2DMake(layer.coordinate.x, layer.coordinate.y);
    
    for(int i=0;i<locations.count;++i)
    {
        RouteLocation *location = [[RouteLocation alloc] init];
        
        location.coordinate = [self driverCoordinate:locations[i]];
        
        [locationData addObject:location];
    }

    [QMUAnnotationAnimator translateWithAnnotationView:[self.mapView viewForAnnotation:self.driverPoint] locations:locationData duration:4.95 rotateEnabled:YES];
}

- (CLLocationCoordinate2D)driverCoordinate:(TLSLocation *)location
{
    if(location == nil)
    {
        return kCLLocationCoordinate2DInvalid;
    }
    
    if(CLLocationCoordinate2DIsValid(location.matchedCoordinate))
    {
        return location.matchedCoordinate;
    }
    else
    {
        return location.location.coordinate;
    }
}

- (CLLocationDirection)driverDirection:(TLSLocation *)location
{
    if(location == nil)
    {
        return -1;
    }
    
    if(location.matchedCourse != -1)
    {
        return location.matchedCourse;
    }
    else
    {
        return location.location.course;
    }
}

- (void)updateRoute:(TLSRoute *)route
{
    if(self.route != nil)
    {
        [self.mapView removeOverlay:self.route];
    }
    
    self.currentRouteID = route.routeID;
    
    self.route = [self polylineForRoute:route];
    
    [self updateRouteTraffic:route.routeTraffic];
    
    [self.mapView addOverlay:self.route];
}

- (void)updateRouteTraffic:(NSArray<TLSRouteTrafficItem *> *)data
{
    self.routeTraffic = [self getSegmentStylesWithItems:data];
}

- (NSArray<QSegmentStyle *> *)getSegmentStylesWithItems:(NSArray<TLSRouteTrafficItem *> *)items
{
    if(items == nil || items.count == 0) return nil;
    
    NSMutableArray *routeStyles = [NSMutableArray new];
    for(int i = 0;i < items.count; ++i)
    {
        TLSRouteTrafficItem *item = items[i];
        
        QSegmentStyle *routeStyle  = [[QSegmentStyle alloc] init];
        
        routeStyle.startIndex      = (int)item.from;
        routeStyle.endIndex        = (int)item.to;
        routeStyle.colorImageIndex = [self transformColorIndex:item.color];
        
        [routeStyles addObject:routeStyle];
    }
    
    return routeStyles;
}

- (int)transformColorIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            return 4;
        case 1:
            return 3;
        case 2:
            return 2;
        case 3:
            return 1;
        case 4:
            return 9;
        default:
            return 1;
    }
}

- (TrafficPolyline *)polylineForRoute:(TLSRoute *)route
{
    CLLocationCoordinate2D polylineCoords[route.routePoints.count];
    
    for(int i=0;i<route.routePoints.count;++i)
    {
        polylineCoords[i].latitude  = route.routePoints[i].coordinate.latitude;
        polylineCoords[i].longitude = route.routePoints[i].coordinate.longitude;
    }

    
    NSMutableArray* routeLineArray = [NSMutableArray array];
    
    QSegmentStyle *style = [[QSegmentStyle alloc] init];
    
    style.startIndex = 0;
    style.endIndex   = (int)(route.routePoints.count - 1);
    style.colorImageIndex = 4;
    
    [routeLineArray addObject:style];
    
    TrafficPolyline *routeOverlay = [[TrafficPolyline alloc] initWithCoordinates:polylineCoords count:route.routePoints.count arrLine:routeLineArray];
    
    return routeOverlay;
}

- (void)updateInfoLabel:(TLSSyncOrder *)order
{
    self.infoLabel.text = [NSString stringWithFormat:
                           @"已行驶%lu 米 %lu 分钟\n"
                           "剩余%lu 米 %lu 分钟",
                           (unsigned long)order.distance,
                           (unsigned long)order.time,
                           (unsigned long)order.leftDistance,
                           (unsigned long)order.leftTime];
}

- (void)clearInfoLabel
{
    self.infoLabel.text = @"";
}

- (void)handleStartFetch:(UIBarButtonItem *)sender
{
    [self enterIntoStatus:SynchroStatusStarted];
    
    self.synchro.syncEnabled = YES;
    self.synchro.syncTimeInterval = 5;
    
    [self clearInfoLabel];
}

- (void)handleStopFetch:(UIBarButtonItem *)sender
{
    [self enterIntoStatus:SynchroStatusStoped];
    
    self.synchro.syncEnabled = NO;
}

- (void)enterIntoStatus:(SynchroStatus)status
{
    // 更新数据.
    self.synchroStatus = status;
    
    // 更新UI.
    [self updateUIWithStatus:self.synchroStatus];
}

- (void)updateUIWithStatus:(SynchroStatus)status
{
    switch (status)
    {
            // 未知态.
        case SynchroStatusNone:
        {
            self.startFetch.enabled = YES;
            self.stopFetch.enabled  = NO;
            
            break;
        }
            // 同步启动.
        case SynchroStatusStarted:
        {
            self.startFetch.enabled = NO;
            self.stopFetch.enabled  = YES;

            break;
        }
            // 同步结束.
        case SynchroStatusStoped:
        {
            self.startFetch.enabled = YES;
            self.stopFetch.enabled  = NO;
            
            break;
        }
            
        default:
        {
            break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupToolbar];
    
    [self setupMap];
    
    [self setupInfoLabel];
    
    [self setupOrder];
    
    [self setupSynchro];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:animated];
    
    [self enterIntoStatus:SynchroStatusNone];
}

- (void)dealloc
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
