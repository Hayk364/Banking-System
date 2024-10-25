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
    var addBalanceButton = UIButton()
    var sendMoneyButton = UIButton()
    
    var alertForAddBalance = UIAlertController()
    var alertFortSendMoney = UIAlertController()
    
    var activity = UIActivityIndicatorView(style: .large)
    
    var viewCard = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewManager.shared.addGradient(to: self.view, colors: [UIColor(hex: "#6CB1A2")!,UIColor(hex:"#4D70A4")!])
        UserDefaults.standard.set("HomeViewController", forKey: "lastControllerName")
        
        setupAddBalanceButton()
        setupSendMoneyButton()
        setupCardView()
        setupLogoutButton()
    }
    func updateBalance(){
        Model.shared.getBalance(username: UserDefaults.standard.string(forKey: "username")) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let balance):
                    self.balance.text = "Balance: \(balance)"
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    func setupActivity(complition:@escaping (UIActivityIndicatorView) -> Void){
        self.activity.color = .white
        self.activity.center = self.view.center
        self.view.addSubview(self.activity)
        complition(self.activity)
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
        self.setupActivity { activity in
            activity.startAnimating()
            print("Start")
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
            activity.stopAnimating()
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
        self.logoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.logoutButton.backgroundColor = .red
        self.logoutButton.addTarget(self, action: #selector(LogOut), for: .touchUpInside)
        self.logoutButton.layer.cornerRadius = 20
        self.view.addSubview(self.logoutButton)
        NSLayoutConstraint.activate([
            self.logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.logoutButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.logoutButton.widthAnchor.constraint(equalToConstant: 100),
            self.logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func LogOut(){
        self.navigationController?.viewControllers = [ViewController()]
    }
    func setupAddBalanceButton(){
        self.addBalanceButton.setTitle("Add Balance", for: .normal)
        self.addBalanceButton.backgroundColor = .blue
        self.addBalanceButton.translatesAutoresizingMaskIntoConstraints = false
        self.addBalanceButton.addTarget(self, action: #selector(AddBalance), for: .touchUpInside)
        self.addBalanceButton.layer.cornerRadius = 20
        self.view.addSubview(self.addBalanceButton)
        NSLayoutConstraint.activate([
            self.addBalanceButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.addBalanceButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: 70),
            self.addBalanceButton.widthAnchor.constraint(equalToConstant: 200),
            self.addBalanceButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func AddBalance(){
        DispatchQueue.main.async{
            var amount:String?
            self.alertForAddBalance = UIAlertController(title: "Add Balance", message: "How Much Money?", preferredStyle: .alert)
            self.alertForAddBalance.addTextField { (textField) in
                textField.placeholder = "Enter Amount"
                textField.keyboardType = .numberPad
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let actionAdd = UIAlertAction(title: "Add",style: .default) { _ in
                if let textField = self.alertForAddBalance.textFields?.first{
                    amount = textField.text
                }
                Model.shared.AddBalance(amount: Double(amount!), username: UserDefaults.standard.string(forKey: "username")) {
                    result in
                    DispatchQueue.main.async{
                        switch result{
                        case .success(let balance):
                            print("Balance Upadate: \(balance)")
                            self.updateBalance()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            self.alertForAddBalance.addAction(actionAdd)
            self.alertForAddBalance.addAction(actionCancel)
            
            self.present(self.alertForAddBalance, animated: true)
        }
    }
    func setupSendMoneyButton(){
        self.sendMoneyButton.setTitle("Send Money", for: .normal)
        self.sendMoneyButton.backgroundColor = .blue
        self.sendMoneyButton.translatesAutoresizingMaskIntoConstraints = false
        self.sendMoneyButton.addTarget(self, action: #selector(SendMoney), for: .touchUpInside)
        self.sendMoneyButton.layer.cornerRadius = 20
        self.view.addSubview(self.sendMoneyButton)
        NSLayoutConstraint.activate([
            self.sendMoneyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.sendMoneyButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: 140),
            self.sendMoneyButton.widthAnchor.constraint(equalToConstant: 200),
            self.sendMoneyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func SendMoney(){
        print("Send")
    }
}
