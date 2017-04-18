//
//  ResponseKeys.h
//  OSRM-iOS
//
//  Created by Romain Quidet on 18/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

// Result dic keys
static NSString * const OSRMResultCodeKey = @"code";
static NSString * const OSRMResultWaypointsKey = @"waypoints";
static NSString * const OSRMResultRoutesKey = @"routes";
static NSString * const OSRMResultMessageKey = @"message";

// Code values
static NSString * const OSRMCodeOk = @"Ok";

// Route dic keys
static NSString * const OSRMRouteDistanceKey = @"distance";
static NSString * const OSRMRouteDurationKey = @"duration";
static NSString * const OSRMRouteGeometryKey = @"geometry";
static NSString * const OSRMRouteWeightKey = @"weight";
static NSString * const OSRMRouteWeightNameKey = @"weight_name";
static NSString * const OSRMRouteLegsKey = @"legs";

// Route leg dic keys
static NSString * const OSRMRouteLegDistanceKey = @"distance";
static NSString * const OSRMRouteLegDurationKey = @"duration";
static NSString * const OSRMRouteLegWeightKey = @"weight";
static NSString * const OSRMRouteLegsummaryKey = @"summary";
static NSString * const OSRMRouteLegStepsKey = @"steps";
static NSString * const OSRMRouteLegAnnotationKey = @"annotation";

// Route step dic keys
static NSString * const OSRMRouteStepDistanceKey = @"distance";
static NSString * const OSRMRouteStepDurationKey = @"duration";
static NSString * const OSRMRouteStepGeometryKey = @"geometry";
static NSString * const OSRMRouteStepWeightKey = @"weight";
static NSString * const OSRMRouteStepNameKey = @"name";
static NSString * const OSRMRouteStepRefKey = @"ref";
static NSString * const OSRMRouteStepPronunciationKey = @"pronunciation";
static NSString * const OSRMRouteStepDestinationsKey = @"destinations";
static NSString * const OSRMRouteStepModeKey = @"mode";
static NSString * const OSRMRouteStepManeuverKey = @"maneuver";
static NSString * const OSRMRouteStepIntersectionsKey = @"intersections";
static NSString * const OSRMRouteStepRotaryNameKey = @"rotary_name";
static NSString * const OSRMRouteStepRotaryPronunciationKey = @"rotary_pronunciation";

// Waypoint dic keys
static NSString * const OSRMWaypointNameKey = @"name";
static NSString * const OSRMWaypointHintKey = @"hint";
static NSString * const OSRMWaypointLocationKey = @"location";
static NSString * const OSRMWaypointDistanceKey = @"distance";
