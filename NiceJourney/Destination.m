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
