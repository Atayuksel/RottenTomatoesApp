//
//  FilmReviewViewController.m
//  RottenTomatoesApp
//
//  Created by mac on 29/06/15.
//  Copyright (c) 2015 tester. All rights reserved.
//

#import "FilmReviewViewController.h"
#import "AFNetworking.h"

@interface FilmReviewViewController ()
@property (weak, nonatomic) IBOutlet UITextView *reviewLabel;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSArray *reviews;
@end

@implementation FilmReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Reviews"];
    // Do any additional setup after loading the view.
    id links = [self.filmDetail objectForKey:@"links"];
    NSString *reviewsURL = [links objectForKey:@"reviews"];
    reviewsURL = [reviewsURL stringByAppendingString:@"?apikey=n594qzwyec5cdgr3tdrpfee3"];
    self.url = [NSURL URLWithString:reviewsURL];
    NSLog(@"%@", self.url);
    self.reviewLabel.editable = NO;
    [self fetchReviews];
}
-(void)fetchReviews
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    
    //AFNetworking Asynchronous URL Request
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.reviews = [responseObject objectForKey:@"reviews"];
        if ([self.reviews count] > 0){
            NSDictionary *reviewDetail = [self.reviews objectAtIndex:0];
            NSString *tmp;
            NSString *reviewText = [reviewDetail objectForKey:@"quote"];
            for (int i = 1; i < [self.reviews count]; i++){
                reviewDetail = [self.reviews objectAtIndex:i];
                tmp = [reviewDetail objectForKey:@"quote"];
                reviewText = [reviewText stringByAppendingString:@"\n\n"];
                reviewText = [reviewText stringByAppendingString:tmp];
            }
            [self.reviewLabel setText:reviewText];
            
        }
        else{
            [self.reviewLabel setText:@"No recorded review for the moview"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
    }];
    
    [operation start];
    
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
