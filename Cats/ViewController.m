//
//  ViewController.m
//  Cats
//
//  Created by Bennett on 2018-08-16.
//  Copyright © 2018 Bennett. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"
#import "PhotoCollectionViewCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSMutableArray <Photo *> *photoArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getData];
}

-(void)getData{
    self.photoArray = [@[] mutableCopy];
    
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=8759bfb887b8e55c9a7515d8ae1fe5ca&tags=cat"]; // 1
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
        NSDictionary* photos = flcker[@"photos"];
        NSArray* photo = photos[@"photo"];
        
        // If we reach this point, we have successfully retrieved the JSON from the API
        for (NSDictionary *item in photo) { // 4
            Photo *newPhoto = [Photo new];
            
            newPhoto.title = item[@"title"];
            NSLog(@"title: %@", newPhoto.title);
            newPhoto.url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", item[@"farm"], item[@"server"], item[@"id"], item[@"secret"]];
            NSLog(@"url: %@", newPhoto.url);
            [self.photoArray addObject:newPhoto];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
            [self.photoCollectionView reloadData];
            [self.photoCollectionView setNeedsDisplay];
        }];
        
    }]; // 5
    
    [dataTask resume]; // 6
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    Photo* photo = self.photoArray[indexPath.item];
    
    //only load image if it is not loaded
    if (!photo.image)
        photo.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.url]]];
    
    cell.imageView.image = photo.image;
    cell.titleLabel.text = photo.title;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoArray count];
}



@end
