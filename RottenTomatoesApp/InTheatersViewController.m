//
//  InTheatersViewController.m
//  RottenTomatoesApp
//
//  Created by mac on 29/06/15.
//  Copyright (c) 2015 tester. All rights reserved.
//

#import "InTheatersViewController.h"
#import "AFNetworking.h"
#import "FilmDetailViewController.h"

@interface InTheatersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *inTheatersNow;
@property (strong, nonatomic) FilmDetailViewController *filmDetailViewController;

@end

@implementation InTheatersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeInTheatersRequests];
    [self.navigationItem setTitle:@"In Theaters"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeInTheatersRequests
{
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=n594qzwyec5cdgr3tdrpfee3"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //AFNetworking Asynchronous URL Request
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.inTheatersNow = [responseObject objectForKey:@"movies"];
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
    return [self.inTheatersNow count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *tempDictionary = [[NSDictionary alloc] init];
    tempDictionary= [self.inTheatersNow objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDictionary objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.filmDetailViewController = (FilmDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FilmDetail"];
    self.filmDetailViewController.filmDetail = [self.inTheatersNow objectAtIndex:indexPath.row];
    
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
