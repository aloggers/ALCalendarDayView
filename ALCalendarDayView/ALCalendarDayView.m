#import "ALCalendarDayView.h"

@interface ALCalendarDayView ()
@end

@implementation ALCalendarDayView {
@private
    UIScrollView* _scrollView;
    ALCalendarDayEventsView* _eventsView;
}

@synthesize eventsView = _eventsView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.backgroundColor = [UIColor colorWithRed:(242.0 / 255.0) green:(242.0 / 255.0) blue:(242.0 / 255.0) alpha:1.0];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width, 1078);
        _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:_scrollView];

        _eventsView = [[ALCalendarDayEventsView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1078)];
        [_scrollView addSubview:_eventsView];
    }
    return self;
}

@end