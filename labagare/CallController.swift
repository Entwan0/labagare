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
        // Do any additional setup after loading the view.
        
    }
    func loadJson(completion: @escaping ([Actuality]?) -> Void) {
        if let url = Bundle.main.url(forResource: "actualite", withExtension:"json"){
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Actualities.self, from: data)
                completion(jsonData.actualite)
            }
            catch {
                print("error")
            }
        }
    }
}
