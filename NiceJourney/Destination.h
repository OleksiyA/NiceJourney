//
//  Destination.h
//  NiceJourney
//
//  Created by Oleksiy Ivanov on 19/07/2013.
//  Copyright (c) 2013 Oleksiy Ivanov.
//  The MIT License (MIT).
//

#import <Foundation/Foundation.h>

typedef double CLLocationDegrees;

typedef struct {
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
} CLLocationCoordinate2D;

@interface Destination : NSObject

@property(nonatomic,strong) NSString            *title;
@property CLLocationCoordinate2D                coordinates;
@property(nonatomic,strong) NSString            *identifier;

- (instancetype)initWithString:(NSString *)string withIdentifier:(NSString *)identifier;
- (NSString *)stringRepresentation;

@end
