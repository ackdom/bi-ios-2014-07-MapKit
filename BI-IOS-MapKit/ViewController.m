//
//  ViewController.m
//  BI-IOS-MapKit
//
//  Created by Dominik Vesely on 10/11/14.
//  Copyright (c) 2014 Ackee s.r.o. All rights reserved.
//

#import "ViewController.h"
#import <PXAPI.h>
#import "MapViewController.h"
#import "CollectionViewController.h"
@import CoreLocation;

@interface ViewController ()
@property (nonatomic,strong) NSArray* data;
@property (nonatomic,strong) CLLocationManager* manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    UITableView* table = [[UITableView alloc] initWithFrame:self.view.bounds];
    table.dataSource = self;
    table.delegate = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView = table;
    [self.view addSubview:table];
    
    self.data = @[@"Search by Term", @"Search by Position", @"Upload Photo"];
    
    
    
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = _data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
     
        UIAlertController* alertController = [self createController];
       // [self presentViewController:alertController animated:YES completion:nil];
        
        CollectionViewController* coll = [CollectionViewController new];
        [self presentViewController:coll animated:YES completion:nil];
        
    } else if(indexPath.row == 1){
              
        MapViewController* map = [MapViewController new];
        [self.navigationController pushViewController:map animated:YES];
        
    
    } else if(indexPath.row == 2) {
        
        
        NSData* data  = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"krtek" ofType:@"jpg"]];
        
        [PXRequest authenticateWithUserName:@"bi-ios" password:@"fitios" completion:^(BOOL stop) {
            [PXRequest requestToUploadPhotoImage:data name:@"Krtek" description:@"Krtek v letadle" completion:^(NSDictionary *results, NSError *error) {
                NSLog(@"..");
            }];
        }];
       
        
    }
    
}





- (UIAlertController*) createController {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Stop!"
                                          message:@"Enter your search query!"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Term", @"Login");
     }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *termField = alertController.textFields.firstObject;
                                   NSString* term = termField.text;
                                   NSLog(@"%@",term);
                                   
                                   
                                   [PXRequest requestForSearchTerm:term
                                                         searchTag:nil                                                             searchGeo:nil
                                                              page:1
                                                    resultsPerPage:60
                                                        photoSizes:PXPhotoModelSizeThumbnail
                                                            except:PXPhotoModelCategoryUncategorized
                                                        completion:^(NSDictionary *results, NSError *error) {
                                                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                            if (results) {
                                                                NSLog(@"%@",results);
                                                            }
                                                        }];
                                   
                                   
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    return alertController;
}



@end