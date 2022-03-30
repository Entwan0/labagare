//
//  ViewController.swift
//  labagare
//
//  Created by volozana on 30/03/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func goMap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewController(identifier: "MapViewController")
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }

}

