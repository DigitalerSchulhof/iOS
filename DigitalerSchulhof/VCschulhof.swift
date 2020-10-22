//
//  FirstViewController.swift
//  DigitalerSchulhof
//
//  Created by Patrick Wagner on 02.02.20.
//  Copyright © 2020 Digitaler Schulhof. All rights reserved.
//

import UIKit
import WebKit

class VCschulhof: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var browser: WKWebView!
    
    var schule = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        browser.navigationDelegate = self
        
        var schule = speicher.get("schule") ?? "";
        if (schule == "") {schule = "https://www.digitaler-schulhof.de"}
        schule += "/App"
        let adresse = URL(string: schule)!
        let anfrage = URLRequest(url: adresse)
        browser.load(anfrage)
        
        browser.scrollView.bounces = true
        let neuladen = UIRefreshControl()
        neuladen.addTarget(self, action: #selector(VCschulhof.aktualisieren), for: UIControl.Event.valueChanged)
        browser.scrollView.addSubview(neuladen)
        
    }
    
    @objc func aktualisieren(sender: UIRefreshControl) { 
        browser.reload()
        sender.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        schule = speicher.get("schule") ?? "";
        if (schule == "") {schule = "https://www.digitaler-schulhof.de"}
        schule += "/App"
        let adresse = URL(string: schule)!
        let anfrage = URLRequest(url: adresse)
        browser.load(anfrage)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("typeof CMS_BENUTZERNAME") {
            (ergebnis, fehler) in
            if (ergebnis != nil) {
                let angemeldet: String = ergebnis as! String
                if (angemeldet == "undefined") {
                    let benutzer = speicher.get("benutzer") ?? "";
                    let passwort = speicher.get("passwort") ?? "";
                    if(webView.url?.absoluteString.starts(with: self.schule) == true) {
                        webView.evaluateJavaScript("cms_appanmeldung('"+benutzer+"', '"+passwort+"');", completionHandler: nil)
                     } else {
                        webView.evaluateJavaScript("cms_anmeldung('"+benutzer+"', '"+passwort+"');", completionHandler: nil)
                    }
                }
            }
        }
        
        
    }
}



