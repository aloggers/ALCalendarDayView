#import <UIKit/UIKit.h>

@class ALCalendarTileView;
@class ALCalendarEvent;

@protocol ALCalendarDayViewDataSource
- (NSArray *)calendarEventsForDate:(NSDate *)date;
@end

@protocol ALCalendarDayViewDelegate
@optional
- (ALCalendarTileView* )tileViewForEvent:(ALCalendarEvent* )event;
@end

@interface ALCalendarDayView : UIView
@property (nonatomic, weak) id<ALCalendarDayViewDataSource> dataSource;
@property (nonatomic, weak) id<ALCalendarDayViewDelegate> delegate;
@property (nonatomic) BOOL amPmFormat;
- (void)reloadData;
@end