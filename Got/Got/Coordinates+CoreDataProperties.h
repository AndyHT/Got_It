//
//  Coordinates+CoreDataProperties.h
//  Got
//
//  Created by 一川 on 6/13/15.
//  Copyright © 2015 huoteng. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Coordinates.h"

NS_ASSUME_NONNULL_BEGIN

@interface Coordinates (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSDate *time;
@property (nullable, nonatomic, retain) NSString *id;

@end

NS_ASSUME_NONNULL_END
