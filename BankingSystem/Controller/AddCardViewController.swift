//
//  AddCardViewController.swift
//  BankingSystem
//
//  Created by АА on 17.10.24.
//

import UIKit

class AddCardViewController: UIViewController {
    
    
    var textFieldForNumber = UITextField()
    var textFieldForDate = UITextField()
    var textFieldForSecureCode = UITextField()
    var textFieldForCardName = UITextField()
    
    var alertForError = UIAlertController()
    
    var numberForCard = UILabel()
    var dateForCard = UILabel()
    var secureCodeForCard = UILabel()
    var cardNameForCard = UILabel()
    
    var viewCard = UIView()
    
    var addCardButton = UIButton()
    var secureCodeButton = UIButton()
    
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewManager.shared.addGradient(to: self.view, colors: [UIColor(hex: "#6CB1A2")!,UIColor(hex:"#4D70A4")!])
        
        setupAddCardButton()
        
        setupCardView()
        
        setupTextFieldForDate()
        setupTextFieldForNumber()
        setupTextFieldForSecureCode()
        setupTextFieldForCardName()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        
        DispatchQueue.main.async{
            self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: true)
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCardUI), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    deinit {
        self.timer?.invalidate()
    }
    @objc func updateUI(){
        UIView.animate(withDuration: 1.5) {
            if self.textFieldForCardName.backgroundColor == UIColor(hex: "#70709F") && self.textFieldForNumber.backgroundColor == UIColor(hex: "#70709F"){
                self.textFieldForCardName.backgroundColor = UIColor(hex: "#6CB1A2")
                self.textFieldForNumber.backgroundColor = UIColor(hex: "#6CB1A2")
                self.textFieldForDate.backgroundColor = UIColor(hex: "#70709F")
                self.textFieldForSecureCode.backgroundColor = UIColor(hex: "#70709F")
            }
            else{
                self.textFieldForCardName.backgroundColor = UIColor(hex: "#70709F")
                self.textFieldForNumber.backgroundColor = UIColor(hex: "#70709F")
                self.textFieldForDate.backgroundColor = UIColor(hex: "#6CB1A2")
                self.textFieldForSecureCode.backgroundColor = UIColor(hex: "#6CB1A2")
            }
        }
    }
    @objc func updateCardUI(){
        if let textNumber = self.textFieldForNumber.text as String?,let textDate = self.textFieldForDate.text as String?, let textSecureCode = self.textFieldForSecureCode.text as String?, let textCardName = self.textFieldForCardName.text as String?{
            
            if textNumber.isEmpty{
                self.numberForCard.text = "1234 5678 9101 2345"
            }
            else{
                self.numberForCard.text = textNumber
            }
            
            if textDate.isEmpty{
                self.dateForCard.text = "00/00"
            }
            else if self.dateForCard.text?.count == 2{
                var isSymbol = false
                for i in self.textFieldForDate.text!{
                    if i == "/"{
                        isSymbol = true
                        break
                    }
                }
                if !isSymbol{
                    var count = 0
                    for _ in self.textFieldForDate.text!{
                        count+=1
                        if count == 2{
                            self.textFieldForDate.text?.append("/")
                            break
                        }
                    }
                }
                self.dateForCard.text = textDate
            }
            else{
                self.dateForCard.text = textDate
            }
            if textCardName.isEmpty{
                self.cardNameForCard.text = "Name Surname"
            }
            else{
                self.cardNameForCard.text = textCardName
            }
            
            if textSecureCode.isEmpty{
                self.secureCodeForCard.text = "123"
            }
            else{
                self.secureCodeForCard.text = textSecureCode
            }
        }
    }
    func setupTextFieldForNumber(){
        self.textFieldForNumber.keyboardType = .numberPad
        self.textFieldForNumber.placeholder = "1234 5678 9101 2345"
        self.textFieldForNumber.textAlignment = .center
        self.textFieldForNumber.borderStyle = .roundedRect
        self.textFieldForNumber.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldForNumber.backgroundColor = UIColor(hex: "#70709F")
        
        self.view.addSubview(self.textFieldForNumber)
        NSLayoutConstraint.activate([
            self.textFieldForNumber.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldForNumber.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: -190),
            self.textFieldForNumber.widthAnchor.constraint(equalToConstant: 250),
            self.textFieldForNumber.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    func setupTextFieldForDate(){
        self.textFieldForDate.keyboardType = .numberPad
        self.textFieldForDate.placeholder = "MM/YY"
        self.textFieldForDate.textAlignment = .center
        self.textFieldForDate.borderStyle = .roundedRect
        self.textFieldForDate.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldForDate.backgroundColor = UIColor(hex: "#6CB1A2")
        
        self.view.addSubview(self.textFieldForDate)
        NSLayoutConstraint.activate([
            self.textFieldForDate.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldForDate.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: 20),
            self.textFieldForDate.widthAnchor.constraint(equalToConstant: 250),
            self.textFieldForDate.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    func setupTextFieldForSecureCode(){
        self.textFieldForSecureCode.isSecureTextEntry = true
        self.textFieldForSecureCode.keyboardType = .numberPad
        self.textFieldForSecureCode.placeholder = "Secure Code"
        self.textFieldForSecureCode.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldForSecureCode.textAlignment = .center
        self.textFieldForSecureCode.borderStyle = .roundedRect
        self.textFieldForSecureCode.backgroundColor = UIColor(hex: "#6CB1A2")
        
        self.view.addSubview(self.textFieldForSecureCode)
        NSLayoutConstraint.activate([
            self.textFieldForSecureCode.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldForSecureCode.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -120),
            self.textFieldForSecureCode.widthAnchor.constraint(equalToConstant: 250),
            self.textFieldForSecureCode.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    func setupTextFieldForCardName(){
        self.textFieldForCardName.placeholder = "Card Name"
        self.textFieldForCardName.textAlignment = .center
        self.textFieldForCardName.borderStyle = .roundedRect
        self.textFieldForCardName.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldForCardName.backgroundColor = UIColor(hex: "#70709F")
        
        self.view.addSubview(self.textFieldForCardName)
        NSLayoutConstraint.activate([
            self.textFieldForCardName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldForCardName.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: -50),
            self.textFieldForCardName.widthAnchor.constraint(equalToConstant: 250),
            self.textFieldForCardName.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupAddCardButton(){
        self.addCardButton.setTitle("Add Card", for: .normal)
        self.addCardButton.setTitleColor(.white, for: .normal)
        self.addCardButton.translatesAutoresizingMaskIntoConstraints = false
        self.addCardButton.backgroundColor = .systemBlue
        self.addCardButton.addTarget(self, action: #selector(AddCard), for: .touchUpInside)
        
        self.view.addSubview(self.addCardButton)
        NSLayoutConstraint.activate([
            self.addCardButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.addCardButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 110),
            self.addCardButton.widthAnchor.constraint(equalToConstant: 125),
            self.addCardButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func AddCard(){
        Model.shared.AddCard(card: Card(id: nil, number: self.textFieldForNumber.text, username:UserDefaults.standard.string(forKey: "username"), cardname: self.textFieldForCardName.text, cvv: self.textFieldForSecureCode.text, date: self.textFieldForDate.text)) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let isAdd):
                    if isAdd{
                        self.navigationController?.viewControllers = [HomeViewController()]
                    }
                    else{
                        self.createAlertForError(String(isAdd))
                    }
                case .failure(let error):
                    self.createAlertForError(error.localizedDescription)
                }
            }
        }
    }
    
    func setupCardView(){
        self.viewCard.backgroundColor = UIColor(hex: "#66D44E")
        self.viewCard.translatesAutoresizingMaskIntoConstraints = false
        self.viewCard.layer.cornerRadius = 40
        
        self.createCard()
        
        self.view.addSubview(self.viewCard)
        
        NSLayoutConstraint.activate([
            self.viewCard.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.viewCard.centerYAnchor.constraint(equalTo: self.addCardButton.centerYAnchor, constant: 170),
            self.viewCard.widthAnchor.constraint(equalToConstant: 370),
            self.viewCard.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func createCard(){
        self.numberForCard.frame = CGRect(x: self.viewCard.center.x + 10, y: self.viewCard.center.y, width: 200, height: 60)
        self.viewCard.addSubview(self.numberForCard)
        
        self.dateForCard.frame = CGRect(x: self.viewCard.center.x + 10, y: self.viewCard.center.y + 60, width: 60, height: 50)
        self.viewCard.addSubview(self.dateForCard)
        
        self.secureCodeForCard.frame = CGRect(x: self.viewCard.center.x + 10, y: self.viewCard.center.y + 110, width: 60, height: 50)
        self.viewCard.addSubview(self.secureCodeForCard)
        
        self.cardNameForCard.frame = CGRect(x: self.viewCard.center.x + 10, y: self.viewCard.center.y + 160, width: 200, height: 50)
        self.viewCard.addSubview(self.cardNameForCard)
    }
    
    func createAlertForError(_ error:String?){
        alertForError = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default)
        alertForError.addAction(action1)
        
        self.present(self.alertForError, animated: true)
    }
}
