//
//  main.m
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 19/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

//#define DEF_ENABLE_DEBUG_OUTPUT

#ifdef DEF_ENABLE_DEBUG_OUTPUT

#define LOG(X,...)  NSLog(X,## __VA_ARGS__)

#else//DEF_ENABLE_DEBUG_OUTPUT

#define LOG(X,...)

#endif//DEF_ENABLE_DEBUG_OUTPUT

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "Destination.h"
#import "RouteResolver.h"
#import "Route.h"


//
//  Destination.h
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 19/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Destination : NSObject

@property(nonatomic,strong) NSString*           title;
@property CLLocationCoordinate2D                coordinates;
@property(nonatomic,strong) NSString*           identifier;

-(id)initWithString:(NSString*)string withIdentifier:(NSString*)identifier;
-(NSString*)stringRepresentation;

@end




//
//  Destination.m
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 19/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "Destination.h"

@implementation Destination

#pragma mark Internal methods


#pragma mark Allocation and Deallocation
-(id)initWithString:(NSString*)string withIdentifier:(NSString*)identifier
{
    if(self = [super init])
    {
        //extract components from string, return nil if required component not present
        NSArray* components = [string componentsSeparatedByString:@"("];
        if([components count]<2)
        {
            return nil;
        }
        
        NSString* title = [components objectAtIndex:0];
        
        NSString* coordinates = [[components objectAtIndex:1]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@")"]];
        
        NSArray* coordinatesComponents = [coordinates componentsSeparatedByString:@","];
        if([coordinatesComponents count]<2)
        {
            return nil;
        }
        
        if(![coordinatesComponents[0]length] || ![coordinatesComponents[1]length])
        {
            //coordinates are required for destination object
            return nil;
        }
        
        float lattitude = [coordinatesComponents[0] floatValue];
        float longitude = [coordinatesComponents[1] floatValue];
        
        //all data extracted and expected to be valid
        self.title = title;
        self.coordinates = CLLocationCoordinate2DMake(lattitude, longitude);
        
        self.identifier = identifier;
        
        return self;
    }
    
    return nil;
}

#pragma mark Public interface
-(NSString*)stringRepresentation
{
    NSString* string = [NSString stringWithFormat:@"%@ (%f, %f)", self.title, self.coordinates.latitude, self.coordinates.longitude];
    
    return string;
}

-(NSString*)description
{
    NSString* str = [NSString stringWithFormat:@"<%@ %p, %@>",NSStringFromClass([self class]), self,[self stringRepresentation]];
    
    return str;
}

@end






//
//  Route.h
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 21/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Destination;

@interface Route : NSObject

@property(strong,nonatomic) NSMutableArray*         destinations;

-(float)length;
-(void)appendDestination:(Destination*)destination;
-(void)appendRoute:(Route*)route;
-(void)insertDestinationAtStart:(Destination*)destination;

@end




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





//
//  RouteResolver.h
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 21/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Route;
@class Destination;

typedef enum
{
    ERouteResolverAlgorithmBruteForce=0,
}ERouteResolverAlgorithm;

@interface RouteResolver : NSObject

@property(nonatomic,strong)NSArray*     inputDestinations;
@property(nonatomic,strong)Route*       outputRoute;

+(id)routeResoverWithAlgorithm:(ERouteResolverAlgorithm)algorithm withDestinations:(NSArray*)destinations;

-(void)resoveRoute;

@end



//
//  RouteResolverBruteForce.h
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 24/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "RouteResolver.h"

@interface RouteResolverBruteForce : RouteResolver

@end



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







int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        LOG(@"Application started.");
        
        //parse input parameters
        if(argc<2)
        {
            NSLog(@"Please provide path to input file. Application will close.");
            return -1;
        }
        
        NSString* inputFilePath = [NSString stringWithUTF8String:argv[1]];
        
        LOG(@"Will load input file with path [%@].",inputFilePath);
        
        if(![[NSFileManager defaultManager]fileExistsAtPath:inputFilePath])
        {
            NSLog(@"Input file at path [%@] do not exists. Please provide path to correct input file. Application will close.",inputFilePath);
            return -1;
        }
        
        //extract list of original destinations from file
        NSString* fileContents = [NSString stringWithContentsOfFile:inputFilePath encoding:NSUTF8StringEncoding error:nil];
        
        if(![fileContents length])
        {
            NSLog(@"Unable to read input file at path [%@]. Please provide path to correct input file. Application will close.",inputFilePath);
            return -1;
        }
        
        NSArray* listOfStrings = [fileContents componentsSeparatedByString:@"\n"];
        
        NSMutableArray* inputPoints = [[NSMutableArray alloc]initWithCapacity:[listOfStrings count]];
        for(int i = 0; i < [listOfStrings count]; i++)
        {
            NSString* stringForDestination = listOfStrings[i];
            
            //remove index of destination from string, from input file format description it is presumed that destinations are ordered ascending order
            NSArray* components = [stringForDestination componentsSeparatedByString:@"|"];
            if([components count]<2)
            {
                NSLog(@"Unable to process destination string [%@].",stringForDestination);
                continue;
            }
            
            NSString* stringDestinationWithoutIndex = components[1];
            
            //make identifier for Destination 1 based, so first destination is identifier 1
            Destination* destination = [[Destination alloc]initWithString:stringDestinationWithoutIndex withIdentifier:[NSString stringWithFormat:@"%d",i+1]];
            if(!destination)
            {
                NSLog(@"Unable to process destination string [%@].",stringForDestination);
            }
            else
            {
                [inputPoints addObject:destination];
            }
        }
        
        LOG(@"List of destinations [%@].",inputPoints);
        
        //initialize route resolver
        RouteResolver* resolver = [RouteResolver routeResoverWithAlgorithm:ERouteResolverAlgorithmBruteForce withDestinations:inputPoints];
        
        //resolve route
        [resolver resoveRoute];
        
        Route* resultRoute = [resolver outputRoute];
        
        LOG(@"Printing resolved route. Route lenght [%.2f] km .",[resultRoute length]/1000);
        
        //print result
        for(int i = 0; i < [resultRoute.destinations count]; i++)
        {
            Destination* destination = (resultRoute.destinations)[i];
            
            fputs([[[destination identifier]stringByAppendingString:@"\n"] UTF8String], stdout);
        }
        
        LOG(@"Application finished.");
        
    }
    return 0;
}

