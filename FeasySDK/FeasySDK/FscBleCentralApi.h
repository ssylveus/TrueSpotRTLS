//
//  FscBleCentralApi.h
//  FscBleCentral
//
//  Created by Feasycom on 2017/12/26.
//  Copyright © 2017 Feasycom. All rights reserved.
//

typedef enum {
    BLEMODULE = 0,  //beacon type
    BEACONMODULE    //ble type
} MODULETYPE;

typedef enum {
    BROADCAST = 0,  //beacon broadcast
    CONFIGURATION   //configuration type
} SEARCH_TYPE;

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class FWPeripheralWrapper;
@class BeaconBean;

@interface FscBleCentralApi : NSObject
/**
 *  Module type
 */
@property (nonatomic, assign) MODULETYPE moduleType;
/**
 *  Search type
 */
@property (nonatomic, assign) SEARCH_TYPE searchType;
/**
 *  Last connected peripheral
 */
@property (nonatomic, strong) CBPeripheral *peripheral;
/**
 *  Beacon info
 */
@property (nonatomic, strong) NSArray *beaconInfoArray;

//-----------------------------------  callbacks  -------------------------------------//
/**
 * peripheral enabled callback
 */
- (void)isBtEnabled:(void (^)(CBCentralManager *central))block;
/**
 * peripheral found callback
 */
- (void)blePeripheralFound:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI, FWPeripheralWrapper *peripheralWrapper))block;
/**
 * peripheral connected callback
 */
- (void)blePeripheralConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;
/**
 *  discover services
 */
- (void)servicesFound:(void (^)(NSArray <CBService *>*services,NSError *error))block;
/**
 *  peripheral disconnected callback
 */
- (void)blePeripheralDisonnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;
/**
 * write value with response callback
 */
- (void)sendCompleted:(void (^)(CBCharacteristic *characteristic,NSData *data,NSError *error))block;
/**
 * received packet callback
 */
- (void)packetReceived:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;
/**
 * response for characteristic value read
 */
- (void)readResponse:(void (^)(CBCharacteristic * characteristic))block;
/**
 * response for send AT commands
 */
- (void)fscAtResponse:(void (^)(NSString *type,int status))block;
/**
 * update progress callbacks
 */
- (void)otaProgressUpdate:(void (^)(CGFloat percentage,int status))block;
/**
 * device info callbacks
 */
- (void)deviceInfo:(void (^)(NSArray *infoArray))block;


/**
 * single_one
 */
+ (instancetype)shareFscBleCentralApi;
/**
 * single_two
 */
+ (instancetype)defaultFscBleCentralApi;
/**
 * start scan peripherals
 */
- (void)startScan;
/**
 * stop scan peripherals
 */
- (void)stopScan;
/**
 * connect peripheral(BLE)
 */
- (void)connect:(CBPeripheral *)peripheral;
/**
 * disconnect peripheral
 */
- (void)disconnect;
/**
 * send data to peripheral, response is flow control
 */
- (void)send:(NSData *)data withResponse:(BOOL)response withSendStatusBlock:(void (^)(NSData *data))block;
/**
 * send data to peripheral, response is flow control(sync)
 */
- (void)syncSend:(NSData *)data withResponse:(BOOL)response;
/**
 * stop send data to peripheral and reset sending status
 */
- (void)stopSend;
/**
 * set characteristic
 */
- (void)setCharacteristic:(NSString *)serviceUUID withCharacteristicUUID:(NSString *)characteristicUUID withNotify:(BOOL)notify infoBlock:(void (^)(BOOL result))block;
/**
 * read characteristic value
 */
- (void)read:(CBCharacteristic *)characteristic;
/**
 * set send interval(ms)
 */
- (void)setSendInterval:(NSInteger)interval;
/**
 * clear buffer cache
 */
- (void)clearCache;
/**
 * set mtu
 */
- (void)setAttMtu:(NSInteger)mtu;
/**
 * send AT commands
 */
- (void)sendFscAtCommands:(NSArray *)commandArray;
/**
 * load file and check file information
 */
- (NSDictionary *)checkDfuFile:(NSString *)dfuFileName;
/**
 * upgrade and restore default settings
 */
- (void)startOTA:(NSString *)dfuFileName withRestoreDefaultSettings:(BOOL)restore;

//----------------------------------  beacon  ------------------------------------------//
/**
 * get device info, also see "deviceInfo:"
 */
- (void)startGetDeviceInfo;
/**
 * connect peripheral(beacon)
 */
- (void)connect:(FWPeripheralWrapper *)peripheralWrapper withPin:(NSString *)pin;
/**
 * set device name
 */
- (void)setDeviceName:(NSString *)deviceName;
/**
 * set feasyBeacon pin
 */
- (void)setFscPin:(NSString *)pin;
/**
 * set broadcast interval
 */
- (void)setBroadcastInterval:(NSString *)interval;
/**
 * set tx power
 */
- (void)setTxPower:(NSString *)txPower;
/**
 * set buzzer
 */
- (void)setBuzzer:(NSString *)interval withTime:(NSString *)time;
/**
 * set gsonser
 */
- (void)setGsonser:(NSString *)interval withTime:(NSString *)time;
/**
 * set key
 */
- (void)setKey:(NSString *)interval withTime:(NSString *)time;
/**
 * set connectable or not
 */
- (void)setConnectable:(BOOL)connectable;
/**
 * query broadcast reaching the upper limit
 */
- (BOOL)isBeaconInfoFull;
/**
 * add beacon broadcast
 */
- (void)addBeaconInfo:(BeaconBean *)beaconBean;
/**
 * delete beacon broadcast of index
 */
- (void)deleteBeaconInfo:(uint32_t)index;
/**
 * update beacon info of index
 */
- (void)updateBeaconInfo:(BeaconBean *)beaconBean withIndex:(uint32_t)index withPosition:(uint32_t)position;
/**
 * get beacon info of index
 */
- (BeaconBean *)getBeaconInfo:(uint32_t)index;
/**
 * save beacon info
 */
- (void)saveBeaconInfo;



@end

