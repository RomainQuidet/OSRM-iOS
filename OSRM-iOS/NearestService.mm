//
//  NearestService.m
//  OSRM-iOS
//
//  Created by Romain Quidet on 18/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import "NearestService.h"
#import "OSRMService_Private.h"
#import "ResponseKeys.h"
#import "RouteRenderer.h"

#include <osrm/nearest_parameters.hpp>

#include <osrm/coordinate.hpp>
#include <osrm/engine_config.hpp>
#include <osrm/json_container.hpp>

#include <osrm/osrm.hpp>
#include <osrm/status.hpp>

#include <cstdlib>


@implementation NearestService

#pragma mark - Public

- (NSDictionary<NSString *, NSObject *> *)getWaypointsFrom:(CLLocationCoordinate2D)location
{
    using namespace osrm;

    // The following shows how to use the Route service; configure this service
    NearestParameters params;

    params.coordinates.push_back({util::FloatLongitude{location.longitude}, util::FloatLatitude{location.latitude}});
    params.number_of_results = (unsigned int) self.number;

    // Response is in JSON format
    json::Object result;

    // Execute nearest request, this does the heavy lifting
    const auto status = self.myOsrm->Nearest(params, result);

    NSMutableDictionary *jsonResult;
    jsonResult = [NSMutableDictionary dictionaryWithCapacity:result.values.size()];
    objCRender(jsonResult, result);

    if (status == Status::Error)
    {
        NSString *code = jsonResult[OSRMResultCodeKey];
        NSString *message = jsonResult[OSRMResultMessageKey];
        NSLog(@"OSRM error code: %@ - %@", code, message);
    }
    
    return jsonResult;
}

@end
