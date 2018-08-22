//
//  ViewController.swift
//  E-pressureRemote
//
//  Created by Francisco Barrios Romo on 27-10-17.
//  Copyright © 2017 RentalApps. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    var idUsuario = ""
    var ref: DatabaseReference!
    var handle:DatabaseHandle?
    @IBOutlet var heighValueBottom: NSLayoutConstraint!
    @IBOutlet var heightValue: NSLayoutConstraint!
    @IBOutlet var heightDevice: NSLayoutConstraint!
    @IBOutlet var bloqueIphoneX: UIImageView!
    @IBOutlet var tabTop: UITabBar!
    @IBOutlet var titleTop: UILabel!
    
    @IBOutlet var heightTabTop: NSLayoutConstraint!
    @IBOutlet var heightTitleTop: NSLayoutConstraint!
    @IBOutlet var panelHeight: NSLayoutConstraint!
    @IBOutlet var controlPanelTop: NSLayoutConstraint!
    
    @IBOutlet var pressure: UILabel!
    @IBOutlet var lowAlarma: UILabel!
    @IBOutlet var highAlarm: UILabel!
    
    
    @IBOutlet var pressureRef: UISlider!
    
    @IBAction func pressureRef(_ sender: Any) {
       let valor = String(Int(self.pressureRef.value))
       let valorData = ["pressure": valor]
       self.valuePressureRef.text = valor
       self.ref.updateChildValues(valorData)
    }
    
    
    @IBOutlet var valuePressureRef: UILabel!
    
    @IBAction func upBtn(_ sender: Any) {
        let valor = Int(self.pressureRef.value)
        let newValor = valor + 1
        if newValor < 400 {
            self.pressureRef.value = Float(newValor)
            let valorData = ["pressure": String(newValor)]
            self.ref.updateChildValues(valorData)
        }
        
    }
    
    @IBAction func downBtn(_ sender: Any) {
        let valor = Int(self.pressureRef.value)
        let newValor = valor - 1
        if newValor > -400 {
            self.pressureRef.value = Float(newValor)
            let valorData = ["pressure": String(newValor)]
            self.ref.updateChildValues(valorData)
        }
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = "users/" + idUsuario
        ref = Database.database().reference().child(path)
        
        handle = ref.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as?  NSDictionary
           
            print("data",value)
            let auxPressure = value?["pressure"] as? String ?? ""
            let auxAlarmHigh = value?["alarmHigh"] as? String ?? ""
            let auxAlarmLow = value?["alarmLow"] as? String ?? ""
            self.pressure.text = auxPressure
            self.highAlarm.text = auxAlarmHigh
            self.lowAlarma.text = auxAlarmLow
            self.valuePressureRef.text = "VALUE: " + auxPressure + " mmHg"
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.bloqueIphoneX.isHidden = true
        iPhoneScreenSizes()
        print("userid View:", idUsuario)
        
        
        
        
     
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    func convertToDictionary(text: String) -> Any? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Any
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
        
    }
    func iPhoneScreenSizes(){
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        switch height {
        case 480.0:
            print("iPhone 3,4")
            self.heightDevice.constant = 10
            self.panelHeight.constant = 120
           // textField1.font = textField1.font?.withSize(14)
        
        case 568.0:
            print("iPhone 5")
            self.heightDevice.constant = 10
            self.panelHeight.constant = 120
            self.controlPanelTop.constant = 15
            self.heightValue.constant = 8
            self.heighValueBottom.constant = 5
           // textField1.font = textField1.font?.withSize(14)
      
        case 667.0:
            print("iPhone 6")
            self.heightDevice.constant = 20
            self.controlPanelTop.constant = 30
            //textField1.font = textField1.font?.withSize(16)
     
        case 736.0:
            print("iPhone 6+")
            self.heightDevice.constant = 80
            self.controlPanelTop.constant = 30
           // textField1.font = textField1.font?.withSize(18)
   
        case 812.0:
            print("iPhone x")
             self.heightDevice.constant = 60
            self.heightTitleTop.constant = 35
            self.heightTabTop.constant = 80
            self.bloqueIphoneX.isHidden = false
        default:
            print("not an iPhone")
            print("HEIGH", height)
            
        }
        print("hola")
        print("HEIGH", height)
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



