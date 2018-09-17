//
//  ViewController.swift
//  Flashlight
//
//  Created by Filip  Gonera on 20/07/2018.
//  Copyright © 2018 Filip  Gonera. All rights reserved.
//

import UIKit
import AVFoundation


class MainViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet var untranslatedTextView: UITextView!
    @IBOutlet var morseTextView: UITextView!
    @IBOutlet var flashlightBtn: UIButton!
    @IBOutlet var flashlightBtnWidth: NSLayoutConstraint!
    
    let dictionary = Dictionary()
    
    let greenColor = UIColor(red: 138/255, green: 238/255, blue: 94/255, alpha: 1.0)
    
    var timer1 = Timer()
    var timer2 = Timer()
    
    weak var timer: Timer?
    
    var finalText = ""
    var finalMorseText = ""
    
    let progressRing = CAShapeLayer()
    
    
    
    func translate() {  
        let string: String = untranslatedTextView.text!.lowercased()  // this'll make sure to make text match keys in the dict which are all lowercased
        let characters = Array(string)
        print("characters from untranslatedTextView: \(characters)")
        
        for i in characters {
            if dictionary.dict["\(i)"] == nil{ // if user inserted character not present in the dict this'll show error
                print("key not found")
                let alert = UIAlertController(title: "Unsupported letter", message: "Your text contains unsupported letter", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else { // else this'll add dashes and dots from dict values to arrayOfTranslatedCharacters
                let item: [Character] = dictionary.dict["\(i)"]!
                dictionary.arrayOfTranslatedCharacters += item
            }
        }
        print("translated to\(dictionary.arrayOfTranslatedCharacters)")
    }
    
    func setupMorseFlashesSequence(){
        let dot: Character = "•"
        let dash: Character = "—"
        let slash: Character = "/"
        
        for i in dictionary.arrayOfTranslatedCharacters {
            switch i {
            case dot:
                dictionary.sequenceOfFlashes.append(dictionary.shortFlash)
                dictionary.sequenceOfFlashes.append(dictionary.pause)
            case dash:
                dictionary.sequenceOfFlashes.append(dictionary.longFlash)
                dictionary.sequenceOfFlashes.append(dictionary.pause)
            case slash:
                dictionary.sequenceOfFlashes.append(dictionary.emptyFlash)
                dictionary.sequenceOfFlashes.append(dictionary.longPause)
            default:
                return
            }
        }
        print(dictionary.sequenceOfFlashes)
    }
    
    func scheduleTimer(){
        timer = Timer.scheduledTimer(timeInterval: dictionary.sequenceOfFlashes[dictionary.index], target: self, selector: #selector(timerTick), userInfo: nil, repeats: false)
    }
    
    @objc func timerTick(){ // this func iterates through time intervals and turn on flashlight to proper time on every even number
        dictionary.index += 1
        if dictionary.index < dictionary.sequenceOfFlashes.count {
        turnFlashlight(on: dictionary.index % 2 == 0)
        scheduleTimer()
        }
        if dictionary.index == dictionary.sequenceOfFlashes.count - 1 { // when it ends running through index it turns off flashlight, changes state of the button and remove all time intervals from array to prepare it for new translated text, and so new time intervals
            stop()
            setFlashlightBtnToStart()
            flashlightBtn.isSelected = false
            dictionary.sequenceOfFlashes.removeAll()
        }
    }
    
    func start(){
        dictionary.index = 0
        turnFlashlight(on: true)
        scheduleTimer()
    }
    
    func stop(){
        timer?.invalidate()
        turnFlashlight(on: false)
        }
    
    deinit{
        timer?.invalidate()
    }
    
    
    @IBAction func flashlightBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let selected = sender.isSelected
        
        if selected{
            translate()
            setupMorseFlashesSequence()
            animateProgressRingForward()
            start()
            setFlashlightBtnToStop()
        } else {
            stop()
            dictionary.sequenceOfFlashes.removeAll()
            setFlashlightBtnToStart()
            animateProgressRingBackward()
        }
    }
    
    func setFlashlightBtnToStart(){
        flashlightBtn.setTitle("Start", for: .normal)
        flashlightBtnWidth.constant = 200
        UIView.animate(withDuration: 0.08, animations: {
            self.view.layoutIfNeeded()
        })
        flashlightBtn.backgroundColor = greenColor
        UIView.transition(with: self.flashlightBtn, duration: 0.1, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    func setFlashlightBtnToStop(){
        flashlightBtn.setTitle("Stop", for: .normal)
        self.flashlightBtnWidth.constant = 70
        UIView.animate(withDuration: 0.08, animations: {
            self.view.layoutIfNeeded()
        })
        flashlightBtn.backgroundColor = UIColor.red
        UIView.transition(with: self.flashlightBtn, duration: 0.1, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    func setupProgressRing() {
        //let flashlightBtnCenter = flashlightBtn.center
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: view.center.x, y: flashlightBtn.center.y - 100), radius: 25, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi/2, clockwise: true)
        progressRing.path = circularPath.cgPath
        progressRing.strokeColor = UIColor.blue.cgColor
        progressRing.lineWidth = 2
        progressRing.fillColor = UIColor.clear.cgColor
        progressRing.lineCap = kCALineCapRound
        progressRing.strokeEnd = 0
        view.layer.addSublayer(progressRing)
    }
    
    
    func animateProgressRingForward(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        let progressRingAnimationTime = dictionary.sequenceOfFlashes.reduce(0, +) - dictionary.pause
        print(progressRingAnimationTime)
        
        basicAnimation.toValue = 1
        basicAnimation.duration = progressRingAnimationTime
        basicAnimation.fillMode = kCAFillModeForwards
        
        progressRing.add(basicAnimation, forKey: "ringAnim")
        
    }
    
    func animateProgressRingBackward(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = 0.1

        progressRing.add(basicAnimation, forKey: "ringAnim")
    }
    
    
    override func viewDidLoad() {
        untranslatedTextView.layer.borderWidth = 1
        untranslatedTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        morseTextView.layer.borderWidth = 1
        morseTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        untranslatedTextView.text = finalText
        morseTextView.text = finalMorseText
        
        flashlightBtn.setTitle("Start", for: .normal)
        flashlightBtn.layer.cornerRadius = 0.18 * flashlightBtn.bounds.size.width
        flashlightBtn.clipsToBounds = true
        flashlightBtn.backgroundColor = greenColor
        untranslatedTextView.delegate = self
        
        setupProgressRing()
    }
    

    func turnFlashlight(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                    print("ON")
                } else {
                    device.torchMode = .off
                    print("OFF")
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        dictionary.arrayOfTranslatedCharacters.removeAll() // here i make sure that i keep only existing text in arrayOfTranslatedCharacters and not previous texts entered by user
        print("translated characters: \(dictionary.arrayOfTranslatedCharacters)..")
    }
    

    func textViewDidEndEditing(_ textView: UITextView) { // here i translate and update morseTextView to the newest text entered by user while editing, if user did not changed anything in text i took care of this in textViewDidBeginEditing
        translate()
        finalMorseText = dictionary.arrayOfTranslatedCharacters.map(String.init).joined(separator: " ")
        morseTextView.text = finalMorseText
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool { // here i set up when user will tap "done" on keyboard, keyboard will close
        if(text == "\n"){
            untranslatedTextView.resignFirstResponder()
            return false
        }
        return true
        
    }
    

}

