//
//  BeaconBean.h
//  FeasycomWatch
//
//  Created by ericj on 2018/1/31.
//  Copyright © 2018年 LIDONG. All rights reserved.
//

typedef enum {
    IBEACON = 0,
    EDDYSTONE_URL,
    EDDYSTONE_UID,
    ALTBEACON
    
} BEACONTYPE;

#import <Foundation/Foundation.h>

@interface BeaconBean : NSObject

//broadcast index
@property (nonatomic, assign) int index;
//beacon type
@property (nonatomic, assign) BEACONTYPE beaconType;
//iBeacon
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, assign) int major;
@property (nonatomic, assign) int minor;
//eddystone_url
@property (nonatomic, copy) NSString *url;
//eddystone_uid
@property (nonatomic, copy) NSString *nameSpace;
@property (nonatomic, copy) NSString *instance;
@property (nonatomic, copy) NSString *reserved;
//altBeacon
@property (nonatomic, copy) NSString *id1;
@property (nonatomic, assign) int id2;
@property (nonatomic, assign) int id3;
@property (nonatomic, copy) NSString *manufacturerId;
@property (nonatomic, copy) NSString *manufacturerReserved;
//beacon tx power
@property (nonatomic, assign) int power;
//peripheral can be connected or not
@property (nonatomic, assign) BOOL connectable;
//broadcast enabled or not
@property (nonatomic, assign) BOOL enable;

@end
