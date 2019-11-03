//
//  FirstViewController.swift
//  IroIroIro
//
//  Created by 岩男高史 on 2019/11/03.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var flg: Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        flg = UserDefaults.standard.integer(forKey: "flg")
        if flg == nil {
            UserDefaults.standard.set(1, forKey: "flg")
        } else if flg == 1 {
            performSegue(withIdentifier: "go", sender: nil)
        }
    }
}
