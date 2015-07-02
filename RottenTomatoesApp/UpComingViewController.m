//
//  UpComingViewController.m
//  RottenTomatoesApp
//
//  Created by mac on 29/06/15.
//  Copyright (c) 2015 tester. All rights reserved.
//

#import "UpComingViewController.h"
#import "AFNetworking.h"
#import "FilmDetailViewController.h"

@interface UpComingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * UpComingMovies;
@property (strong, nonatomic) FilmDetailViewController *filmDetailViewController;
@end

@implementation UpComingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeInTheatersRequests];
    [self.navigationItem setTitle:@"Up Coming"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeInTheatersRequests
{
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=n594qzwyec5cdgr3tdrpfee3&page_limit=50"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //AFNetworking Asynchronous URL Request
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.UpComingMovies = [responseObject objectForKey:@"movies"];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
    }];
    
    [operation start];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [self.UpComingMovies count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSDictionary *tempDictionary = [[NSDictionary alloc] init];
        tempDictionary= [self.UpComingMovies objectAtIndex:indexPath.row];
        cell.textLabel.text = [tempDictionary objectForKey:@"title"];
    // Thumbnail ImageView in Cell
    id tmp = [tempDictionary objectForKey:@"posters"];
    id tmp2 = [tmp objectForKey:@"thumbnail"];
    
    [cell.imageView sd_setImageWithURL:tmp2 placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell setNeedsLayout];
    }];
        return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.filmDetailViewController = (FilmDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FilmDetail"];
    self.filmDetailViewController.filmDetail = [self.UpComingMovies objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:self.filmDetailViewController animated:YES];
    
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
