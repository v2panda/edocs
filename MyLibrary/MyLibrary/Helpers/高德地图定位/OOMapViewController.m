//
//  OOMapViewController.m
//  OOCity
//
//  Created by liu jian on 15/2/3.
//  Copyright (c) 2015年 liu jian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#import "OOMapViewController.h"
#import "OOMapPinView.h"


#define kMapHeight 230.f
#define kPinWidth 21
#define kPinHeight 29

@interface OOMapViewController () <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate,MAMapViewDelegate,AMapSearchDelegate> {
    OOMapPinView *_pinView;/**屏幕中心指示器*/
    BOOL _isCurrentPostion;
    BOOL _showDisplayEndPostion;
    BOOL _searchAround;    /**是否在搜索周边*/
    CLLocationCoordinate2D _resultLocation;
    NSInteger preSeletedIndex;
    
    BOOL _tableViewSelected;
}
@property (nonatomic, strong) MAMapView *mapView;/** 高德地图view*/
@property (nonatomic, strong) AMapSearchAPI *search;/**高德搜索引擎*/

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayController;
@property (nonatomic, strong) NSMutableArray *tips;/**输入提示对象MATips*/
@property (nonatomic,strong)AMapPlaceSearchResponse *POIResponse;/**周边检索点*/

@end

@implementation OOMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    preSeletedIndex  = -1;
    
    _showDisplayEndPostion = NO;
    _searchAround = YES;
    

    //  去掉UIviewController 内部有scrollview时   边缘延伸属性
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    //    --------------------------------------------------
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    
    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"请输入你想要查找的地名";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.searchBar];
    
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar
                                                               contentsController:self];
    self.displayController.delegate = self;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsDelegate = self;
    
    self.tips = [NSMutableArray array];
    
    self.title = @"标注店铺的位置";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(getAddress)];
    //    初始化mapView的容器
    UIView *theMapView = [UIView new];
    theMapView.backgroundColor = [UIColor redColor];
    [self.view addSubview:theMapView];
    theMapView.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), self.view.bounds.size.width, kMapHeight);
    //    初始化mapView
    self.mapView = [[MAMapView alloc] init];
    self.mapView.frame = theMapView.bounds;
    self.mapView.delegate = self;
    [self.mapView setZoomLevel:14.5];
    [theMapView addSubview:self.mapView];
    //    开启定位
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    //    初始屏幕中心指示器
    _pinView = [[OOMapPinView alloc] initWithFrame:CGRectMake(theMapView.frame.size.width * 0.5 - 11,
                                                              theMapView.frame.size.height * 0.5 - 30, 22, 30)];
    [theMapView addSubview:_pinView];
    
    // 回到当前位置
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"show-current"]
            forState:UIControlStateNormal];
    
    button.frame = CGRectMake(10, 180, 41, 41);
    [self.mapView addSubview:button];
    
    [button addTarget:self
               action:@selector(showUserCurrentPostion)
     forControlEvents:UIControlEventTouchUpInside];
    //    初始化搜索器
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey
                                                  Delegate:self];
    self.search.language = AMapSearchLanguage_zh_CN;
    self.search.delegate = self;
    //    初始化周边检索
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(theMapView.frame),
                                                                   self.view.bounds.size.width, self.view.bounds.size.height - 64 - CGRectGetMaxY(theMapView.frame))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    if (self.longtitude && self.latitude) {
        _resultLocation = CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longtitude.doubleValue);
        [self.mapView setCenterCoordinate:_resultLocation];
    }
}
#warning 监听通知取消息

- (void)getAddress {
    if (_resultLocation.latitude && _resultLocation.longitude) {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:_resultLocation.latitude],@"lat",[NSNumber numberWithDouble:_resultLocation.longitude],@"long", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OOGETLOCATIONSUCESSNOTIFICATION"
                                                            object:info];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -
#pragma mark search bar
/**
 *  searchDisplayController的建议结果点击事件
 *
 *  @param searchBar searchBar description
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *key = searchBar.text;
    [self clearAndSearchGeocodeWithKey:key adcode:nil];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = key;
}

- (void)clearAndSearchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    /** 清除annotation. */
    [self clear];
    
    [self searchGeocodeWithKey:key adcode:adcode];
}
/*
 *清除annotation.
 */
- (void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

/** 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    [self.search AMapInputTipsSearch:tips];
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self searchTipsWithKey:searchString];
    
    return YES;
}

/** 地理编码回调.*/
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            _showDisplayEndPostion = YES;
            
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
            
            [self poiSearchByAround:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
            
            [self addAnimationWithLocation:obj.location];
        }
    }];
}
/**
 *  输入提示回调
 *
 *  @param request  <#request description#>
 *  @param response <#response description#>
 */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    
    [self.displayController.searchResultsTableView reloadData];
}
/**
 *  地理编码
 *
 *  @param key    <#key description#>
 *  @param adcode <#adcode description#>
 */
- (void)searchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = key;
    
    if (adcode.length > 0)
    {
        geo.city = @[adcode];
    }
    
    [self.search AMapGeocodeSearch:geo];
}

#pragma mark -
#pragma mark poi search
/**
 *  周边检索
 *
 *  @param coordinate <#coordinate description#>
 */
- (void)poiSearchByAround:(CLLocationCoordinate2D)coordinate {
    preSeletedIndex = -1;
    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    request.searchType          = AMapSearchType_PlaceAround;
    request.location            = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    /* 按照距离排序. */
    request.sortrule            = 1;
    
    request.radius = 2000;//方圆多少米
    //    分页数据
    request.page = 1;
    request.offset = 20;
    
    [self.search AMapPlaceSearch:request];
}

//实现POI搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response {
    if(response.pois.count == 0)
    {
        _POIResponse = nil;
        [self.tableView reloadData];
        
    }else{
        
        //通过AMapPlaceSearchResponse对象处理搜索结果
        NSString *strPoi = @"";
        for (AMapPOI *p in response.pois) {
            strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
        }
        _POIResponse = response;
        [self.tableView reloadData];
    }
}
/**
 *  周边检索失败
 *
 *  @param request <#request description#>
 *  @param error   <#error description#>
 */
- (void)searchRequest:(id)request didFailWithError:(NSError *)error {
    _POIResponse = nil;
    [self.tableView reloadData];
    
}
/**
 *  回到当前位置
 */
- (void)showUserCurrentPostion {
    _showDisplayEndPostion = NO;
    _searchAround = YES;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}
#pragma mark - 取消操作
/**
 *  移除当前控制器
 */
- (void)returnAction {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    [self clearMapView];
    
    [self clearSearch];
}
/**
 *  清理地图
 */
- (void)clearMapView {
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}
/**
 *  清理搜索引擎
 */
- (void)clearSearch {
    self.search.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 定位回调

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        //取出当前位置的坐标
        if (!_isCurrentPostion) {
            if (self.latitude && self.longtitude) {
                
            } else {
                _resultLocation = userLocation.coordinate;
            }
            
            [self searchCurrentLocation];
            _isCurrentPostion = YES;
        }
    }
}
/**
 *  对当前位置进行检索
 */
- (void)searchCurrentLocation {
    if (self.latitude && self.longtitude) {
        [self poiSearchByAround:_resultLocation];
    } else {
        [self poiSearchByAround:self.mapView.userLocation.coordinate];
    }
    
}
/**
 *  自定义大头针
 *
 *  @param mapView    mapView description
 *  @param annotation annotation description
 *
 *  @return
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"current"];
        
        return annotationView;
    } else if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        //        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = NO;
        //        annotationView.draggable                    = YES;
        //        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.image = [UIImage imageNamed:@"move-pin"];
        
        
        
        return annotationView;
    }
    return nil;
}

/*!
 @brief 地图区域即将改变时会调用此接口
 @param mapview 地图View
 @param animated 是否动画
 */

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
}

/*!
 @brief 地图区域改变完成后会调用此接口
 @param mapview 地图View
 @param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    _resultLocation = mapView.centerCoordinate;
    if (_searchAround) {
        if (preSeletedIndex >= 0) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:preSeletedIndex inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:99];
            imageView.hidden = YES;
        }
        preSeletedIndex = -1;
        [self poiSearchByAround:mapView.centerCoordinate];
    }
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [_pinView startAnimation];
    
    _searchAround = YES;
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (self.POIResponse == nil) {
            return 0;
        } else {
            return self.POIResponse.pois.count;
        }
    }
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tipCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tipCell"];
            UIImageView *okImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 16 - 10, cell.contentView.frame.size.height * 0.5 - 5.5, 16, 11)];
            okImageView.image = [UIImage imageNamed:@"ok"];
            okImageView.tag = 99;
            okImageView.hidden = YES;
            [cell.contentView addSubview:okImageView];
        }
        
        UIImageView *okImageView = (UIImageView *)[cell.contentView viewWithTag:99];
        
        
        if (indexPath.row == preSeletedIndex) {
            NSLog(@"&&&&&&&&& %ld",(long)preSeletedIndex);
            okImageView.hidden = NO;
        } else {
            okImageView.hidden = YES;
        }
        
        AMapPOI *p  = _POIResponse.pois[indexPath.row];
        
        
        
        cell.textLabel.text = p.name;
        cell.detailTextLabel.text = p.address;
        return cell;
    } else {
        return  [self configSearchCellForIndexPath:indexPath inTableView:tableView];
    }
}

- (UITableViewCell *)configSearchCellForIndexPath:(NSIndexPath*)indexPath inTableView:(UITableView*)tableView {
    
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.district;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:99];
    imageView.hidden = NO;
    
    _showDisplayEndPostion = YES;
    if (tableView == self.tableView) {
        
        if (preSeletedIndex >= 0) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:preSeletedIndex inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:99];
            imageView.hidden = YES;
        }
        preSeletedIndex = indexPath.row;
        
        _searchAround = NO;
        _tableViewSelected = YES;
        [self selectPoiPointAtIndexPath:indexPath];
    } else {
        _searchAround = YES;
        [self selectTipsAtIndexPath:indexPath];
    }
    
    
}

- (void)selectTipsAtIndexPath:(NSIndexPath*)indexPath {
    
    AMapTip *tip = self.tips[indexPath.row];
    
    [self clearAndSearchGeocodeWithKey:tip.name adcode:tip.adcode];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = tip.name;
}

- (void)selectPoiPointAtIndexPath:(NSIndexPath*)indexPath {
    AMapPOI *p = _POIResponse.pois[indexPath.row];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
    [self.mapView setCenterCoordinate:coor animated:YES];
    
    //修改大头针
    [self addAnnoationWithPoi:p];
}
/**
 *  添加大头针
 *
 *  @param point <#point description#>
 */
- (void)addAnimationWithLocation:(AMapGeoPoint *)point {
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
    annotation.coordinate = coordinate;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
}

- (void)addAnnoationWithPoi:(AMapPOI *)poi {
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    annotation.coordinate = coordinate;
    annotation.title    = poi.name;
    annotation.subtitle = poi.address;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
    
}
#pragma mark - 暂时以隐藏导航栏的方式 修复display往上少走20的bug
#if  0
-(BOOL)prefersStatusBarHidden {
    return YES;
    
}
#endif


@end
