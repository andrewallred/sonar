// ImageCollectionViewCell.m
#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize the image view
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;  // Aspect fill to maintain aspect ratio
        _imageView.clipsToBounds = YES;  // Ensure the image is clipped to avoid overflow
        _imageView.adjustsImageWhenAncestorFocused = YES;
        
        // Initialize the label for text
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:24]; // Adjust the font size
        _titleLabel.textColor = [UIColor whiteColor];    // Set text color
        _titleLabel.textAlignment = NSTextAlignmentCenter; // Center the text
        
        // Add image view and label to the content view
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_titleLabel];
        
        // Disable autoresizing mask and add constraints
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Set constraints to make image view fill the cell and label appear below the image
        [NSLayoutConstraint activateConstraints:@[
            // Image view constraints
            [_imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [_imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [_imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            
            // Label constraints
            [_titleLabel.topAnchor constraintEqualToAnchor:_imageView.bottomAnchor constant:8], // 8 is the padding you can adjust
            [_titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [_titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [_titleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]  // Make label fill the bottom part of the cell
        ]];
    }
    return self;
}

@end
