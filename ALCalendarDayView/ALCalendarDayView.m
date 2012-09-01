#import "ALCalendarDayView.h"
#import "ALCalendarTileView.h"
#import "ALCalendarEvent.h"

#define kTileLeftSide 52.0f
#define kTileRightSide 10.0f

#define kTopLineBuffer 11.0
#define kSideLineBuffer 50.0
#define kHalfHourDiff 22.0

@interface ALCalendarDayEventsView : UIView
@property (nonatomic, strong) NSArray* events;
@property (nonatomic, strong) NSArray* tileViews;
- (id)initWithEvents:(NSArray* )events;
@end

@implementation ALCalendarDayEventsView {
@private
    NSArray* _events;
    NSArray* _tileViews;
}

@synthesize events = _events;
@synthesize tileViews = _tileViews;

static NSArray *timeStrings;
static NSArray *hoursStrings;


+ (void)initialize {
    if(self == [ALCalendarDayEventsView class]) {
        timeStrings = [NSArray arrayWithObjects:@"12",
                                                @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11",
                                                [[NSBundle mainBundle] localizedStringForKey:@"NOON" value:@"" table:@"GCCalendar"],
                                                @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", nil];
        hoursStrings = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12",
                                                 @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", nil];
    }
}

- (id)initWithEvents:(NSArray* )events {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        NSMutableArray* tileViews = [[NSMutableArray alloc] init];
        for (ALCalendarEvent* event in events) {
            ALCalendarTileView* tileView = [[ALCalendarTileView alloc] initWithFrame:CGRectZero];
            tileView.event = event;
            [tileViews addObject:tileView];
        }
        _tileViews = [[NSArray alloc] initWithArray:tileViews];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat width = self.bounds.size.width - kTileLeftSide - kTileRightSide;

    NSDate* lastEndDate = nil;
    NSArray* sortedTiles = [self.tileViews sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ALCalendarTileView* tile1 = obj1;
        ALCalendarTileView* tile2 = obj2;
        NSComparisonResult startCompare = [tile1.event.start compare:tile2.event.start];
        return startCompare != NSOrderedSame ? startCompare : [tile1.event.end compare:tile2.event.end];
    }];
    NSMutableArray* columns = [[NSMutableArray alloc] init];

    for (ALCalendarTileView *tile in sortedTiles) {
        ALCalendarEvent* event = tile.event;
        if (lastEndDate != nil && [event.start compare:lastEndDate] >= 0 ) {
            [ALCalendarDayEventsView packEvents:columns width:width];
            columns = [[NSMutableArray alloc] init];
            lastEndDate = nil;
        }
        BOOL placed = NO;
        for (int i=0; i < [columns count]; i++) {
            NSMutableArray* column = [columns objectAtIndex:i];
            ALCalendarTileView* t = [column lastObject];
            if (![ALCalendarDayEventsView collidesEvent1:t.event event2:tile.event]) {
                [column addObject:tile];
                placed = YES;
                break;
            }
        }

        if (!placed) {
            [columns addObject:[NSMutableArray arrayWithObject:tile]];
        }

        if (lastEndDate == nil || [event.end compare:lastEndDate] > 0) {
            lastEndDate = event.end;
        }

        if ([columns count] > 0) {
            [ALCalendarDayEventsView packEvents:columns width:width];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    // grab current graphics context

    CGContextRef g = UIGraphicsGetCurrentContext();

    CGContextSetRGBFillColor(g, (242.0 / 255.0), (242.0 / 255.0), (242.0 / 255.0), 1.0);

    // fill morning hours light grey
    CGFloat morningHourMax = [ALCalendarDayEventsView yValueForTime:(CGFloat)8];
    CGRect morningHours = CGRectMake(0, 0, self.frame.size.width, morningHourMax - 1);
    CGContextFillRect(g, morningHours);

    // fill evening hours light grey
    CGFloat eveningHourMax = [ALCalendarDayEventsView yValueForTime:(CGFloat)20];
    CGRect eveningHours = CGRectMake(0, eveningHourMax - 1, self.frame.size.width, self.frame.size.height - eveningHourMax + 1);
    CGContextFillRect(g, eveningHours);

    // fill day hours white
    CGContextSetRGBFillColor(g, 1.0, 1.0, 1.0, 1.0);
    CGRect dayHours = CGRectMake(0, morningHourMax - 1, self.frame.size.width, eveningHourMax - morningHourMax);
    CGContextFillRect(g, dayHours);

    // draw hour lines
    CGContextSetShouldAntialias(g, NO);
    const CGFloat solidPattern[2] = {1.0, 0.0};
    CGContextSetRGBStrokeColor(g, 0.0, 0.0, 0.0, .3);
    CGContextSetLineDash(g, 0, solidPattern, 2);
    for (NSInteger i = 0; i < 25; i++) {
        CGFloat yVal = [ALCalendarDayEventsView yValueForTime:(CGFloat)i];
        CGContextMoveToPoint(g, kSideLineBuffer, yVal);
        CGContextAddLineToPoint(g, self.frame.size.width, yVal);
    }
    CGContextStrokePath(g);

    // draw half hour lines
    CGContextSetShouldAntialias(g, NO);
    const CGFloat dashPattern[2] = {1.0, 1.0};
    CGContextSetRGBStrokeColor(g, 0.0, 0.0, 0.0, .2);
    CGContextSetLineDash(g, 0, dashPattern, 2);
    for (NSInteger i = 0; i < 24; i++) {
        CGFloat time = (CGFloat)i + 0.5f;
        CGFloat yVal = [ALCalendarDayEventsView yValueForTime:time];
        CGContextMoveToPoint(g, kSideLineBuffer, yVal);
        CGContextAddLineToPoint(g, self.frame.size.width, yVal);
    }
    CGContextStrokePath(g);

    // draw hour numbers
    CGContextSetShouldAntialias(g, YES);
    [[UIColor blackColor] set];
    UIFont *numberFont = [UIFont boldSystemFontOfSize:14.0];
//    NSArray* arrHours = [NSArray arrayWithArray: [[NSLocale currentLocale] timeIs24HourFormat] ? hoursStrings : timeStrings ];
    NSArray* arrHours = hoursStrings;
    for (NSInteger i = 0; i < 25; i++) {
        CGFloat yVal = [ALCalendarDayEventsView yValueForTime:(CGFloat)i];
        NSString *number = [arrHours objectAtIndex:i];
        CGSize numberSize = [number sizeWithFont:numberFont];
        if(i == 12) {
            [number drawInRect:CGRectMake(kSideLineBuffer - 7 - numberSize.width,
                    yVal - floor(numberSize.height / 2) - 1,
                    numberSize.width,
                    numberSize.height)
                      withFont:numberFont
                 lineBreakMode:UILineBreakModeTailTruncation
                     alignment:UITextAlignmentRight];
        } else {
            [number drawInRect:CGRectMake(0,
                    yVal - floor(numberSize.height / 2) - 1,
                    kSideLineBuffer - 18 - 10,
                    numberSize.height)
                      withFont:numberFont
                 lineBreakMode:UILineBreakModeTailTruncation
                     alignment:UITextAlignmentRight];
        }
    }

    // draw am / pm text
    CGContextSetShouldAntialias(g, YES);
    [[UIColor grayColor] set];
    UIFont *textFont = [UIFont systemFontOfSize:12.0];
    for (NSInteger i = 0; i < 25; i++) {
        NSString *text = nil;
        if (i < 12) {
            text = @"AM";
        }
        else if (i > 12) {
            text = @"PM";
        }
        if (i != 12) {
            CGFloat yVal = [ALCalendarDayEventsView yValueForTime:(CGFloat)i];
            CGSize textSize = [text sizeWithFont:textFont];
            [text drawInRect:CGRectMake(kSideLineBuffer - 7 - textSize.width,
                    yVal - (textSize.height / 2),
                    textSize.width,
                    textSize.height)
                    withFont:textFont];
        }
    }
}
+ (CGFloat)yValueForTime:(CGFloat)time {
    return kTopLineBuffer + (44.0f * time);;
}

+ (void)packEvents:(NSArray* )columns width:(CGFloat)width {
    int n = [columns count];
    for (int i = 0; i < n; i++) {
        NSArray* column = [columns objectAtIndex:i];

        for (int j = 0; j < [column count]; j++) {
            ALCalendarTileView* tile = [column objectAtIndex:j];
            NSDateComponents* components;
            components = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:tile.event.start];
            NSInteger startHour = [components hour];
            NSInteger startMinute = [components minute];

            components = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:tile.event.end];
            NSInteger endHour = [components hour];
            NSInteger endMinute = [components minute];

            CGFloat startPos = startHour * 2 * kHalfHourDiff - 2;
            startPos += (startMinute / 60.0) * (kHalfHourDiff * 2.0);
//            startPos -= tile.event.startsToday ? 0 : kHalfHourDiff * 2.0;

//            if (!tile.event.startsToday && EDGE_STYLE) {
//                CGFloat offset = kHalfHourDiff;
//                startPos -= offset;
//                CGRect rect = tile.titleLabel.frame;
//                rect.origin.y += offset;
//                tile.titleLabel.frame = rect;
//            }

            startPos = floor(startPos);

            CGFloat endPos = endHour * 2 * kHalfHourDiff + 3;
            endPos += (endMinute / 60.0) * (kHalfHourDiff * 2.0);
//            endPos += tile.event.endsToday ? 0 : kHalfHourDiff * 2.0;

//            if (!tile.event.endsToday && EDGE_STYLE) {
//                CGFloat offset = kHalfHourDiff;
//                endPos += offset;
//                CGRect rect = tile.titleLabel.frame;
//                rect.origin.y -= offset;
//                tile.titleLabel.frame = rect;
//            }

            endPos = floor(endPos);

            tile.frame = CGRectMake((i * 1.0 / n * width), startPos, width/n, endPos - startPos);
        }
    }
}

+ (BOOL)collidesEvent1:(ALCalendarEvent* )event1 event2:(ALCalendarEvent* )event2 {
    double start1 = [event1.start timeIntervalSince1970];
    double finish1 = [event1.end timeIntervalSince1970];
    double start2 = [event2.start timeIntervalSince1970];
    double finish2 = event2.end ? [event1.end timeIntervalSince1970] : NSUIntegerMax;

    if (start1 == finish2 && finish1 > start2) {
        return NO;
    }

    double start3 = fmax(start1, start2);
    double finish3 = fmin(finish1, finish2);
    if (start3 >= finish3) {
        return NO;
    }

    return YES;
}

@end

@interface ALCalendarDayView()
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) ALCalendarDayEventsView* eventsView;
@end

@implementation ALCalendarDayView {
@private
    __weak id <ALCalendarDayViewDataSource> _dataSource;
    UIScrollView* _scrollView;

    ALCalendarDayEventsView* _eventsView;
}
@synthesize dataSource = _dataSource;
@synthesize scrollView = _scrollView;
@synthesize eventsView = _eventsView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.backgroundColor = [UIColor colorWithRed:(242.0 / 255.0) green:(242.0 / 255.0) blue:(242.0 / 255.0) alpha:1.0];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width, 1078);
        _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:_scrollView];

        [self reloadData];
    }
    return self;
}

- (void)reloadData {
    NSArray* events = [self.dataSource calendarEventsForDate:[NSDate date]];
    _eventsView = [[ALCalendarDayEventsView alloc] initWithEvents:events];
    _eventsView.frame = CGRectMake(0, 0, self.frame.size.width, 1078);
    NSArray* subviews = _scrollView.subviews;
    for (UIView* subview in subviews) {
        [subview removeFromSuperview];
    }
    [_scrollView addSubview:_eventsView];
}


@end