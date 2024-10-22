//
//  HomeViewController.swift
//  BankingSystem
//
//  Created by АА on 17.10.24.
//

import UIKit

class HomeViewController: UIViewController {
    
    var numberForCard = UILabel()
    var dateForCard = UILabel()
    var secureCodeForCard = UILabel()
    var cardNameForCard = UILabel()
    var usernameForCard = UILabel()
    var balance = UILabel()
    
    var logoutButton = UIButton()
    
    var viewCard = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewManager.shared.addGradient(to: self.view, colors: [UIColor(hex: "#6CB1A2")!,UIColor(hex:"#4D70A4")!])
        UserDefaults.standard.set("HomeViewController", forKey: "lastControllerName")
        
        setupCardView()
        setupLogoutButton()
    }
    
    func setupCardView(){
        self.viewCard.backgroundColor = UIColor(hex: "#66D44E")
        self.viewCard.translatesAutoresizingMaskIntoConstraints = false
        self.viewCard.layer.cornerRadius = 40
        
        self.createCard()
        
        self.view.addSubview(self.viewCard)
        
        NSLayoutConstraint.activate([
            self.viewCard.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.viewCard.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -250),
            self.viewCard.widthAnchor.constraint(equalToConstant: 370),
            self.viewCard.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    func createCard(){
        var bal:Float?
        Model.shared.GetCard(username: UserDefaults.standard.string(forKey: "username")!) { card in
            DispatchQueue.main.async {
                switch card {
                case .success(let userCard):
                    self.numberForCard.text = userCard.number
                    self.cardNameForCard.text = userCard.cardname
                    self.secureCodeForCard.text = userCard.cvv
                    self.dateForCard.text = userCard.date
                    self.balance.text = "Balance: \(userCard.balance!)"
                    bal = userCard.balance!
                    print(bal!)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        self.usernameForCard.text = "Name: \(UserDefaults.standard.string(forKey: "username")!)"
        self.usernameForCard.frame = CGRect(x: self.viewCard.center.x + 200, y: self.viewCard.center.y + 60, width: 160, height: 50)
        self.viewCard.addSubview(self.usernameForCard)
        
        self.balance.frame = CGRect(x: self.viewCard.center.x + 200, y: self.viewCard.center.y + 110, width: 200, height: 50)
        self.viewCard.addSubview(self.balance)
        
        self.numberForCard.frame = CGRect(x: self.viewCard.center.x + 10, y: self.viewCard.center.y, width: 200, height: 60)
        self.viewCard.addSubview(self.numberForCard)
        
        self.dateForCard.frame = CGRect(x: self.viewCard.center.x + 10, y: self.viewCard.center.y + 60, width: 60, height: 50)
        self.viewCard.addSubview(self.dateForCard)
        
        self.secureCodeForCard.frame = CGRect(x: self.viewCard.center.x + 10, y: self.viewCard.center.y + 110, width: 60, height: 50)
        self.viewCard.addSubview(self.secureCodeForCard)
        
        self.cardNameForCard.frame = CGRect(x: self.viewCard.center.x + 10, y: self.viewCard.center.y + 160, width: 200, height: 50)
        self.viewCard.addSubview(self.cardNameForCard)
    }
    
    func setupLogoutButton(){
        self.logoutButton.setTitle("LogOut", for: .normal)
        self.logoutButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        self.logoutButton.backgroundColor = .red
        self.logoutButton.center = self.view.center
        self.logoutButton.addTarget(self, action: #selector(LogOut), for: .touchUpInside)
        self.view.addSubview(self.logoutButton)
    }
    @objc func LogOut(){
        self.navigationController?.viewControllers = [ViewController()]
    }
}
