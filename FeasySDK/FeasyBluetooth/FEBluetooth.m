//
//  FEBluetooth.m
//  FeasycomWatch
//
//  Created by ericj on 2017/7/22.
//  Copyright © 2017年 LIDONG. All rights reserved.
//

#import "FEBluetooth.h"
#import <CoreBluetooth/CoreBluetooth.h>

@implementation FEBluetooth

CBCentralManager *mCentralManager;

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

@end
