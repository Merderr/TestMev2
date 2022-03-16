//
//  adminViewController.swift
//  TestMe2
//
//  Created by admin on 3/16/22.
//

import UIKit

class adminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func userScoreView(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "userScore") as! userScoreViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
}
