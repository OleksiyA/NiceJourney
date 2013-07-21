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
-(id)initWithString:(NSString*)string
{
#warning Implement initWithString
    return nil;
}

#pragma mark Public interface
-(NSString*)stringRepresentation
{
#warning Correct stringRepresentation for Destination
    NSString* string = [NSString stringWithFormat:@"%@",self.title];
    
    return string;
}

@end
