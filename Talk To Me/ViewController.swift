//
//  ViewController.swift
//  Talk To Me
//
//  Created by Justin Edwards on 2017-10-24.
//  Copyright © 2017 Justin Edwards. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

//Version 1.0.0
var defaultSpeechRate: Float = AVSpeechUtteranceDefaultSpeechRate
var defaultSpeechPitch: Float = 1.0
var defaultSpeechLang: Int = 3
var speekLetter: Bool = true

//Version 1.0.1
var defaultColor: Int = 1
var currentBuildVersion: Int = 0

//version 1.0.2
var defaultMuliDelete: Bool = true

let arrOfLang = ["en-AU", "en-GB", "en-IE", "en-US", "en-ZA"]
let arrOfNames = ["Karen", "Daniel", "Moria", "Samantha", "Tessa"]
let arrOfColor = ["Pink", "White", "Blue"]

let colorDarkGraySetting = UIColor(red: 0.36127328110000001, green: 0.36485024420000001, blue: 0.36485024420000001, alpha: 1)
let colorLightPink = UIColor(red: 0.96511512990000003, green: 0.76769977810000001, blue: 0.76998323199999996, alpha: 1)
let colorDarkPink = UIColor(red: 0.93874037269999999, green: 0.68106192350000005, blue:0.68267405029999995, alpha: 1)
let colorLightGray = UIColor(red: 0.85480856895446777, green: 0.85495573282241821, blue: 0.85479927062988281, alpha: 1)
let colorDarkBlue = UIColor(red: 0.37248749899936873, green: 0.58042447728129687, blue: 0.85495573280000003, alpha: 1)
let colorLightBlue = UIColor(red: 0.71187124390742407, green: 0.87413166145081211, blue: 1, alpha: 1)

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet var myButtons: [UIButton]!
    @IBOutlet var myLables: [UILabel]!
    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet var txtText: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var switchSayLetter: UISwitch!
    @IBOutlet weak var sliderPitch: UISlider!
    @IBOutlet weak var sliderRate: UISlider!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewColor: UIPickerView!
    @IBOutlet weak var switchMuliDelete: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setting up deletgates
        btnDelete.addTarget(self, action: #selector(multipleTap(_:event:)), for: UIControlEvents.touchDownRepeat)
        txtText.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        pickerViewColor.delegate = self
        pickerViewColor.dataSource = self
        pickerViewColor.showsSelectionIndicator = true
        
        sliderRate.minimumValue = 0.3
        sliderRate.maximumValue = 0.55
        sliderPitch.minimumValue = 0.50
        sliderPitch.maximumValue = 2.0
        
        // Do Version Check and set defaults up
        versionCheck()
        
        // Get defaults
        speekLetter = UserDefaults.standard.value(forKey: "speekLetter") as! Bool
        defaultSpeechPitch = UserDefaults.standard.value(forKey: "defaultSpeechPitch") as! Float
        defaultSpeechRate = UserDefaults.standard.value(forKey: "defaultSpeechRate") as! Float
        defaultSpeechLang = UserDefaults.standard.value(forKey: "defaultSpeechLang") as! Int
        defaultColor = UserDefaults.standard.value(forKey: "defaultColor") as! Int
        defaultMuliDelete = UserDefaults.standard.value(forKey: "defaultMuliDelete") as! Bool
        
        //Setting up the defauts within the UI:
        if(speekLetter) {
            switchSayLetter.isOn = true
        } else {
            switchSayLetter.isOn = false
        }
        sliderPitch.value = defaultSpeechPitch
        sliderRate.value = defaultSpeechRate
        pickerView.selectRow(defaultSpeechLang, inComponent: 0, animated: true)
        pickerViewColor.selectRow(defaultColor, inComponent: 0, animated: true)
        if(defaultMuliDelete) {
            switchMuliDelete.isOn = true
        } else {
            switchMuliDelete.isOn = false
        }
        
        //Set the colors
        doColor()
        
    }
    
    @IBAction func btnPressed(button: UIButton) {
        let txt = (txtText.text ?? "")
        let newTxt = (button.titleLabel?.text ?? "")
        if(newTxt.count > 1)
        {
            txtText.text = txt + " "
        }
        else
        {
            txtText.text = txt + newTxt
            if(speekLetter && newTxt != ".")
            {
                tts(text: newTxt)
            }
        }
    }
    
    @IBAction func btnDelete(button: UIButton){
        let txt = txtText.text ?? ""
        if(txt.count > 0)
        {
            txtText.text = String(txt.dropLast(1))
        }
    }
    
    @IBAction func btnSettings(_ sender: Any) {
        settingsView.isHidden = false
    }
    
    @IBAction func btnDefaults(_ sender: Any) {
        defaultSpeechRate = AVSpeechUtteranceDefaultSpeechRate
        defaultSpeechPitch = 1.0
        defaultSpeechLang = 3
        defaultColor = 1
        speekLetter = true
        defaultMuliDelete = true
        
        UserDefaults.standard.set(speekLetter, forKey: "speekLetter")
        UserDefaults.standard.set(defaultSpeechRate, forKey: "defaultSpeechRate")
        UserDefaults.standard.set(defaultSpeechPitch, forKey: "defaultSpeechPitch")
        UserDefaults.standard.set(defaultSpeechLang, forKey: "defaultSpeechLang")
        UserDefaults.standard.set(defaultColor, forKey: "defaultColor")
        UserDefaults.standard.set(defaultMuliDelete, forKey: "defaultMuliDelete")
        
        
        settingsView.isHidden = true
        
        switchSayLetter.isOn = true
        sliderPitch.value = defaultSpeechPitch
        sliderRate.value = defaultSpeechRate
        pickerView.selectRow(defaultSpeechLang, inComponent: 0, animated: true)
        pickerViewColor.selectRow(defaultColor, inComponent: 0, animated: true)
        switchMuliDelete.isOn = true
        
        doColor()
    }
    
    @IBAction func btnSaveSettings(_ sender: Any) {
        settingsView.isHidden = true
    }
    
    @IBAction func switchSayLetterChanged(_ sender: Any) {
        if(switchSayLetter.isOn) {
            speekLetter = true
        } else {
            speekLetter = false
        }
        UserDefaults.standard.set(speekLetter, forKey: "speekLetter")
    }
    
    @IBAction func switchMuliDeleteChanged(_ sender: Any) {
        if(switchMuliDelete.isOn) {
            defaultMuliDelete = true
        } else {
            defaultMuliDelete = false
        }
        UserDefaults.standard.set(defaultMuliDelete, forKey: "defaultMuliDelete")
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        defaultSpeechRate = sliderRate.value
        defaultSpeechPitch = sliderPitch.value
        UserDefaults.standard.set(defaultSpeechRate, forKey: "defaultSpeechRate")
        UserDefaults.standard.set(defaultSpeechPitch, forKey: "defaultSpeechPitch")
    }
    
    @IBAction func txtTouch(_ sender: Any) {
        if((txtText.text ?? "").count > 0 && txtText.text ?? "" != ".")
        {
            print("Say stuff!")
            tts(text: (txtText.text ?? ""))
        }
    }
    
    // Delete everything if they tap the delete key 4 times
    @objc func multipleTap(_ sender: UIButton, event: UIEvent) {
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount > 3 && defaultMuliDelete == true) {
            txtText.text = ""
        }
    }
    
    
    //DONT SHOW the keyboard when they touch the text field.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    func tts(text: String){
        let utterance = AVSpeechUtterance(string: text.lowercased())
        utterance.voice = AVSpeechSynthesisVoice(language: arrOfLang[defaultSpeechLang])
        utterance.rate = defaultSpeechRate
        utterance.pitchMultiplier = defaultSpeechPitch
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    //Picker view functions:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pv: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pv == pickerViewColor)
        {
            return arrOfColor.count
        }
        return arrOfLang.count
    }
    
    func pickerView(_ pv: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pv == pickerViewColor)
        {
            return arrOfColor[row]
        }
        return arrOfNames[row]
    }
    
    func pickerView(_ pv: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if(pv == pickerViewColor)
        {
            return NSAttributedString(string: arrOfColor[row], attributes: [NSAttributedStringKey.foregroundColor: colorDarkGraySetting])
        }
        return NSAttributedString(string: arrOfNames[row], attributes: [NSAttributedStringKey.foregroundColor: colorDarkGraySetting])
    }
    
    func pickerView(_ pv: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pv == pickerViewColor)
        {
            defaultColor = row
            UserDefaults.standard.set(defaultColor, forKey: "defaultColor")
            doColor()
        }
        else
        {
            defaultSpeechLang = row
            UserDefaults.standard.set(defaultSpeechLang, forKey: "defaultSpeechLang")
        }
    }
    
    //custom funtions
    func doColor(){
        switch defaultColor {
        case 0: //default pink
            self.view.backgroundColor = colorLightPink
        case 1: //white
            self.view.backgroundColor = UIColor.white
        case 2:
            self.view.backgroundColor = colorLightBlue
        default:
            self.view.backgroundColor = colorLightPink
        }
        
        for button in self.myButtons {
            switch defaultColor {
            case 0: //default pink
                button.backgroundColor = colorDarkPink
                button.setTitleColor(colorDarkGraySetting, for: .normal)
            case 1: //white
                button.backgroundColor = colorLightGray
                button.setTitleColor(colorDarkGraySetting, for: .normal)
            case 2:
                button.backgroundColor = colorDarkBlue
                button.setTitleColor(colorLightGray, for: .normal)
            default:
                button.backgroundColor = colorDarkPink
                button.setTitleColor(colorDarkGraySetting, for: .normal)
            }
        }
        
        for lbl in self.myLables {
            switch defaultColor {
            case 0: //default pink
                lbl.textColor = colorDarkGraySetting
            case 1: //white
                lbl.textColor = colorDarkGraySetting
            case 2:
                lbl.textColor = colorDarkGraySetting
            default:
                lbl.textColor = colorDarkGraySetting
            }
        }
        
        for case let view as UIView in self.view.subviews {
                switch defaultColor {
                case 0: //default pink
                    view.backgroundColor = colorLightPink
                case 1: //white
                    view.backgroundColor = UIColor.white
                case 2:
                    view.backgroundColor = colorLightBlue
                default:
                    view.backgroundColor = colorLightPink
            }
        }
    }
    
    func versionCheck(){
//speekLetter was created in version 1.0.0
        let result = UserDefaults.standard.value(forKey: "speekLetter")
        if (result != nil)
        {
            //We know they are min version 1.
            currentBuildVersion = 1
            //currentBuildVersion was created in version 1.0.1
            let buildVersion = UserDefaults.standard.value(forKey: "currentBuildVersion")
            if (buildVersion != nil)
            {
                currentBuildVersion = buildVersion as! Int
            }
        }
        
//Set the Default Values if needed!
        switch currentBuildVersion {
        case 0:
//New App Install.  Set all the defaults
            currentBuildVersion = 3
            UserDefaults.standard.set(speekLetter, forKey: "speekLetter")
            UserDefaults.standard.set(defaultSpeechRate, forKey: "defaultSpeechRate")
            UserDefaults.standard.set(defaultSpeechPitch, forKey: "defaultSpeechPitch")
            UserDefaults.standard.set(defaultSpeechLang, forKey: "defaultSpeechLang")
            UserDefaults.standard.set(defaultColor, forKey: "defaultColor")
            UserDefaults.standard.set(currentBuildVersion, forKey: "currentBuildVersion")
            UserDefaults.standard.set(defaultMuliDelete, forKey: "defaultMuliDelete")
        case 1:
// First time upgrade from version 1.0.0.  Add defaults for Version 1.0.1 - Build 2
            currentBuildVersion = 2
            UserDefaults.standard.set(defaultColor, forKey: "defaultColor")
            UserDefaults.standard.set(currentBuildVersion, forKey: "currentBuildVersion")
        case 2:
            currentBuildVersion = 3
            //defaultMuliDelete default = true
            UserDefaults.standard.set(defaultMuliDelete, forKey: "defaultMuliDelete")
            UserDefaults.standard.set(currentBuildVersion, forKey: "currentBuildVersion")
        //case 3:
        default:
            //No upgrade required.
            break;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

