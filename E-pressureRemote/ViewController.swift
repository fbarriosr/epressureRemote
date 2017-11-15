//
//  ViewController.swift
//  E-pressureRemote
//
//  Created by Francisco Barrios Romo on 27-10-17.
//  Copyright © 2017 RentalApps. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.bloqueIphoneX.isHidden = true
        iPhoneScreenSizes()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
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



