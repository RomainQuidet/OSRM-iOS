//
//  NearestService.h
//  OSRM-iOS
//
//  Created by Romain Quidet on 18/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <OSRM/OSRMService.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Nearest Service: Snaps a coordinate to the street network and returns the nearest n matches.
 Please refer to online OSRM documentation for more information on
 how to use this service.
 http://project-osrm.org/docs/v5.6.4/api/#nearest-service
 */

@interface NearestService : OSRMService

@property (nonatomic, assign) NSUInteger number;

/**
 @brief Get waypoints snapped to route for the provided coordinates
 @param location Coordinates of the location to snap
 @return JSON dictionary
 @see ReponseKeys.h for all response keys
 */
- (NSDictionary<NSString *, NSObject *> *)getWaypointsFrom:(CLLocationCoordinate2D)location;

@end

NS_ASSUME_NONNULL_END
