//
//  OSRMService.m
//  OSRM-iOS
//
//  Created by Romain Quidet on 18/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import "OSRMService_Private.h"

@implementation OSRMService

#pragma mark - lifeCycle

- (instancetype)init
{
    NSAssert(NO, @"Use initWithMapData: to init RouteService");
    return nil;
}

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
            _myOsrm = new OSRM(config);
        } catch (...) {
            NSLog(@"exception: OSRM not created ...");
        }
    }
    return self;
}

- (void)dealloc
{
    if (self.myOsrm) {
        delete self.myOsrm;
    }
}

@end
