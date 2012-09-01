#import "ALCalendarTileView.h"
#import "ALCalendarEvent.h"

@interface ALCalendarTileView()
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* descriptionLabel;
@end

@implementation ALCalendarTileView {
@private
    ALCalendarEvent* _event;
    UILabel* _titleLabel;
    UILabel* _descriptionLabel;
}
@synthesize event = _event;
@synthesize titleLabel = _titleLabel;
@synthesize descriptionLabel = _descriptionLabel;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];

        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        _descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
        _descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
        _descriptionLabel.numberOfLines = 0;
        [self addSubview:_descriptionLabel];

        self.backgroundColor = [UIColor darkGrayColor];
    }

    return self;
}

- (void)setEvent:(ALCalendarEvent*)event {
    _event = event;
    _titleLabel.text = event.title;
    _descriptionLabel.text = event.description;
    self.backgroundColor = event.color;
}

- (void)layoutSubviews {
    if (self.event.color) {
        self.backgroundColor = self.event.color;
    }
    else {
        self.backgroundColor = [UIColor darkGrayColor];
    }
    _titleLabel.frame = CGRectMake(6, 3, self.frame.size.width - 12, 16);
    _descriptionLabel.frame = CGRectMake(6, _titleLabel.frame.size.height + 2,
            self.frame.size.width - 12, self.frame.size.height - _titleLabel.frame.size.height - 14);
}

@end