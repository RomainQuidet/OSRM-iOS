//
//  RouteRenderer.h
//  OSRM-iOS
//
//  Created by Romain Quidet on 05/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <osrm/json_container.hpp>

void objCRender(NSMutableDictionary *out, const osrm::util::json::Object &object);
