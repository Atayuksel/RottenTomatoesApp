//
//  FilmDetailViewController.m
//  
//
//  Created by mac on 29/06/15.
//
//

#import "FilmDetailViewController.h"
#import "FilmReviewViewController.h"

@interface FilmDetailViewController ()
@property (strong, nonatomic) FilmReviewViewController *filmReviewViewController;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginConstraint;
@property (weak, nonatomic) IBOutlet UIView *filmDetailView;
@property (weak, nonatomic) IBOutlet UILabel *filmTitle;
@property (weak, nonatomic) IBOutlet UILabel *filmYear;
@property (weak, nonatomic) IBOutlet UILabel *filmCritics;
@property (weak, nonatomic) IBOutlet UILabel *filmScore;
@property (weak, nonatomic) IBOutlet UILabel *filmSynopsis;

@end

@implementation FilmDetailViewController
- (IBAction)reviewButtonPressed:(id)sender {
    self.filmReviewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Review"];
    self.filmReviewViewController.filmDetail = self.filmDetail;
    [self.navigationController pushViewController:self.filmReviewViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // ------------------------------
    // IMAGE DOWNLOAD AND ADD TO VIEW
    id tmp = [self.filmDetail objectForKey:@"posters"];
    NSString *tmp2 = [tmp objectForKey:@"original"];
    
    tmp2 = [self IncreasePosterRes:tmp2];
    NSURL *url = [NSURL URLWithString:tmp2];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:url
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                // do something with image
                                [self.posterImageView setImage:image];
                            }
                        }];
    //-------------------------------
    
    // Film Title
    NSString *title = [self.filmDetail objectForKey:@"title"];
    [self.filmTitle setText:title];
    
    // Film Year
    NSNumber *filmYearint = [self.filmDetail objectForKey:@"year"];
    NSString *filmYearStr = [filmYearint stringValue];
    self.filmYear.text = filmYearStr;
    
    // Film Critics
    
    id ratingcritics = [self.filmDetail objectForKey:@"ratings"];
    ratingcritics = [ratingcritics objectForKey:@"critics_rating"];
    self.filmCritics.text = ratingcritics;
    
    // Critics Score
    id scorecritics = [self.filmDetail objectForKey:@"ratings"];
    scorecritics =[scorecritics objectForKey:@"critics_score"];
    NSString * strscore = [scorecritics stringValue];
    strscore = [strscore stringByAppendingString:@" / 100"];
    self.filmScore.text = strscore;
    
    // Film Synopsis
    [self.filmSynopsis sizeToFit];
    self.filmSynopsis.text = [self.filmDetail objectForKey:@"synopsis"];
    if ([self.filmSynopsis.text  isEqual: @""]){
        self.filmSynopsis.text = @"No synopsis for this movie";
    }
    self.topMarginConstraint.constant = 395;
}
- (IBAction)swipeUp:(UISwipeGestureRecognizer *)sender {
    self.topMarginConstraint.constant = 20;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)swipeDown:(UISwipeGestureRecognizer *)sender {
    self.topMarginConstraint.constant = 395;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}



- (NSString *)IncreasePosterRes: (NSString*)url {
    NSRange range = [url rangeOfString:@".*cloudfront.net/" options:NSRegularExpressionSearch];
    NSString *highresURL = url;
    if (range.length > 0) {
        highresURL = [url stringByReplacingCharactersInRange:range withString:@"https://content5.flixster.com/"];
    }
    //NSString *filmName = [address stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return highresURL;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
