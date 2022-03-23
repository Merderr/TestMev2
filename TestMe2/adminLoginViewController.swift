//
//  adminLoginViewController.swift
//  TestMe2
//
//  Created by admin on 3/21/22.
//

import UIKit

class adminLoginViewController: UIViewController {
    
    
    @IBOutlet weak var tempAdminUsername: UITextField!
    @IBOutlet weak var tempAdminPass: UITextField!
    var adminUser = "admin"
    var adminPass = "adminpass"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func adminLogin(_ sender: Any) {
        if (tempAdminPass.text == adminPass) && (tempAdminUsername.text == adminUser){
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "adminView") as! adminViewController
        self.present(nextViewController, animated: true, completion: nil)
        } else {
            var dialogMessage = UIAlertController(title: "Attention", message: "Invalid credentials, please check and try again.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler:  {
                (action) -> Void in
                print("Ok button tapped")
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
}
