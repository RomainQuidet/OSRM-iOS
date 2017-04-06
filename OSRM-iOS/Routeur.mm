//
//  Routeur.m
//  OSRM-iOS
//
//  Created by Romain Quidet on 02/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import "Routeur.h"
#import "RouterRenderer.h"

#include <osrm/match_parameters.hpp>
#include <osrm/nearest_parameters.hpp>
#include <osrm/route_parameters.hpp>
#include <osrm/table_parameters.hpp>
#include <osrm/trip_parameters.hpp>

#include <osrm/coordinate.hpp>
#include <osrm/engine_config.hpp>
#include <osrm/json_container.hpp>

#include <osrm/osrm.hpp>
#include <osrm/status.hpp>

#include <exception>
#include <iostream>
#include <string>
#include <utility>

#include <cstdlib>


@interface Routeur ()

@property (nonatomic, assign) osrm::OSRM *myOsrm;

@end

@implementation Routeur

#pragma mark - lifeCycle

- (instancetype)initWithMapData:(NSString *)path
{
    self = [super init];
    if (self)
    {
        using namespace osrm;

        // Configure based on a .osrm base path, and no datasets in shared mem from osrm-datastore
        EngineConfig config;
        config.storage_config = {[path cStringUsingEncoding:NSUTF8StringEncoding]};
        config.use_shared_memory = false;

        // Routing machine with several services (such as Route, Table, Nearest, Trip, Match)
        try {
            self.myOsrm = new OSRM(config);
        } catch (...) {
            NSLog(@"exception: OSRM not created ...");
        }

        NSLog(@"All good, OSRM is initialized");
    }
    return self;
}

- (void)dealloc
{
    if (self.myOsrm) {
        delete self.myOsrm;
    }
}

#pragma mark - Public

- (NSDictionary *)getRoutesFrom:(CLLocationCoordinate2D)departure to:(CLLocationCoordinate2D)arrival
{
    using namespace osrm;

    // The following shows how to use the Route service; configure this service
    RouteParameters params;

    params.coordinates.push_back({util::FloatLongitude{departure.longitude}, util::FloatLatitude{departure.latitude}});
    params.coordinates.push_back({util::FloatLongitude{arrival.longitude}, util::FloatLatitude{arrival.latitude}});

    params.alternatives = true;

    // Response is in JSON format
    json::Object result;

    // Execute routing request, this does the heavy lifting
    NSDate *startTime = [NSDate date];
    const auto status = self.myOsrm->Route(params, result);
    NSLog(@"route computation time: %f", -[startTime timeIntervalSinceNow]);

    if (status == Status::Ok)
    {
        auto &routes = result.values["routes"].get<json::Array>();
        NSLog(@"good ! Got %@ routes", @(routes.values.size()));

    }
    else if (status == Status::Error)
    {
        const auto code = result.values["code"].get<json::String>().value;
        const auto message = result.values["message"].get<json::String>().value;

        std::cout << "Code: " << code << "\n";
        std::cout << "Message: " << code << "\n";
    }

    NSMutableDictionary *jsonResult;
    jsonResult = [NSMutableDictionary dictionaryWithCapacity:result.values.size()];
    objCRender(jsonResult, result);

    return jsonResult;
}

@end
