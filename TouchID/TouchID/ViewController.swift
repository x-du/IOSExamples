//
//  ViewController.swift
//  TouchID
//
//  Created by Du, Xiaochen (Harry) on 4/11/18.
//  Copyright © 2018 Du, Xiaochen (Harry). All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
    @IBAction func authTouchWithPasscode(_ sender: Any) {
        let context = LAContext()
        //context.localizedFallbackTitle = "Use Passcode"
        
        
        let reason = "Use your fingerprint to access this badge"
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { [weak self] (success, error) in
                
                DispatchQueue.main.async {
                    
                    if success {
                        self?.showAlert("Success")
                    } else {
                        //TODO: User did not authenticate successfully, look at error and take appropriate action
                        guard let error = error else {
                            return
                        }
                        
                        self?.showAlert((self?.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))!)
                        
                        //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                        
                    }
                }
            })
            
        } else {
            
            guard let error = error else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            self.showAlert(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    
    @IBAction func auth(_ sender: Any) {
        
        let context = LAContext()
        context.localizedFallbackTitle = ""
        
        let reason = "Use your fingerprint to access this badge"
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { [weak self] (success, error) in
                
                DispatchQueue.main.async {
                    
                    if success {
                        self?.showAlert("Success")
                    } else {
                        //TODO: User did not authenticate successfully, look at error and take appropriate action
                        guard let error = error else {
                            return
                        }
                        
                        self?.showAlert((self?.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))!)
                        
                        //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                        
                    }
                }
            })
            
        } else {
            
            guard let error = error else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            self.showAlert(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func showAlert(_ msg: String) {
        
        // create the alert
        let alert = UIAlertController(title: "TouchID", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    

    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Unknown"
        }
        
        return message
    }
}

