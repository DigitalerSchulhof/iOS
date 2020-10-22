//
//  FirstViewController.swift
//  DigitalerSchulhof
//
//  Created by Patrick Wagner on 02.02.20.
//  Copyright © 2020 Digitaler Schulhof. All rights reserved.
//

import UIKit
import WebKit

class VCwebsite: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var browser: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var schule = speicher.get("schule") ?? "";
        if (schule == "") {schule = "https://www.digitaler-schulhof.de"}
        let adresse = URL(string: schule)!
        let anfrage = URLRequest(url: adresse)
        browser.load(anfrage)
        
        browser.scrollView.bounces = true
        let neuladen = UIRefreshControl()
        neuladen.addTarget(self, action: #selector(VCwebsite.aktualisieren), for: UIControl.Event.valueChanged)
        browser.scrollView.addSubview(neuladen)
    }
    
    @objc func aktualisieren(sender: UIRefreshControl) {
        browser.reload()
        sender.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var schule = speicher.get("schule") ?? "";
        if (schule == "") {schule = "https://www.digitaler-schulhof.de"}
        let adresse = URL(string: schule)!
        let anfrage = URLRequest(url: adresse)
        browser.load(anfrage)
    }
}



