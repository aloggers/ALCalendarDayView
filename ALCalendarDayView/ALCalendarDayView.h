#import <UIKit/UIKit.h>

@protocol ALCalendarDayViewDataSource
- (NSArray *)calendarEventsForDate:(NSDate *)date;
@end

@interface ALCalendarDayView : UIView
@property (nonatomic, weak) id<ALCalendarDayViewDataSource> dataSource;
@property (nonatomic) BOOL amPmFormat;
- (void)reloadData;
@end