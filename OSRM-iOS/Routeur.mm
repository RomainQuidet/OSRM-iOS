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

- (NSArray *)getRoutesFrom:(CLLocationCoordinate2D)departure to:(CLLocationCoordinate2D)arrival
{
    using namespace osrm;

    NSMutableArray *jsonRoutes = [NSMutableArray array];
    // The following shows how to use the Route service; configure this service
    RouteParameters params;

    params.coordinates.push_back({util::FloatLongitude{departure.longitude}, util::FloatLatitude{departure.latitude}});
    params.coordinates.push_back({util::FloatLongitude{arrival.longitude}, util::FloatLatitude{arrival.latitude}});

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

        auto &waypoints = result.values["waypoints"].get<json::Array>();
        NSLog(@"got %@ waypoints", @(waypoints.values.size()));
        for (NSInteger i=0; i < waypoints.values.size(); i++)
        {
            auto &waypoint = waypoints.values.at(i).get<json::Object>();
            auto &name = waypoint.values["name"].get<json::String>();
            NSLog(@"road snap to %@", [NSString stringWithUTF8String:name.value.c_str()]);
        }
        
        // Let's just use the first route
        auto &route = routes.values.at(0).get<json::Object>();
        const auto distance = route.values["distance"].get<json::Number>().value;
        const auto duration = route.values["duration"].get<json::Number>().value;

        NSMutableDictionary *jsonRoute = [NSMutableDictionary dictionaryWithCapacity:route.values.size()];
        [jsonRoutes addObject:jsonRoute];
        objCRender(jsonRoute, route);

        // Warn users if extract does not contain the default coordinates from above
        if (distance == 0 || duration == 0)
        {
            std::cout << "Note: distance or duration is zero. ";
            std::cout << "You are probably doing a query outside of the OSM extract.\n\n";
        }

        std::cout << "Distance: " << distance << " meter\n";
        std::cout << "Duration: " << duration << " seconds\n";
    }
    else if (status == Status::Error)
    {
        const auto code = result.values["code"].get<json::String>().value;
        const auto message = result.values["message"].get<json::String>().value;

        std::cout << "Code: " << code << "\n";
        std::cout << "Message: " << code << "\n";
    }

    return jsonRoutes;
}

@end
