//
//  InitialViewController.swift
//  Flashlight
//
//  Created by Filip  Gonera on 20/07/2018.
//  Copyright © 2018 Filip  Gonera. All rights reserved.
//



import UIKit

class FirstViewController: UIViewController {
    
    let dictionary = Dictionary()
    
    @IBOutlet var translateBtn: UIButton!
    
    var textFromFirstVC: String? = ""
    var morseText: String? = ""
    
    @IBAction func translateBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Insert text", message: "Insert text you want to translate", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            let alertTextField = alert?.textFields![0]
            self.textFromFirstVC = alertTextField?.text
            
            let string: String = alertTextField!.text!.lowercased() // this'll make sure to make text match keys in the dict which are all lowercased characters
            let characters = Array(string)
            print(characters)
            
            for i in characters {
                if self.dictionary.dict["\(i)"] == nil{ 
                    let alert = UIAlertController(title: "Unsupported letter", message: "Your text contains unsupported letter", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print("key not found")
                } else {
                    let item: [Character] = self.dictionary.dict["\(i)"]!
                    self.dictionary.arrayOfTranslatedCharacters += item
                }
            }
            self.morseText = self.dictionary.arrayOfTranslatedCharacters.map(String.init).joined(separator: " ") // this prepares morse code to be displayed in MainViewController with spaces beetween dashes and dots
            print(self.dictionary.arrayOfTranslatedCharacters)
            
            self.performSegue(withIdentifier: "segueToMainVC", sender: self)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil ))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MainViewController
        vc.finalText = textFromFirstVC!
        vc.finalMorseText = morseText!
    }
    
    func configurationTextField(textField: UITextField!){
    }
    
    func doneBtnTapped(action: UIAlertAction){
        performSegue(withIdentifier: "segueToMainVC", sender: self)
    }
    
    func configureTranslateBtn() {
        translateBtn.layer.cornerRadius = 0.15 * translateBtn.bounds.size.width
        translateBtn.clipsToBounds = true
        translateBtn.applyGradient(colors: [UIColor(red: 112.0/255.0, green: 235.0/255.0, blue: 155.0/255.0, alpha: 1.0).cgColor, UIColor(red: 86.0/255.0, green: 200.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTranslateBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


