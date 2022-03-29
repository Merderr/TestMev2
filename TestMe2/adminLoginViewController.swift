//
//  adminLoginViewController.swift
//  TestMe2
//
//  Created by admin on 3/21/22.
//

import UIKit

class adminLoginViewController: UIViewController {
    
    //Outlet references for view controller controls
    @IBOutlet weak var tempAdminUsername: UITextField!
    @IBOutlet weak var tempAdminPass: UITextField!
    //Set admin username and pass
    var adminUser = "admin"
    var adminPass = "adminpass"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Check admin username and password and then send to admin home page
    @IBAction func adminLogin(_ sender: Any) {
        if (tempAdminPass.text == adminPass) && (tempAdminUsername.text == adminUser){
            let nextViewController = storyboard?.instantiateViewController(withIdentifier: "adminView") as! adminViewController
            self.present(nextViewController, animated: true, completion: nil)
        } else {
            //Create alert box to notify admin information is incorrect
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
