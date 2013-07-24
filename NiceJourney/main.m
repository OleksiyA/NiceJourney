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
#import "Destination.h"
#import "RouteResolver.h"
#import "Route.h"

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

