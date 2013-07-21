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

-(id)initWithString:(NSString*)string;
-(NSString*)stringRepresentation;

@end
