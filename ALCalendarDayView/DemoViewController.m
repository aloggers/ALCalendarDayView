#import "DemoViewController.h"
#import "ALCalendarDayView.h"
#import "ALCalendarEvent.h"

@interface DemoViewController () <ALCalendarDayViewDataSource>
@end

@implementation DemoViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ALCalendarDayView* calendarDayView = [[ALCalendarDayView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    calendarDayView.dataSource = self;
    [calendarDayView reloadData];
    [self.view addSubview:calendarDayView];
}

- (NSArray*)calendarEventsForDate:(NSDate*)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSMutableArray* result = [[NSMutableArray alloc] init];
    ALCalendarEvent* workEvent = [[ALCalendarEvent alloc] init];
    workEvent.start = [dateFormatter dateFromString:@"2012-08-08 09:00"];
    workEvent.end = [dateFormatter dateFromString:@"2012-08-08 19:00"];
    ALCalendarEvent* dinnerEvent = [[ALCalendarEvent alloc] init];
    dinnerEvent.start = [dateFormatter dateFromString:@"2012-08-08 13:00"];
    dinnerEvent.end = [dateFormatter dateFromString:@"2012-08-08 14:00"];
    [result addObject:dinnerEvent];
    [result addObject:workEvent];
    return result;
}

@end