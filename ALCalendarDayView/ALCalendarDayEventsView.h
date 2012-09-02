#import <UIKit/UIKit.h>

@interface ALCalendarDayEventsView : UIView
@property (nonatomic) BOOL amPmFormat;
- (id)initWithEvents:(NSArray* )events;
@end
