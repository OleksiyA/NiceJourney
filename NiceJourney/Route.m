//
//  Route.m
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 21/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "Route.h"
#import "Destination.h"


@implementation Route

#define EARTH_RADIUS 6378.138

#pragma mark Internal methods
+(double)GetDistance:(double)lat1 long1:(double)lng1 la2:(double)lat2 long2:(double)lng2
{
    double radLat1 = [Route rad:lat1];
    double radLat2 = [Route rad:lat2];
    double a = radLat1 - radLat2;
    double b = [Route rad:lng1] - [Route rad:lng2];
    double s = 2 * asin(sqrt(pow(sin(a/2),2) + cos(radLat1)*cos(radLat2)*pow(sin(b/2),2)));
    s = s * EARTH_RADIUS;
    s = round(s * 10000) / 10000;
    return s;
}

+(double)rad:(double)d
{
    return d *3.14159265 / 180.0;
}

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
        
        float distance = [Route GetDistance:prevDest.coordinates.latitude long1:prevDest.coordinates.longitude la2:dest.coordinates.latitude long2:dest.coordinates.longitude];
        
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
    [self.destinations addObject:destination];
}

-(void)appendRoute:(Route*)route
{
    [self.destinations addObjectsFromArray:route.destinations];
}

-(void)insertDestinationAtStart:(Destination*)destination
{    
    [self.destinations insertObject:destination atIndex:0];
}

@end
