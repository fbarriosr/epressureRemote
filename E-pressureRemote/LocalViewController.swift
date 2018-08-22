//
//  LocalViewController.swift
//  E-pressureRemote
//
//  Created by Francisco Barrios Romo on 28-10-17.
//  Copyright © 2017 RentalApps. All rights reserved.
//

import UIKit
import Firebase
import MultiStepSlider
import AVFoundation
    
class LocalViewController: UIViewController {
    var idUsuario = ""
    var ref: DatabaseReference!
    var handle:DatabaseHandle?
    var bombSoundEffect: AVAudioPlayer?
    var alarmStatus = true
    
    let colorBlack = UIColor(red:0.62, green:0.62, blue:0.62, alpha:1.0)
    let colorGreen = UIColor(red:0.46, green:1.00, blue:0.01, alpha:1.0)
    
    @IBOutlet var alarmColor: UIImageView!

    @IBOutlet var pressure: UILabel!
    
    @IBOutlet var alarmLow: UILabel!
    @IBOutlet var alarmHigh: UILabel!
    @IBOutlet weak var slider: MultiStepRangeSlider!
    
    
    @IBAction func logOut(_ sender: Any) {
          self.dismiss(animated: true, completion: {})
    }
    
    @IBAction func slider(_ sender: Any) {
        //print("continuous: lower = \(slider.continuousCurrentValue.lower) higher = \(slider.continuousCurrentValue.upper)")
        
        let low = String(Int(slider.continuousCurrentValue.lower))
        let high = String(Int(slider.continuousCurrentValue.upper))
        
        let valorData = ["alarmHigh":high, "alarmLow": low]
        print("valorData:", valorData)
        
        self.ref.updateChildValues(valorData)
   }
    
    @IBAction func alarmButton(_ sender: Any) {
        if alarmStatus {
            alarmColor.backgroundColor = colorBlack
            alarmStatus = false
            if (self.bombSoundEffect?.isPlaying)!{
                self.bombSoundEffect?.stop()
            }
        }else {
            alarmStatus = true
            alarmColor.backgroundColor = colorGreen
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = "users/" + self.idUsuario
        ref = Database.database().reference().child(path)
 
        print("path", path)
        
       
        
        handle = ref.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as?  NSDictionary
            
            print("data",value)
            let auxPressure = value?["pressure"] as? String ?? ""
            let auxAlarmHigh = value?["alarmHigh"] as? String ?? ""
            let auxAlarmLow = value?["alarmLow"] as? String ?? ""
            
            self.pressure.text = auxPressure
            self.alarmHigh.text = auxAlarmHigh
            self.alarmLow.text = auxAlarmLow
            
            let aux2Pressure = (auxPressure as NSString).floatValue
            let aux2AlarmHigh = (auxAlarmHigh as NSString).floatValue
            let aux2AlarmLow = (auxAlarmLow as NSString).floatValue
            
            if (aux2Pressure > aux2AlarmHigh || aux2Pressure < aux2AlarmLow && self.alarmStatus ){
                self.bombSoundEffect?.play()
            }else {
                if ((self.bombSoundEffect?.isPlaying)! && self.alarmStatus ){
                     self.bombSoundEffect?.stop()
                }
            }
        })
        
        
        let intervals = [Interval(min: -400.00, max: 400.00, stepValue: 1)]
        let preSelectedRange = RangeValue(lower: -200, upper: 200)
        slider.configureSlider(intervals: intervals, preSelectedRange: preSelectedRange)
        print("continuous: lower = \(slider.continuousCurrentValue.lower) higher = \(slider.continuousCurrentValue.lower)")
    
        
        let audioPath = Bundle.main.path(forResource: "beep.mp3", ofType:nil)!
        let audioUrl = URL(fileURLWithPath: audioPath)
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: audioUrl)
        } catch {
            // couldn't load file :(
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("userid:", idUsuario)
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
