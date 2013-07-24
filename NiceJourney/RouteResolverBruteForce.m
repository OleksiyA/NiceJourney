//
//  RouteResolverBruteForce.m
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 24/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "RouteResolverBruteForce.h"
#import "Route.h"

@implementation RouteResolverBruteForce

#pragma mark Internal methods
-(Route*)resolveWithStartingPoint:(Destination*)startingPoint withAvailablePoints:(NSArray*)availablePoints withMaxLehgth:(float)maxLen
{
    Route* route = nil;
    
    if([availablePoints count]==1)
    {
        route = [[Route alloc]init];
        [route appendDestination:startingPoint];
        [route appendDestination:availablePoints[0]];
         
         return route;
    }
    
    //iterate over all available points and find shortest route
    for(int i = 0; i < [availablePoints count]; i ++)
    {
        Destination* destination = availablePoints[i];
        
        NSMutableArray* availablePointsTmp = [[NSMutableArray alloc]initWithArray:availablePoints];
        [availablePointsTmp removeObject:destination];
        
        Route* routeTmp = [self resolveWithStartingPoint:destination withAvailablePoints:availablePointsTmp withMaxLehgth:[route length]];
        
        if(!routeTmp)
        {
            continue;
        }
        
        [routeTmp insertDestinationAtStart:startingPoint];
        
        float lenForFoundRoute = [routeTmp length];
        
        if(maxLen>0 && lenForFoundRoute >= maxLen)
        {
            //skip route as it len exceeded limit
            continue;
        }
        
        if(!route || ([route length]>lenForFoundRoute))
        {
            //save route if this is shortest solution so far
            route = routeTmp;
        }
    }
    
    return route;
}

#pragma mark Allocation and Deallocation

#pragma mark Overriden methods
-(void)resoveRoute
{
    Route* route = [self resolveWithStartingPoint:[self.inputDestinations objectAtIndex:0] withAvailablePoints:[self.inputDestinations subarrayWithRange:NSMakeRange(1, [self.inputDestinations count]-1)] withMaxLehgth:0];
    
    self.outputRoute = route;
}

@end
