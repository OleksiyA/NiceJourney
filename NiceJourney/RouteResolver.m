//
//  RouteResolver.m
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 21/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "RouteResolver.h"

@implementation RouteResolver

#pragma mark Internal methods


#pragma mark Allocation and Deallocation


#pragma mark Public interface
+(id)routeResoverWithAlgorithm:(ERouteResolverAlgorithm)algorithm withDestinations:(NSArray*)destinations
{
#warning Implement creating route resolver
    return nil;
}

-(void)resoveRoute
{
    //to be overriden by inherited classes
}

@end
