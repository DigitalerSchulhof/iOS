//
//  SecondViewController.swift
//  DigitalerSchulhof
//
//  Created by Patrick Wagner on 02.02.20.
//  Copyright © 2020 Digitaler Schulhof. All rights reserved.
//

import UIKit
import KeychainSwift

let speicher = KeychainSwift()

class VCprofil: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schulen.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(schulen)[row].key
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        schule = Array(schulen)[row].value
    }
    

    @IBOutlet weak var PICSchule: UIPickerView!
    @IBOutlet weak var TXTbenutzer: UITextField!
    @IBOutlet weak var TXTpasswort: UITextField!
    @IBOutlet weak var LBLmeldung: UILabel!
    
    var schule = ""
    var schulen = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        schule = speicher.get("schule") ?? "https://digitaler-schulhof.de"
        let benutzer = speicher.get("benutzer") ?? ""
        let passwort = speicher.get("passwort") ?? ""
        
        TXTbenutzer.text = benutzer
        TXTpasswort.text = passwort
        
        URLSession.shared.dataTask(with: URL(string: "https://digitaler-schulhof.de/dshs.php")!) {(data, response, error) in
            guard let data = data else {return}
            let schulenJ = try! JSONDecoder().decode([[String]].self, from: data)
            schulenJ.forEach() {
                let schule = $0
                self.schulen[schule[0] + " (" + schule[1] + ")"] = schule[2]
            }
            DispatchQueue.main.async {
                self.PICSchule.reloadAllComponents()
                var index = 0
                for i in 0 ... self.schulen.count-1 {
                    if(Array(self.schulen)[i].value == self.schule) {
                        index = i
                        break
                    }
                }
                
                self.PICSchule.selectRow(index, inComponent: 0, animated: true)
            }
        }.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LBLmeldung.text = ""
        TXTpasswort.text = "";
        LBLmeldung.textColor = UIColor.darkText;
    }

    @IBAction func BTNspeichern(_ sender: Any) {
        let benutzer = TXTbenutzer.text!
        let passwort = TXTpasswort.text!
        
        speicher.set(schule,   forKey: "schule")
        speicher.set(benutzer, forKey: "benutzer")
        speicher.set(passwort, forKey: "passwort")
        LBLmeldung.textColor = UIColor.systemGreen;
        LBLmeldung.text = "Die Änderungen wurden gespeichert!"
        TXTpasswort.text = "";
        
        self.view.endEditing(true)
    }
    
    @IBAction func BTNabbrechen(_ sender: Any) {
        self.view.endEditing(true)
        LBLmeldung.text = ""
        TXTpasswort.text = "";
        TXTbenutzer.text = speicher.get("benutzer") ?? ""
        // Gewählte Schule anzeigen
        schule = speicher.get("schule") ?? "https://digitaler-schulhof.de"

        var index = 0
        for i in 0 ... schulen.count-1 {
            if(Array(schulen)[i].value == schule) {
                index = i
                break
            }
        }
        
        PICSchule.selectRow(index, inComponent: 0, animated: true)
        
        LBLmeldung.textColor = UIColor.darkText
    }
}

