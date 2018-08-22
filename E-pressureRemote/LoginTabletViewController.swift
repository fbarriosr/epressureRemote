//
//  LoginTabletViewController.swift
//  E-pressureRemote
//
//  Created by Francisco Barrios Romo on 22-11-17.
//  Copyright © 2017 RentalApps. All rights reserved.
//

import UIKit
import Firebase
import FCAlertView

class LoginTabletViewController: UIViewController, UITextFieldDelegate {
    var alert = FCAlertView()
    var flagLogin = true
    let blackColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
    let whiteColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)

    var idUsuario = ""
    
    @IBOutlet var btnNext: UIButton!
    
    @IBOutlet var btnRegistrar: UIButton!
    
    @IBAction func btnRegistrar(_ sender: Any) {
        if flagLogin {
            flagLogin = false
            self.btnClick.setTitle("REGISTRAR", for: .normal)
            self.btnLogin.backgroundColor = whiteColor
            self.btnLogin.setTitleColor(blackColor, for: .normal)
            self.btnRegistrar.backgroundColor = blackColor
            self.btnRegistrar.setTitleColor(whiteColor, for: .normal)
            
        }else {
            flagLogin = true
            
        }
    }
    @IBOutlet var btnLogin: UIButton!
    @IBAction func btnLogin(_ sender: Any) {
        
        if flagLogin {
            flagLogin = false
            
        }else {
            flagLogin = true
            self.btnClick.setTitle("INGRESAR", for: .normal)
            self.btnLogin.backgroundColor = blackColor
            self.btnLogin.setTitleColor(whiteColor, for: .normal)
            self.btnRegistrar.backgroundColor = whiteColor
            self.btnRegistrar.setTitleColor(blackColor, for: .normal)
        }
    }
    
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var btnClick: UIButton!
    
    @IBAction func btnClick(_ sender: Any) {
        guard let password = self.password.text , let email = self.email.text else {
            print("form is not valid")
            return
        }
        print("email: ",email)
        print("password",password)
        
        if !flagLogin {
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error != nil{
                    print("No se registro el usuario")
                    self.error(inputData: "No se puede crear el Usuario, La Clave debe ser de 6 digitos ")
                    print(error as Any)
                    let alert = UIAlertController(title: "Do something", message: "With this", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "A thing", style: .default) { action in
                        // perhaps use action.title here
                    })
                    return
                }
                guard let uid = user?.uid else {
                    return
                    
                }
                self.idUsuario = (user?.uid)!
                self.btnNext.isHidden = false
                self.btnNext.sendActions(for: .touchUpInside)
                
                let ref: DatabaseReference!
                
                ref = Database.database().reference()
                
                let userReference = ref.child("users").child(uid)
                
                let values = ["email": email, "pressure": "123", "alarmHigh" :"200", "alarmLow": "100", "soundAlarm": "false" ] as [String : Any]
                userReference.updateChildValues(values, withCompletionBlock: { (err,ref)  in
                    if err != nil {
                        print("No se grabo el usuario")
                        print(err as Any)
                        return
                    }
                    print("saved")
                    self.idUsuario = (user?.uid)!
                })
                
                
            }
        }else {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil{
                    print("Login Error Usuario no Existe")
                    print(error as Any)
                    self.error(inputData: "El Usuario No Existe. Registrese")
                    
                    
                    return
                }else{
                    print("login succedd")
                    print("user: ",(user?.uid)! )
                    self.btnNext.isHidden = false
                    self.idUsuario = (user?.uid)!
                    self.btnNext.sendActions(for: .touchUpInside)
                    
                }
                
              
            }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flagLogin = true
        password.delegate = self
        email.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        flagLogin = true
        self.btnNext.isHidden = true
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
        if textField == password {
            if (password.text?.count)! < 6 {
                self.error(inputData: "La clave debe ser mayor a 6 digitos")
            }
        }
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
    
    func caution(inputData: String){
        alert = FCAlertView()
        alert.showAlert(inView: self,
                        withTitle: "Caution",
                        withSubtitle: inputData,
                        withCustomImage: nil,
                        withDoneButtonTitle: nil,
                        andButtons: nil)
        alert.makeAlertTypeCaution()
        alert.dismissOnOutsideTouch = true
        
    }
    
    func error(inputData: String){
        alert = FCAlertView()
        alert.showAlert(inView: self,
                        withTitle: "Caution",
                        withSubtitle: inputData,
                        withCustomImage: nil,
                        withDoneButtonTitle: nil,
                        andButtons: nil)
        alert.makeAlertTypeWarning()
        alert.dismissOnOutsideTouch = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     if segue.identifier == "next"{
            let  nextScene = segue.destination as? LocalViewController
            nextScene?.idUsuario = self.idUsuario
        }
    }
    
    
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



