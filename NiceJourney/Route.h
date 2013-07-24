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
