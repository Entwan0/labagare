//
//  CallController.swift
//  labagare
//
//  Created by rafalimn on 04/04/2022.
//

import Foundation
import UIKit

class CallController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.returnKeyType = .done
        number.returnKeyType = .done
        // Do any additional setup after loading the view.
        
    }
    
    @IBOutlet var name: UITextField!
    @IBOutlet var number: UITextField!
    @IBOutlet  var button:UIButton!
    @IBOutlet var result : UILabel!
    
    @IBAction func save(){
        result.text=name.text
    }
    
}
