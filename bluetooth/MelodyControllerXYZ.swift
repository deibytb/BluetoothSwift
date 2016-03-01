//
//  MelodyController.swift
//  bluetooth
//
//  Created by Deiby Toralva Baldeón on 29/02/16.
//  Copyright © 2016 devAcademy. All rights reserved.
//

import UIKit

class MelodyController: UIViewController {
    var melodySmart: MelodySmart!
}

class MelodyControllerXYZ: UIViewController, MelodySmartDelegate, UITextFieldDelegate {
    var melodySmart: MelodySmart!
    
    @IBOutlet weak var textSend: UITextField!
    @IBOutlet weak var responseText: UITextField!
    
    @IBAction func sendButton(sender: AnyObject) {
    }
    
    //private var i2cController: I2cCommandsViewController?
    //private weak var commandsController: RemoteCommandsViewController?
    //private weak var otauController: OtauViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = melodySmart.name()
        self.melodySmart.delegate = self
        
        melodySmart.connect()
    }
    
    deinit {
        melodySmart.disconnect()
    }
    
    // MARK: - MelodySmart delegate
    
    func melodySmart(melody: MelodySmart!, didConnectToMelody result: Bool) {
    }
    
    func melodySmartDidDisconnectFromMelody(melody: MelodySmart!) {
    }
    
    func melodySmart(melody: MelodySmart!, didSendData error: NSError!) {
        let command = "comm"
        let data = command.dataUsingEncoding(NSUTF8StringEncoding)
        melody.sendData(data)
    }
    
    func melodySmart(melody: MelodySmart!, didReceiveData data: NSData!) {
        responseText.text = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
    }
    
    func melodySmart(melody: MelodySmart!, didReceivePioChange state: UInt8, withLocation location: BcSmartPioLocation) {
    }
    
    func melodySmart(melody: MelodySmart!, didReceivePioSettingChange state: UInt8, withLocation location: BcSmartPioLocation) {
    }
    
    /*func melodySmart(melody: MelodySmart!, didReceiveI2cReplyWithSuccess success: Bool, data: NSData!) {
        i2cController?.didReceiveI2CReplyWithSuccess(success, data: data)
    }*/
    
    func melodySmart(melody: MelodySmart!, didReceiveCommandReply reply: NSData!) {
        print(reply)
        //responseText.text = reply
    }
    
    func melodySmart(melody: MelodySmart!, didDetectBootMode bootMode: BootMode) {
        print(bootMode)
        //otauController?.didDetectBootMode(bootMode)
    }
    /*
    func melodySmart(melody: MelodySmart!, didUpdateOtauState state: OtauState, withProgress percent: Int32) {
        otauController?.didUpdateOtauState(state, percent: Int(percent))
    }*/
    
    // MARK: - UITextField delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !melodySmart.sendData(textField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)) {
            print("Send error")
        }
        
        textField.resignFirstResponder()
        
        return true
    }

}
