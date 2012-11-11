#import "ALCalendarTileView.h"
#import "ALCalendarEvent.h"

@interface ALCalendarTileView()
@end

@implementation ALCalendarTileView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:self.titleLabel];

        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descriptionLabel.backgroundColor = [UIColor clearColor];
        self.descriptionLabel.textColor = [UIColor whiteColor];
        self.descriptionLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.numberOfLines = 0;
        [self addSubview:self.descriptionLabel];

        self.backgroundColor = [UIColor darkGrayColor];
    }

    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    self.titleLabel.frame = CGRectMake(6, 3, self.frame.size.width - 12, 16);
    self.descriptionLabel.frame = CGRectMake(6, self.titleLabel.frame.size.height + 2,
            self.frame.size.width - 12, self.frame.size.height - self.titleLabel.frame.size.height - 14);
}

@end