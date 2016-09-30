//
//  ViewController.m
//  Json_Demo
//
//  Created by Priti Suthar on 5/25/16.
//  Copyright © 2016 Priti Suthar. All rights reserved.
// Address book Background queue loading
// json WS
// Json parsing
// url session
#import "ViewController.h"
#import <AddressBook/AddressBook.h>


@interface ViewController (){

    NSMutableArray *greeting;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self callJSonlist];
    [self getPlaces];
    
    [self getContactList];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData{
    //NSString *urlforService =[NSString stringWithFormat:@"http://jsonplaceholder.typicode.com/posts?userId=%@",txtUserID.text];
    NSString *urlforService =[NSString stringWithFormat:@"https://newevolutiondesigns.com/images/freebies/hd-widescreen-wallpaper-2.jpg"];
    NSURL *url = [NSURL URLWithString:urlforService];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    
    //http://jsonplaceholder.typicode.com/posts?userId=5
    
    NSOperationQueue *opt=  [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:opt
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
        
         if (data.length > 0 && connectionError == nil)
         {
             UIImage *img =[UIImage imageWithData:data];
            greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             NSLog( @"%@",greeting);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIImageView *imgV = [[UIImageView alloc]initWithImage:img];
                 imgV.frame = vW.bounds;
                 [vW addSubview:imgV];
                 vW.backgroundColor =[UIColor greenColor];
             });
             
         }
     }];
}

- (IBAction)btnGetData:(id)sender {
    vW.backgroundColor =  [UIColor redColor];
    [self getData];
    
}

- (void)callJSonlist{

    NSURL *url = [NSURL URLWithString:@"http://ip.jsontest.com/"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            
                                                            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                            NSLog(@"Data = %@",text);
                                                        }
                                                        
                                                    }];
    
    [dataTask resume];
    
    
}


- (void)getContactList{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
        NSLog(@"Denied");
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        NSLog(@"Authorized");
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            if (!granted){
                //4
                NSLog(@"Just denied");
                return;
            }
            //5
            NSLog(@"Just authorized");
        });
        NSLog(@"Not determined");
    }

}

- (void)getPlaces{
    
    
    NSURL *url = [NSURL URLWithString:@"http://api.geonames.org/citiesJSON?north=44.1&south=-9.9&east=-22.4&west=55.2&lang=de&username=demo"];
    
    
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError){
                                                   
        greeting = [NSJSONSerialization JSONObjectWithData:data
                                                   options:0
                                                     error:NULL];
        NSLog( @"%@",greeting);
        
        
        
    }];
    
//    Webservice Type : REST
//    Url : api.geonames.org/citiesJSON?
//    Parameters :
//    north,south,east,west : coordinates of bounding box
//    callback : name of javascript function (optional parameter)
//    lang : language of placenames and wikipedia urls (default = en)
//    maxRows : maximal number of rows returned (default = 10)
//    
//    Result : returns a list of cities and placenames in the bounding box, ordered by relevancy (capital/population). Placenames close together are filterered out and only the larger name is included in the resulting list.
//    
//    Example : http://api.geonames.org/citiesJSON?north=44.1&south=-9.9&east=-22.4&west=55.2&lang=de&username=demo
//    
//    This service is also available in XML output :
//    Example : http://api.geonames.org/cities?north=44.1&south=-9.9&east=-22.4&west=55.2&username=demo
}
@end
