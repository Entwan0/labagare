//
//  ViewController.swift
//  labagare
//
//  Created by volozana on 30/03/2022.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        CallController().loadJson { actualities in
            //imageView.image = actualite[0]
        }
    }

    @IBAction func goMap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewController(identifier: "MapViewController")
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }

    @IBAction func goContact() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let callController = storyboard.instantiateViewController(identifier: "CallController")
        self.navigationController?.pushViewController(callController, animated: true)
    }
    
    //MARK: -- Send Message
    @IBAction func sendMessage() {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "test message";
        messageVC.recipients = ["+33781195278"]
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: true, completion: nil)
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
        case .failed:
            print("Message failed")
        case .sent:
            print("Message was sent")
        default:
            return
        }
        dismiss(animated: true, completion: nil)
    }
}

