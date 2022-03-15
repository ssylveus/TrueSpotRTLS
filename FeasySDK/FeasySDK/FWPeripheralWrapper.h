//
//  Created by Feasycom on 2017/11/6.
//  Copyright (c) 2017 Feasycom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBPeripheral;

@interface FWPeripheralWrapper : NSObject
/**
 *  Record peripheral
 */
@property (nonatomic, strong) CBPeripheral *mPeripheral;
/**
 *  AdvertisementData
 */
@property (nonatomic, strong) NSDictionary *mRawAdvertisementData;
/**
 *  Module model
 */
@property (nonatomic, copy) NSString *model;
/**
 *  Module version
 */
@property (nonatomic, copy) NSString *version;
/**
 *  Broadcast interval
 */
@property (nonatomic, copy) NSString *interval;
/**
 *  have pin or not
 */
@property (nonatomic, assign) BOOL hasPin;
/**
 *  Connectable state
 */
@property (nonatomic, copy) NSString *connectable;
/**
 *  peripheral name
 */
@property (nonatomic, copy) NSString *name;
/**
 *  peripheral rssi
 */
@property (nonatomic, assign) NSInteger rssi;
/**
 *  Peripheral mac address
 */
@property (nonatomic, copy) NSString *mac;
/**
 *  ibeacon RSSI
 */
@property (nonatomic, copy) NSString *iBeaconRssi;
/**
 *  ibeacon uuid
 */
@property (nonatomic, copy) NSString *iBeaconUuid;
/**
 *  ibeacon major
 */
@property (nonatomic, copy) NSString *iBeaconMajor;
/**
 *  ibeacon minor
 */
@property (nonatomic, copy) NSString *iBeaconMinor;
/**
 *  ibeacon power
 */
@property (nonatomic, copy) NSString *iBeaconPower;
/**
 *  ibeacon broadcast status
 */
@property (nonatomic, assign) BOOL iBeaconEnable;
/**
 *  url address
 */
@property (nonatomic, copy) NSString *eddystoneUrl;
/**
 *  url name
 */
@property (nonatomic, copy) NSString *eddystoneUrlName;
/**
 *  url rssi
 */
@property (nonatomic, copy) NSString *eddystoneUrlRssi;
/**
 *  url of the peripheral mac address
 */
@property (nonatomic, copy) NSString *eddystoneUrlMac;
/**
 *  url power
 */
@property (nonatomic, copy) NSString *eddystoneUrlPower;
/**
 *  url broadcast status
 */
@property (nonatomic, assign) BOOL eddystoneUrlEnable;
/**
 *  uid rssi
 */
@property (nonatomic, copy) NSString *eddystoneUidRssi;
/**
 *  uid of the peripheral mac address
 */
@property (nonatomic, copy) NSString *eddystoneUidMac;
/**
 *  uid name
 */
@property (nonatomic, copy) NSString *eddystoneUidName;
/**
 *  uid namespace
 */
@property (nonatomic, copy) NSString *eddystoneUidNamespaceStr;
/**
 *  uid instance
 */
@property (nonatomic, copy) NSString *eddystoneUidInstance;
/**
 *  uid reserved
 */
@property (nonatomic, copy) NSString *eddystoneUidReserved;
/**
 *  uid power
 */
@property (nonatomic, copy) NSString *eddystoneUidPower;
/**
 *  uid broadcast status
 */
@property (nonatomic, assign) BOOL eddystoneUidEnable;
/**
 *  altbeacon of the peripheral mac address
 */
@property (nonatomic, copy) NSString *altBeaconMacString;
/**
 *  altbeacon manufacturer ID
 */
@property (nonatomic, copy) NSString *altBeaconMfgString;
/**
 *  altbeacon ID, It consists of a 16-byte uuid + 2-byte major + 2-byte minor
 */
@property (nonatomic, copy) NSString *altBeaconIdString;
/**
 *  altbeacon power
 */
@property (nonatomic, copy) NSString *altBeaconPowerString;
/**
 *  altbeacon rssi
 */
@property (nonatomic, copy) NSString *altBeaconRssiString;
/**
 *  altbeacon manufacturer reserved
 */
@property (nonatomic, copy) NSString *altBeaconReservedString;

@property (nonatomic, copy) NSString *urlTypeString;
@property (nonatomic, copy) NSString *uidTypeString;
@property (nonatomic, copy) NSString *altBeaconTypeString;

@property (nonatomic, copy) NSString *data_urlString;
@property (nonatomic, copy) NSString *data_uidString;
@property (nonatomic, copy) NSString *data_altBeaconString;

@property (nonatomic, assign) NSInteger electricity;

@property (nonatomic, strong) NSMutableArray *RSSIs;

/////////////////////////////////////////////////////////////////////////
- (id)initWithPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI advertisementData:(NSDictionary *)advertisementData;

- (id)initWithPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI advertisementData:(NSDictionary *)advertisementData type:(NSString *)type dataString:(NSString *)dataString;

- (id)initWithIBeaconUUID:(NSString *)UUID major:(NSNumber *)major minor:(NSNumber *)minor RSSI:(NSInteger)RSSI;

- (NSString *)name;

- (bool) isEddystoneDevice;

- (bool) isIBeaconDevice;

- (bool) isAltBeaconDevice;


@end

