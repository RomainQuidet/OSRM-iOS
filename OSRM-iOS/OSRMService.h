//
//  OSRMService.h
//  OSRM-iOS
//
//  Created by Romain Quidet on 18/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 OSRMService: Base class for all OSRM services available:
 Nearest
 Route
 Table (not available)
 Match (not available)
 Trip (not available)
 Tile (not available)
 */

@interface OSRMService : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 @brief Invoked to init the offline OSRM services
 @param path Path to osm files used to route. See online documentation on
 how to generate them: https://github.com/Project-OSRM/osrm-backend/wiki/Running-OSRM
 */
- (instancetype)initWithMapData:(NSString *)path;

@end
