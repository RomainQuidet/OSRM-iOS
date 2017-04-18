//
//  RouteService.h
//  OSRM-iOS
//
//  Created by Romain Quidet on 02/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <OSRM/OSRMService.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, ORSMAnnotationOption) {
    ORSMAnnotationOptionNodes = 1 << 0,
    ORSMAnnotationOptionDistance = 1 << 1,
    ORSMAnnotationOptionDuration = 1 << 2,
    ORSMAnnotationOptionDataSources = 1 << 3,
    ORSMAnnotationOptionWeight = 1 << 4,
    ORSMAnnotationOptionSpeed = 1 << 5
};

typedef NS_ENUM(NSUInteger, ORSMGeometry) {
    ORSMGeometryPolyline,       // Default
    ORSMGeometryPolyline6,
    ORSMGeometryGeoJSON
};

typedef NS_ENUM(NSUInteger, ORSMOverview) {
    ORSMOverviewSimplified,     // Default
    ORSMOverviewFull,
    ORSMOverviewFalse
};

typedef NS_ENUM(NSUInteger, OSRMContinueStraight) {
    OSRMContinueStraightDefault,    // Default
    OSRMContinueStraightTrue,
    OSRMContinueStraightFalse
};

/**
 RouteService: Finds the fastest route between coordinates in the supplied order.
 Please refer to online OSRM documentation for more information on
 how to use this service.
 http://project-osrm.org/docs/v5.6.4/api/#route-service
 */

@interface RouteService : OSRMService

@property (nonatomic, assign) BOOL alternatives;    // Default to NO
@property (nonatomic, assign) BOOL steps;           // Default to NO
@property (nonatomic, assign) BOOL annotations;     // Default to NO
@property (nonatomic, assign) ORSMAnnotationOption annotationsOptions;
@property (nonatomic, assign) ORSMGeometry geometries;
@property (nonatomic, assign) ORSMOverview overview;
@property (nonatomic, assign) OSRMContinueStraight continueStraight;


/**
 @brief Generates the offline routes 
 @param departure Coordinates of the departure point
 @param arrival Coordinates of the arrival point
 @return JSON dictionary
 @see ReponseKeys.h for all response keys
 */
- (NSDictionary<NSString *, NSObject *> *)getRoutesFrom:(CLLocationCoordinate2D)departure to:(CLLocationCoordinate2D)arrival;

@end

NS_ASSUME_NONNULL_END
