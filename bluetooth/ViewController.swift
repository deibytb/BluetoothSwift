//
//  ViewController.swift
//  central
//
//  Created by Deiby Toralva Baldeón on 9/02/16.
//  Copyright © 2016 devAcademy. All rights reserved.
//

import UIKit
import CoreBluetooth

var idString: String = ""

class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate{
    
    var serviceKeyPressesUDID: CBUUID!
    var characteristicKeyPressesUDID: CBUUID!

    var connectedSensorTag: CBPeripheral!
    var centralManager: CBCentralManager!
    
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBAction func scanBtn(sender: AnyObject) {
        self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    @IBAction func comButton(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //serviceKeyPressesUDID = CBUUID(string:"0x180F")
        //characteristicKeyPressesUDID = CBUUID(string: "FFE1")
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("centralManagerDidUpdateState:")
        switch (central.state){
        case .PoweredOff:
            print("CBCentralManagerStatePoweredOff")
        case .Resetting:
            print("CBCentralManagerStateResetting")
        case .PoweredOn:
            print("CBCentralManagerStatePoweredOn")
            //---scan for peripheral devices---
            self.centralManager.scanForPeripheralsWithServices(nil, options:nil)
        case .Unauthorized:
            print("CBCentralManagerStateUnauthorized")
        case .Unsupported:
            print("CBCentralManagerStateUnsupported")
        default:
            print("CBCentralManagerStateUnknown")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("Discovered \(peripheral.name)")
        print("NSUUID string \(peripheral.identifier.UUIDString)")
        let range = (peripheral.name! as NSString).rangeOfString("BC274C3")
        
        if (range.location != NSNotFound) {
            connectedSensorTag = peripheral
            //---stop the scanning---
            self.centralManager.stopScan()
            //---save the peripheral---
            //---connect to the peripheral---
            self.centralManager.connectPeripheral(peripheral, options:nil)
            self.statusLbl.text = "Connected!"
            
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Peripheral connected: \(peripheral.name)")
        peripheral.delegate = self
        /*
        let services = [serviceKeyPressesUDID!]
        peripheral.discoverServices(services)
        print("Servicios")
        for s in services {
            print(s)
        }*/
        
    }
    
    /*func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        for service in peripheral.services! {
            print("P: \(peripheral.name) - Discovered service S:'\(service.UUID)'")
            if service.UUID == serviceKeyPressesUDID {
                //---discover the specified characteristic of the service---
                let characteristics = [characteristicKeyPressesUDID!]
                
                //---discover the characteristics of the service---
                peripheral.discoverCharacteristics(characteristics, forService: service as CBService)
            }
        }
    }*/
    
    /*func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService,
        error: NSError?) {
            for characteristic in service.characteristics! {
                //---look for the characteristic that allows you to subscribe to---
                if characteristic.UUID == characteristicKeyPressesUDID {
                    //---subscribe to the characteristic---
                    peripheral.setNotifyValue(true,
                        forCharacteristic:characteristic as CBCharacteristic)
                }
            }
    }*/
    
    /*func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic
        characteristic: CBCharacteristic, error: NSError?) {
            if (error != nil) {
                print("Error changing notification state: \(error!.localizedDescription)")
            } else {
                print("Characteristic's value subscribed")
            }
    }*/
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        if connectedSensorTag == peripheral {
            self.statusLbl.text = "Disconnected!"
        }
    }
}
