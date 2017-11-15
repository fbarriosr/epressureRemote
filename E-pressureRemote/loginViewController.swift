//
//  loginViewController.swift
//  E-pressureRemote
//
//  Created by Francisco Barrios Romo on 28-10-17.
//  Copyright © 2017 RentalApps. All rights reserved.
//

import UIKit
import Firebase


class loginViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var email: UITextField!
    
    @IBAction func btnLogin(_ sender: Any) {
        guard let password = self.password.text , let email = self.email.text else {
            print("form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print(error)
                return
            }
           
            guard let uid = user?.uid else {
                return
                
            }
            
            
            let ref: DatabaseReference!
            
            ref = Database.database().reference()
            
            let userReference = ref.child("users").child(uid)
            
            let values = ["email": email, "p1": 123, "p2" :"32"] as [String : Any]
            userReference.updateChildValues(values, withCompletionBlock: { (err,ref)  in
                if err != nil {
                    print(err)
                    return
                }
                    print("saved")
                
            })
                
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        password.delegate = self
        email.delegate = self
        
     

        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        print("touch")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let aux = OffsetKeyboard()
        ViewUpanimateMoving(up: true, upValue: aux)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let aux = OffsetKeyboard()
        ViewUpanimateMoving(up: false, upValue: aux)
     /*   if textField == textField1 {
            if checkInput1() {
                print("Data OK")
                data["WEIGHT"] = textField1.text!
                textField1.text! += " (Kg)"
            }else {
                print("Data BAD")
                textField1.text = "WEIGHT (Kg)"
            }
        }else if textField == textField2 {
            if checkInput2() {
                print("Data OK")
                data["HEIGHT"] = textField2.text!
                textField2.text! += " (cm)"
            }else {
                print("Data BAD")
                textField2.text = "HEIGHT (cm)"
            }
        }else if textField == textField3 {
            if checkInput3() {
                print("Data OK")
                data["FLOW"] = textField3.text!
                textField3.text! += " (ml*Kg/min)"
            }else {
                print("Data BAD")
                textField3.text = "FLOW (ml*Kg/min)"
            }
        }
        */
        
    }
    func ViewUpanimateMoving (up:Bool, upValue :CGFloat){
        let durationMovement:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -upValue : upValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(durationMovement)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func OffsetKeyboard()->CGFloat{
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        switch height {
        case 480.0:
            print("iPhone 3,4")
            return 110
        case 568.0:
            print("iPhone 5")
            return 130
        case 667.0:
            print("iPhone 6")
            return 110
        case 736.0:
            print("iPhone 6+")
            return 110
        default:
            print("not an iPhone")
            return 100
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /* lineas para bloquear la rotacion*/

    override open var shouldAutorotate: Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
}
/*
@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }

}
 
 
 */


