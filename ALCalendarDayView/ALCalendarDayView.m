#import "ALCalendarDayView.h"

@interface ALCalendarDayView ()
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) ALCalendarDayEventsView* eventsView;
@end

@implementation ALCalendarDayView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.backgroundColor = [UIColor colorWithRed:(242.0 / 255.0) green:(242.0 / 255.0) blue:(242.0 / 255.0) alpha:1.0];
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, 1078);
        self.scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:self.scrollView];

        self.eventsView = [[ALCalendarDayEventsView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1078)];
        [self.scrollView addSubview:self.eventsView];
    }
    return self;
}

@end