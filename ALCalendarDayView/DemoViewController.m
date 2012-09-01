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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSMutableArray* result = [[NSMutableArray alloc] init];

    ALCalendarEvent* sleepEvent = [[ALCalendarEvent alloc] init];
    sleepEvent.start = [dateFormatter dateFromString:@"2012-08-08 03:00"];
    sleepEvent.end = [dateFormatter dateFromString:@"2012-08-08 08:00"];
    sleepEvent.color = [UIColor colorWithRed:0.1 green:0.9 blue:0.1 alpha:0.6];
    sleepEvent.title = @"Sleep";
    [result addObject:sleepEvent];

    ALCalendarEvent* workEvent = [[ALCalendarEvent alloc] init];
    workEvent.start = [dateFormatter dateFromString:@"2012-08-08 09:00"];
    workEvent.end = [dateFormatter dateFromString:@"2012-08-08 19:00"];
    workEvent.color = [UIColor colorWithRed:0.1 green:0.2 blue:0.9 alpha:0.6];
    workEvent.title = @"Work";
    workEvent.description = @"Developing day calendar view component. Discussing aTimeLogger UI with designer";
    [result addObject:workEvent];

    ALCalendarEvent* dinnerEvent = [[ALCalendarEvent alloc] init];
    dinnerEvent.start = [dateFormatter dateFromString:@"2012-08-08 13:00"];
    dinnerEvent.end = [dateFormatter dateFromString:@"2012-08-08 14:00"];
    dinnerEvent.color = [UIColor colorWithRed:0 green:0.9 blue:0.1 alpha:0.6];
    dinnerEvent.title = @"Dinner";
    dinnerEvent.description = @"Some sea food";
    [result addObject:dinnerEvent];

    return result;
}

@end