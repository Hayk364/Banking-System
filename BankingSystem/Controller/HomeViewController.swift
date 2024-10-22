//
//  HomeViewController.swift
//  BankingSystem
//
//  Created by АА on 17.10.24.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = UserDefaults.standard.string(forKey: "username")
        UserDefaults.standard.set("HomeViewController", forKey: "lastControllerName")
        print(UserDefaults.standard.string(forKey: "username")!)
    }
}
