#import "ALCalendarDayEventsView.h"
#import "ALCalendarEvent.h"
#import "ALCalendarTileView.h"

#define kTileLeftSide 52.0f
#define kTileRightSide 10.0f

#define kTopLineBuffer 11.0
#define kSideLineBuffer 50.0

@interface ALCalendarDayEventsView ()
@property (nonatomic, strong) UIView* tilesContainerView;
@end

@implementation ALCalendarDayEventsView {
@private
    UIView* _tilesContainerView;
    BOOL _amPmFormat;
    __weak id <ALCalendarDayEventsViewDataSource> _dataSource;
    NSDate* _date;
    __weak id <ALCalendarDayEventsViewDelegate> _delegate;
}
@synthesize tilesContainerView = _tilesContainerView;
@synthesize amPmFormat = _amPmFormat;
@synthesize dataSource = _dataSource;
@synthesize date = _date;
@synthesize delegate = _delegate;


static NSArray *timeStrings;
static NSArray *hoursStrings;

+ (void)initialize {
    if(self == [ALCalendarDayEventsView class]) {
        timeStrings = [NSArray arrayWithObjects:@"12",
                                                @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12",
                                                @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", nil];
        hoursStrings = [NSArray arrayWithObjects:@"0:00", @"1:00", @"2:00", @"3:00", @"4:00", @"5:00", @"6:00", @"7:00", @"8:00", @"9:00",
                                                 @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00",
                                                 @"21:00", @"22:00", @"23:00", @"0:00", nil];
    }
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.tilesContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.tilesContainerView];
    }
    return self;
}

- (void)setDataSource:(id <ALCalendarDayEventsViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (void)setDelegate:(id <ALCalendarDayEventsViewDelegate>)delegate {
    _delegate = delegate;
    if (_dataSource != nil) {
        [self reloadData];
    }
}

- (void)reloadData {
    [self.tilesContainerView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        UIView* subview = (UIView* )obj;
        [subview removeFromSuperview];
    }];
    NSArray* events = [self.dataSource calendarEventsForDate:self.date];

    for (ALCalendarEvent* event in events) {
        CGFloat yStartPosition = [self yValueForTime:[self hourFromDate:event.start]] - kTopLineBuffer;
        CGFloat yEndPosition = [self yValueForTime:[self hourFromDate:event.end]] - kTopLineBuffer;
        ALCalendarTileView* tileView = nil;
        if ([self.delegate respondsToSelector:@selector(tileViewForEvent:)]) {
            tileView = [self.delegate tileViewForEvent:event];
            tileView.frame = CGRectMake(0, yStartPosition, 0, yEndPosition - yStartPosition);
        }
        else {
            tileView = [[ALCalendarTileView alloc] initWithFrame:CGRectMake(0, yStartPosition, 0, yEndPosition - yStartPosition)];
            tileView.titleLabel.text = event.title;
            tileView.descriptionLabel.text = event.description;
            tileView.backgroundColor = event.color;
        }
        tileView.event = event;
        [self.tilesContainerView addSubview:tileView];
    }
}

#pragma mark - Drawing

- (void)layoutSubviews {
    CGFloat width = self.bounds.size.width - kTileLeftSide - kTileRightSide;
    self.tilesContainerView.frame = CGRectMake(kTileLeftSide, kTopLineBuffer, 320- kTileLeftSide, self.frame.size.height - kTopLineBuffer);

    NSDate* lastEndDate = nil;
    NSArray* sortedTiles = [self.tilesContainerView.subviews sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ALCalendarTileView* tile1 = obj1;
        ALCalendarTileView* tile2 = obj2;
        NSComparisonResult startCompare = [tile1.event.start compare:tile2.event.start];
        return startCompare != NSOrderedSame ? startCompare : [tile1.event.end compare:tile2.event.end];
    }];
    NSMutableArray* columns = [[NSMutableArray alloc] init];

    for (ALCalendarTileView *tile in sortedTiles) {
        ALCalendarEvent* event = tile.event;
        if (lastEndDate != nil && [event.start compare:lastEndDate] >= 0 ) {
            [self packEvents:columns width:width];
            columns = [[NSMutableArray alloc] init];
            lastEndDate = nil;
        }
        BOOL placed = NO;
        for (NSUInteger i=0; i < [columns count]; i++) {
            NSMutableArray* column = [columns objectAtIndex:i];
            ALCalendarTileView* t = [column lastObject];
            if (![self collidesEvent1:t.event event2:tile.event]) {
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
            [self packEvents:columns width:width];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef g = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(g, self.frame);

    CGContextSetShouldAntialias(g, NO);
    [[UIColor lightGrayColor] setStroke];
    for (NSInteger i = 0; i < 25; i++) {
        CGFloat yVal = [self yValueForTime:i];
        CGContextMoveToPoint(g, kSideLineBuffer, yVal);
        CGContextAddLineToPoint(g, self.frame.size.width, yVal);
    }
    CGContextStrokePath(g);

    CGContextSetShouldAntialias(g, NO);
    const CGFloat dashPattern[2] = {1.0, 1.0};
    [[UIColor lightGrayColor] setStroke];
    CGContextSetLineDash(g, 0, dashPattern, 2);
    for (NSInteger i = 0; i < 24; i++) {
        CGFloat time = (CGFloat)i + 0.5f;
        CGFloat yVal = [self yValueForTime:time];
        CGContextMoveToPoint(g, kSideLineBuffer, yVal);
        CGContextAddLineToPoint(g, self.frame.size.width, yVal);
    }
    CGContextStrokePath(g);

    // draw hour numbers
    CGContextSetShouldAntialias(g, YES);
    [[UIColor grayColor] set];
    UIFont *numberFont = [UIFont boldSystemFontOfSize:14.0];
    NSArray* arrHours = self.amPmFormat ? timeStrings : hoursStrings;
    for (NSUInteger i = 0; i < 25; i++) {
        CGFloat yVal = [self yValueForTime:(CGFloat)i];
        NSString *number = [arrHours objectAtIndex:i];
        CGSize numberSize = [number sizeWithFont:numberFont];
        [number drawInRect:CGRectMake(0, yVal - floor(numberSize.height / 2) - 1, kSideLineBuffer - 10, numberSize.height)
                  withFont:numberFont
             lineBreakMode:UILineBreakModeTailTruncation
                 alignment:UITextAlignmentRight];
    }

    if (self.amPmFormat) {
        CGContextSetShouldAntialias(g, YES);
        [[UIColor grayColor] set];
        UIFont *textFont = [UIFont systemFontOfSize:12.0];
        for (NSInteger i = 0; i < 25; i++) {
            NSString *text = i < 12 ? @"AM" : @"PM";
            CGFloat yVal = [self yValueForTime:(CGFloat)i];
            CGSize textSize = [text sizeWithFont:textFont];
            [text drawInRect:CGRectMake(kSideLineBuffer - 7 - textSize.width, yVal - (textSize.height / 2),
                    textSize.width, textSize.height) withFont:textFont];
        }
    }
}

#pragma mark - Private

- (CGFloat)hourFromDate:(NSDate*)date {
    NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    return components.hour + components.minute / 60.0f;
}

- (CGFloat)yValueForTime:(CGFloat)time {
    return kTopLineBuffer + (44.0f * time);;
}

- (void)packEvents:(NSArray* )columns width:(CGFloat)width {
    int n = [columns count];
    for (NSUInteger i = 0; i < n; i++) {
        NSArray* column = [columns objectAtIndex:i];
        for (NSUInteger j = 0; j < [column count]; j++) {
            ALCalendarTileView* tile = [column objectAtIndex:j];
            tile.frame = CGRectMake(i*1.0/n*width, tile.frame.origin.y, width/n, tile.frame.size.height);
        }
    }
}

- (BOOL)collidesEvent1:(ALCalendarEvent* )event1 event2:(ALCalendarEvent* )event2 {
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