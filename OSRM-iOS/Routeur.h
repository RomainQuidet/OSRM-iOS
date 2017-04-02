//
//  Routeur.h
//  OSRM-iOS
//
//  Created by Romain Quidet on 02/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>


@interface Routeur : NSObject

- (instancetype)initWithMapData:(NSString *)path;
- (NSArray *)getRoutesFrom:(CLLocationCoordinate2D)departure to:(CLLocationCoordinate2D)arrival;


@end
