//
//  RouteResolver.m
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 21/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "RouteResolver.h"
#import "RouteResolverBruteForce.h"

@implementation RouteResolver

#pragma mark Internal methods


#pragma mark Allocation and Deallocation


#pragma mark Public interface
+(id)routeResoverWithAlgorithm:(ERouteResolverAlgorithm)algorithm withDestinations:(NSArray*)destinations
{
    RouteResolver* resolver = nil;
    
    switch (algorithm)
    {
        case ERouteResolverAlgorithmBruteForce:
            resolver = [[RouteResolverBruteForce alloc]init];
            break;
    }
    
    if(resolver)
    {
        resolver.inputDestinations = destinations;
    }
    
    return resolver;
}

-(void)resoveRoute
{
    //to be overriden by inherited classes
}

@end
