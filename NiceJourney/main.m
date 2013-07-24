//
//  main.m
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 19/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#define DEF_ENABLE_DEBUG_OUTPUT

#ifdef DEF_ENABLE_DEBUG_OUTPUT

#define LOG(X,...)  NSLog(X,## __VA_ARGS__)

#else//DEF_ENABLE_DEBUG_OUTPUT

#define LOG(X,...)

#endif//DEF_ENABLE_DEBUG_OUTPUT


#import <Foundation/Foundation.h>



//
//  Destination.h
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 19/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef double CLLocationDegrees;

typedef struct {
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
} CLLocationCoordinate2D;

@interface Destination : NSObject
{
    NSString*           title;
    CLLocationCoordinate2D                coordinates;
    NSString*           identifier;
}

@property(nonatomic,retain) NSString*           title;
@property CLLocationCoordinate2D                coordinates;
@property(nonatomic,retain) NSString*           identifier;

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


@implementation Destination

@synthesize title;
@synthesize coordinates;
@synthesize identifier;

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
        
        if(![[coordinatesComponents objectAtIndex:0]length] || ![[coordinatesComponents objectAtIndex:1]length])
        {
            //coordinates are required for destination object
            return nil;
        }
        
        float lattitude = [[coordinatesComponents objectAtIndex:0] floatValue];
        float longitude = [[coordinatesComponents objectAtIndex:1] floatValue];
        
        //all data extracted and expected to be valid
        self.title = title;
        
        CLLocationCoordinate2D coordinates2D;
        
        coordinates2D.latitude = lattitude;
        coordinates2D.longitude = longitude;
        
        self.coordinates = coordinates2D;
        
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
{
    NSMutableArray*         destinations;
}

@property(retain,nonatomic) NSMutableArray*         destinations;

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



@implementation Route

@synthesize destinations;

#define EARTH_RADIUS 6378.138

#pragma mark Internal methods
+(double)rad:(double)d
{
    return d *3.14159265 / 180.0;
}

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

-(float)calculateLength
{
    if([self.destinations count]<2)
    {
        return 0;
    }
    
    float len = 0;
    
    Destination* prevDest = [self.destinations objectAtIndex:0];
    
    int i = 1;
    for (; i < [self.destinations count]; i++)
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
{
    NSArray*     inputDestinations;
    Route*       outputRoute;
}

@property(nonatomic,retain)NSArray*     inputDestinations;
@property(nonatomic,retain)Route*       outputRoute;

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


@interface RouteResolverBruteForce : RouteResolver


@end




//
//  RouteResolver.m
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 21/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//


@implementation RouteResolver

@synthesize inputDestinations;
@synthesize outputRoute;

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


@implementation RouteResolverBruteForce

#pragma mark Internal methods
-(Route*)resolveWithStartingPoint:(Destination*)startingPoint withAvailablePoints:(NSArray*)availablePoints withMaxLehgth:(float)maxLen
{
    Route* route = nil;
    
    if([availablePoints count]==1)
    {
        route = [[Route alloc]init];
        [route appendDestination:startingPoint];
        [route appendDestination:[availablePoints objectAtIndex:0]];
        
        return route;
    }
    
    //iterate over all available points and find shortest route
    int i = 0;
    for(; i < [availablePoints count]; i ++)
    {
        Destination* destination = [availablePoints objectAtIndex:i];
        
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



int processFile(const char * filePath)
{
    NSString* inputFilePath = [NSString stringWithUTF8String:filePath];
    
    LOG(@"Will load input file with path [%@].",inputFilePath);
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:inputFilePath])
    {
        NSLog(@"Input file at path [%@] do not exists. Please provide path to correct input file. Application will close.",inputFilePath);
        return -1;
    }
    
    //extract list of original destinations from file
    NSError* error = nil;
    NSString* fileContents = [NSString stringWithContentsOfFile:inputFilePath encoding:NSUTF8StringEncoding error:&error];
    
    if(![fileContents length])
    {
        NSLog(@"Unable to read input file at path [%@]. Please provide path to correct input file. Application will close.",inputFilePath);
        return -1;
    }
    
    NSArray* listOfStrings = [fileContents componentsSeparatedByString:@"\n"];
    
    NSMutableArray* inputPoints = [[NSMutableArray alloc]initWithCapacity:[listOfStrings count]];
    int i = 0;
    for(; i < [listOfStrings count]; i++)
    {
        NSString* stringForDestination = [listOfStrings objectAtIndex:i];
        
        //remove index of destination from string, from input file format description it is presumed that destinations are ordered ascending order
        NSArray* components = [stringForDestination componentsSeparatedByString:@"|"];
        if([components count]<2)
        {
            NSLog(@"Unable to process destination string [%@].",stringForDestination);
            continue;
        }
        
        NSString* stringDestinationWithoutIndex = [components objectAtIndex:1];
        
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
    i = 0;
    for(; i < [resultRoute.destinations count]; i++)
    {
        Destination* destination = [resultRoute.destinations objectAtIndex:i];
        
        fputs([[[destination identifier]stringByAppendingString:@"\n"] UTF8String], stdout);
    }
    
    LOG(@"Application finished.");

    return 0;
}


int main(int argc, const char * argv[])
{

    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    LOG(@"Application started.");
    
    //parse input parameters
    if(argc<2)
    {
        NSLog(@"Please provide path to input file. Application will close.");
        return -1;
    }
    
    NSString* inputFilePath = [NSString stringWithUTF8String:argv[1]];
    
    
    int ret_val = processFile([inputFilePath UTF8String]);
    if(ret_val)
    {
        return ret_val;
    }
    
    
    [pool release];
    
    return 0;
}

