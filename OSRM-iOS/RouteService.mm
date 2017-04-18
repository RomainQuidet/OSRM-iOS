//
//  Routeur.m
//  OSRM-iOS
//
//  Created by Romain Quidet on 02/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import "OSRMService_Private.h"
#import "RouteService.h"
#import "RouteRenderer.h"
#import "ResponseKeys.h"

#include <osrm/route_parameters.hpp>

#include <osrm/coordinate.hpp>
#include <osrm/engine_config.hpp>
#include <osrm/json_container.hpp>

#include <osrm/osrm.hpp>
#include <osrm/status.hpp>

@implementation RouteService

#pragma mark - lifeCycle

- (instancetype)initWithMapData:(NSString *)path
{
    self = [super initWithMapData:path];
    if (self)
    {
        // options
        _geometries = ORSMGeometryPolyline;
        _overview = ORSMOverviewSimplified;
        _continueStraight = OSRMContinueStraightDefault;
    }
    return self;
}

#pragma mark - Public

- (NSDictionary<NSString *, NSObject *> *)getRoutesFrom:(CLLocationCoordinate2D)departure to:(CLLocationCoordinate2D)arrival
{
    using namespace osrm;

    // The following shows how to use the Route service; configure this service
    RouteParameters params;

    params.coordinates.push_back({util::FloatLongitude{departure.longitude}, util::FloatLatitude{departure.latitude}});
    params.coordinates.push_back({util::FloatLongitude{arrival.longitude}, util::FloatLatitude{arrival.latitude}});

    params.alternatives = self.alternatives;
    params.steps = self.steps;
    params.annotations = self.annotations;
    if (self.annotations)
    {
        // TODO for next route generation
    }
    switch (self.geometries)
    {
        case ORSMGeometryPolyline:
            params.geometries = engine::api::RouteParameters::GeometriesType::Polyline;
            break;
        case ORSMGeometryPolyline6:
            params.geometries = engine::api::RouteParameters::GeometriesType::Polyline6;
            break;
        case ORSMGeometryGeoJSON:
            params.geometries = engine::api::RouteParameters::GeometriesType::GeoJSON;
            break;
    }
    switch (self.overview)
    {
        case ORSMOverviewSimplified:
            params.overview = engine::api::RouteParameters::OverviewType::Simplified;
            break;
        case ORSMOverviewFull:
            params.overview = engine::api::RouteParameters::OverviewType::Full;
            break;
        case ORSMOverviewFalse:
            params.overview = engine::api::RouteParameters::OverviewType::False;
            break;
    }
    switch (self.continueStraight)
    {
        case OSRMContinueStraightDefault:
            break;
        case OSRMContinueStraightTrue:
            params.continue_straight = true;
            break;
        case OSRMContinueStraightFalse:
            params.continue_straight = false;
            break;
    }

    // Response is in JSON format
    json::Object result;

    // Execute routing request, this does the heavy lifting
    const auto status = self.myOsrm->Route(params, result);

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
