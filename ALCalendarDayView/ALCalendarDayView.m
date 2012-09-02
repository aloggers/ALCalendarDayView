#import "ALCalendarDayView.h"
#import "ALCalendarDayEventsView.h"

@implementation ALCalendarDayView {
@private
    __weak id <ALCalendarDayViewDataSource> _dataSource;
    UIScrollView* _scrollView;

    ALCalendarDayEventsView* _eventsView;
    BOOL _amPmFormat;
    __weak id <ALCalendarDayViewDelegate> _delegate;
}

@synthesize dataSource = _dataSource;
@synthesize amPmFormat = _amPmFormat;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.backgroundColor = [UIColor colorWithRed:(242.0 / 255.0) green:(242.0 / 255.0) blue:(242.0 / 255.0) alpha:1.0];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width, 1078);
        _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)reloadData {
    NSArray* events = [self.dataSource calendarEventsForDate:[NSDate date]];
    _eventsView = [[ALCalendarDayEventsView alloc] initWithEvents:events];
    _eventsView.amPmFormat = self.amPmFormat;
    _eventsView.frame = CGRectMake(0, 0, self.frame.size.width, 1078);
    NSArray* subviews = _scrollView.subviews;
    for (UIView* subview in subviews) {
        [subview removeFromSuperview];
    }
    [_scrollView addSubview:_eventsView];
}

- (void)setDataSource:(id <ALCalendarDayViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

@end