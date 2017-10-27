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

var defaultSpeechRate = AVSpeechUtteranceDefaultSpeechRate
var defaultSpeechPitch: Float = 1.0
var defaultSpeechLang = 3
var speekLetter = true
let arrOfLang = ["en-AU", "en-GB", "en-IE", "en-US", "en-ZA"]
let arrOfNames = ["Karen", "Daniel", "moria", "Samantha", "Tessa"]
let colorDarkGraySetting = UIColor(red: 0.36127328110000001, green: 0.36485024420000001, blue: 0.36485024420000001, alpha: 1.0)

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    

    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet var txtText: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var switchSayLetter: UISwitch!
    @IBOutlet weak var sliderPitch: UISlider!
    @IBOutlet weak var sliderRate: UISlider!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setting up deletgates
        btnDelete.addTarget(self, action: #selector(multipleTap(_:event:)), for: UIControlEvents.touchDownRepeat)
        txtText.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        sliderRate.minimumValue = 0.3
        sliderRate.maximumValue = 0.55
        sliderPitch.minimumValue = 0.50
        sliderPitch.maximumValue = 2.0
        
        //Check for user Defaults
        let result = UserDefaults.standard.value(forKey: "speekLetter")
        if (result == nil)
        {
            UserDefaults.standard.set(speekLetter, forKey: "speekLetter")
            UserDefaults.standard.set(defaultSpeechRate, forKey: "defaultSpeechRate")
            UserDefaults.standard.set(defaultSpeechPitch, forKey: "defaultSpeechPitch")
            UserDefaults.standard.set(defaultSpeechLang, forKey: "defaultSpeechLang")
            //speekLetter = result
        }
        else
        {
            speekLetter = UserDefaults.standard.value(forKey: "speekLetter") as! Bool
            defaultSpeechPitch = UserDefaults.standard.value(forKey: "defaultSpeechPitch") as! Float
            defaultSpeechRate = UserDefaults.standard.value(forKey: "defaultSpeechRate") as! Float
            defaultSpeechLang = UserDefaults.standard.value(forKey: "defaultSpeechLang") as! Int
        }
        
        //Setting up the defauts:
        if(speekLetter)
        {
            switchSayLetter.isOn = true
        }
        else
        {
            switchSayLetter.isOn = false
        }
        
        sliderPitch.value = defaultSpeechPitch
        sliderRate.value = defaultSpeechRate
        
        pickerView.selectRow(defaultSpeechLang, inComponent: 0, animated: true)
        
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
            if(speekLetter)
            {
                tts(text: newTxt)
            }
        }
    }
    
    @IBAction func btnDelete(button: UIButton){
        let txt = txtText.text ?? ""
        if(txt.count > 0)
        {
            //txtText.text = txt.substring(to: txt.index(before: txt.endIndex))
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
        speekLetter = true
        
        UserDefaults.standard.set(speekLetter, forKey: "speekLetter")
        UserDefaults.standard.set(defaultSpeechRate, forKey: "defaultSpeechRate")
        UserDefaults.standard.set(defaultSpeechPitch, forKey: "defaultSpeechPitch")
        UserDefaults.standard.set(defaultSpeechLang, forKey: "defaultSpeechLang")
        
        settingsView.isHidden = true
        
        switchSayLetter.isOn = true
        sliderPitch.value = defaultSpeechPitch
        sliderRate.value = defaultSpeechRate
        pickerView.selectRow(defaultSpeechLang, inComponent: 0, animated: true)
        
    }
    
    @IBAction func btnSaveSettings(_ sender: Any) {
        settingsView.isHidden = true
    }
    
    @IBAction func switchSayLetterChanged(_ sender: Any) {
        if(switchSayLetter.isOn)
        {
            speekLetter = true
        }
        else
        {
            speekLetter = false
            
        }
        UserDefaults.standard.set(speekLetter, forKey: "speekLetter")
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        defaultSpeechRate = sliderRate.value
        defaultSpeechPitch = sliderPitch.value
        
        UserDefaults.standard.set(defaultSpeechRate, forKey: "defaultSpeechRate")
        UserDefaults.standard.set(defaultSpeechPitch, forKey: "defaultSpeechPitch")
        
    }
    
    @IBAction func txtTouch(_ sender: Any) {
        if((txtText.text ?? "").count > 0)
        {
            print("Say stuff!")
            tts(text: (txtText.text ?? ""))
        }
    }
    
    // Delete everything if they tap the delete key 4 times
    @objc func multipleTap(_ sender: UIButton, event: UIEvent) {
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount == 4) {
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
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrOfLang.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrOfNames[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: arrOfNames[row], attributes: [NSAttributedStringKey.foregroundColor:colorDarkGraySetting])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaultSpeechLang = row
        UserDefaults.standard.set(defaultSpeechLang, forKey: "defaultSpeechLang")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

