//
//  OSRMService_Private.h
//  OSRM-iOS
//
//  Created by Romain Quidet on 18/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//
#import "OSRMService.h"

#include <osrm/coordinate.hpp>
#include <osrm/engine_config.hpp>
#include <osrm/json_container.hpp>

#include <osrm/osrm.hpp>
#include <osrm/status.hpp>

#include <exception>
#include <utility>

#include <cstdlib>

@interface OSRMService ()

@property (nonatomic, assign) osrm::OSRM *myOsrm;

@end
