//
//  RouteResolver.h
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 21/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov.
//  The MIT License (MIT).
//

#import <Foundation/Foundation.h>

@class Route;
@class Destination;

typedef enum {
    ERouteResolverAlgorithmBruteForce=0,
}ERouteResolverAlgorithm;

@interface RouteResolver : NSObject

@property(nonatomic,strong)NSArray      *inputDestinations;
@property(nonatomic,strong)Route        *outputRoute;

+ (instancetype)routeResoverWithAlgorithm:(ERouteResolverAlgorithm)algorithm withDestinations:(NSArray *)destinations;

- (void)resoveRoute;

@end
