#import "ALCalendarEvent.h"

@implementation ALCalendarEvent {
@private
    NSDate* _start;
    NSDate* _end;
    UIColor* _color;
    NSString* _description;
    NSString* _title;
}
@synthesize start = _start;
@synthesize end = _end;
@synthesize color = _color;
@synthesize description = _description;
@synthesize title = _title;


@end