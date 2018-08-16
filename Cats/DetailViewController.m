//
//  DetailViewController.m
//  Cats
//
//  Created by Bennett on 2018-08-16.
//  Copyright © 2018 Bennett. All rights reserved.
//

#import "DetailViewController.h"
#import "Photo.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSURL* currentURL;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = self.photo.title;
    self.imageView.image = self.photo.image;
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData{
    
    NSString* strURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&format=json&nojsoncallback=1&api_key=8759bfb887b8e55c9a7515d8ae1fe5ca&photo_id=%@", self.photo.photoID];
    
    NSURL *url = [NSURL URLWithString:strURL]; // 1
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *flcker = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2
        
        if (jsonError) { // 3
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        NSDictionary* photo = flcker[@"photo"];
        NSDictionary* urls = photo[@"urls"];
        NSArray* url = urls[@"url"];
        NSDictionary* photopage =url[0];
        self.currentURL = [NSURL URLWithString:photopage[@"_content"]];
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
//            [self.photoCollectionView reloadData];
//            [self.photoCollectionView setNeedsDisplay];
        }];
        
    }]; // 5
    
    [dataTask resume]; // 6
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)openInBrowser:(UIButton *)sender {
    
    if (self.currentURL)
    {
        SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:self.currentURL];
        svc.delegate = self;
        [self presentViewController:svc animated:YES completion:nil];
    }
}


@end
