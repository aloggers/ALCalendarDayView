#import <Foundation/Foundation.h>

@interface ALCalendarEvent : NSObject
@property (nonatomic, strong) NSDate* start;
@property (nonatomic, strong) NSDate* end;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) UIColor* color;
@end