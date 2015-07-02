//
//  SearchViewController.m
//  RottenTomatoesApp
//
//  Created by mac on 30/06/15.
//  Copyright (c) 2015 tester. All rights reserved.
//

#import "SearchViewController.h"
#import "AFNetworking.h"
#import "FilmDetailViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *searchedText;
@property (strong, nonatomic) NSArray *searchedMovies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FilmDetailViewController *filmDetailViewController;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Search"];
    //self.navigationItem.titleView = self.searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",searchBar.text);
    [self searchDatabase:searchBar.text];
}
-(void)searchDatabase:(NSString *)address
{
    NSString *tmp = @"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=n594qzwyec5cdgr3tdrpfee3&q=";
    NSString *filmName = [address stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    tmp = [tmp stringByAppendingString:filmName];
    tmp = [tmp stringByAppendingString:@"&page_limit=50"];
    NSURL *url = [NSURL URLWithString:tmp];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //AFNetworking Asynchronous URL Request
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.searchedMovies = [responseObject objectForKey:@"movies"];
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
    return [self.searchedMovies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *tempDictionary = [[NSDictionary alloc] init];
    tempDictionary= [self.searchedMovies objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDictionary objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.filmDetailViewController = (FilmDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FilmDetail"];
    self.filmDetailViewController.filmDetail = [self.searchedMovies objectAtIndex:indexPath.row];
    
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
