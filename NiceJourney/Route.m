//
//  Route.m
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 21/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Route.h"
#import "Destination.h"

@implementation Route

#pragma mark Internal methods
-(float)calculateLength
{
    if([self.destinations count]<2)
    {
        return 0;
    }
    
    float len = 0;
    
    Destination* prevDest = [self.destinations objectAtIndex:0];
    
    for (int i = 1; i < [self.destinations count]; i++)
    {
        Destination* dest = [self.destinations objectAtIndex:i];
        
        float distance = [[[CLLocation alloc]initWithCoordinate:prevDest.coordinates altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil]distanceFromLocation:[[CLLocation alloc]initWithCoordinate:dest.coordinates altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil]];
        
        len += distance;
        
        prevDest = dest;
    }
    
    return len;
}

#pragma mark Allocation and Deallocation
-(id)init
{
    if(self = [super init])
    {
        self.destinations = [[NSMutableArray alloc]init];
    }
    
    return self;
}

#pragma mark Public interface
-(float)length
{
    return [self calculateLength];
}

-(void)appendDestination:(Destination*)destination
{
    Destination* previousFinalDestination = [self.destinations lastObject];
    
    [self.destinations addObject:destination];
}

-(void)appendRoute:(Route*)route
{
    [self.destinations addObjectsFromArray:route.destinations];
}

-(void)insertDestinationAtStart:(Destination*)destination
{
    Destination* previousFirstDestination = [self.destinations lastObject];
    
    [self.destinations insertObject:destination atIndex:0];
}

@end
