//
//  SignUpViewController.swift
//  BankingSystem
//
//  Created by АА on 13.10.24.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var textFieldName = UITextField()
    var textFieldPassword = UITextField()
    var textFieldForNumber = UITextField()
    
    var alertForError: UIAlertController?
     
    var signUpButton = UIButton()
    var hidePasswordButton = UIButton()
    
    var xView = UIImageView()
    var facebookView = UIImageView()
    var instagramView = UIImageView()
    
    var label = UILabel()
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign Up"
        
        ViewManager.shared.addGradient(to: self.view, colors: [UIColor(hex: "#6CB1A2")!,UIColor(hex:"#4D70A4")!])
        
        setupTextFieldForName()
        setupTextFieldForPassword()
        setupTextFieldForNumber()
        
        setupSignUpButton()
        setupHidePassword()
        
        setupSocialNetworkViews()
        setupMainLabel()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        DispatchQueue.main.async{
            self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: true)
            
        }
        
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    func setupSocialNetworkViews(){
        self.xView.clipsToBounds = true
        self.xView.layer.cornerRadius = 25
        self.xView.image = UIImage(named: "x")
        self.xView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.xView)
        NSLayoutConstraint.activate([
            self.xView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.xView.centerYAnchor.constraint(equalTo: self.signUpButton.centerYAnchor,constant: 150),
            self.xView.widthAnchor.constraint(equalToConstant: 50),
            self.xView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.facebookView.clipsToBounds = true
        self.facebookView.layer.cornerRadius = 25
        self.facebookView.image = UIImage(named: "facebook")
        self.facebookView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.facebookView)
        NSLayoutConstraint.activate([
            self.facebookView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: -70),
            self.facebookView.centerYAnchor.constraint(equalTo: self.signUpButton.centerYAnchor,constant: 150),
            self.facebookView.widthAnchor.constraint(equalToConstant: 50),
            self.facebookView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.instagramView.clipsToBounds = true
        self.instagramView.layer.cornerRadius = 25
        self.instagramView.image = UIImage(named: "instagram")
        self.instagramView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.instagramView)
        NSLayoutConstraint.activate([
            self.instagramView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 70),
            self.instagramView.centerYAnchor.constraint(equalTo: self.signUpButton.centerYAnchor,constant: 150),
            self.instagramView.widthAnchor.constraint(equalToConstant: 50),
            self.instagramView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    func setupMainLabel(){
        self.label.text = "Reality"
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.textAlignment = .center
        self.label.textColor = UIColor(hex: "#774DA4")
        self.label.font = UIFont.systemFont(ofSize: 42,weight: .black)
        
        self.view.addSubview(self.label)
        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.textFieldForNumber.centerYAnchor, constant: -100),
            self.label.widthAnchor.constraint(equalToConstant: 200),
            self.label.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    @objc func updateUI(){
        UIView.animate(withDuration: 1.5) {
            if self.textFieldName.backgroundColor == UIColor(hex: "#70709F") && self.textFieldPassword.backgroundColor == UIColor(hex: "#6CB1A2") && self.textFieldForNumber.backgroundColor == UIColor(hex: "#6CB1A2"){
                self.textFieldName.backgroundColor = UIColor(hex: "#6CB1A2")
                self.textFieldPassword.backgroundColor = UIColor(hex: "#70709F")
                self.textFieldForNumber.backgroundColor = UIColor(hex: "#70709F")
            }
            else{
                self.textFieldName.backgroundColor = UIColor(hex: "#70709F")
                self.textFieldPassword.backgroundColor = UIColor(hex: "#6CB1A2")
                self.textFieldForNumber.backgroundColor = UIColor(hex: "#6CB1A2")
            }
        }
    }
    
    func setupTextFieldForName(){
        self.textFieldName.placeholder = "Name"
        self.textFieldName.textAlignment = .center
        self.textFieldName.borderStyle = .roundedRect
        self.textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldName.backgroundColor = UIColor(hex: "#70709F")
        
        self.view.addSubview(self.textFieldName)
        NSLayoutConstraint.activate([
            self.textFieldName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldName.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: -50),
            self.textFieldName.widthAnchor.constraint(equalToConstant: 250),
            self.textFieldName.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    func setupTextFieldForPassword(){
        self.textFieldPassword.placeholder = "Password"
        self.textFieldPassword.textAlignment = .center
        self.textFieldPassword.borderStyle = .roundedRect
        self.textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldPassword.isSecureTextEntry = true
        self.textFieldPassword.backgroundColor = UIColor(hex: "#6CB1A2")
        
        self.view.addSubview(self.textFieldPassword)
        NSLayoutConstraint.activate([
            self.textFieldPassword.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldPassword.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: 20),
            self.textFieldPassword.widthAnchor.constraint(equalToConstant: 250),
            self.textFieldPassword.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    func setupTextFieldForNumber(){
        self.textFieldForNumber.textContentType = .telephoneNumber
        self.textFieldForNumber.keyboardType = .numberPad
        self.textFieldForNumber.text = "+374 "
        self.textFieldForNumber.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldForNumber.borderStyle = .roundedRect
        self.textFieldForNumber.backgroundColor = UIColor(hex: "#6CB1A2")
        
        self.view.addSubview(self.textFieldForNumber)
        NSLayoutConstraint.activate([
            self.textFieldForNumber.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldForNumber.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -120),
            self.textFieldForNumber.widthAnchor.constraint(equalToConstant: 250),
            self.textFieldForNumber.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupSignUpButton(){
        self.signUpButton.setTitle("Sign Up", for: .normal)
        self.signUpButton.setTitleColor(.white, for: .normal)
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.backgroundColor = .systemBlue
        self.signUpButton.addTarget(self, action: #selector(SignUp), for: .touchUpInside)
        
        self.view.addSubview(self.signUpButton)
        NSLayoutConstraint.activate([
            self.signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.signUpButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 110),
            self.signUpButton.widthAnchor.constraint(equalToConstant: 125),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func SignUp(){
        Model.shared.FindName(name: self.textFieldName.text!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if data{
                        self.createAlertForError("Username Has Been Used")
                    }
                    else {
                        UserDefaults.standard.set(self.textFieldName.text, forKey: "username")
                        Model.shared.SignUp(user: User(_id:nil,number: self.textFieldForNumber.text!,name: self.textFieldName.text!, password: self.textFieldPassword.text!)) { result in
                            DispatchQueue.main.async {
                                
                                switch result {
                                case .success(let isCreated):
                                    if isCreated{
                                        self.navigationController?.pushViewController(AddCardViewController(), animated: true)
                                    }
                                case .failure(let error):
                                    self.createAlertForError(error.localizedDescription)
                                }
                            }
                        }
                    }
                case .failure(let error):
                    self.createAlertForError(error.localizedDescription)
                }
            }
        }
    }
    
    func setupHidePassword(){
        self.hidePasswordButton.setTitle("*", for: .normal)
        self.hidePasswordButton.setTitleColor(.white, for: .normal)
        self.hidePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        self.hidePasswordButton.addTarget(self, action: #selector(HidePassword), for: .touchUpInside)
        
        self.view.addSubview(self.hidePasswordButton)
        
        NSLayoutConstraint.activate([
            self.hidePasswordButton.centerXAnchor.constraint(equalTo: self.textFieldPassword.centerXAnchor,constant: 120),
            self.hidePasswordButton.centerYAnchor.constraint(equalTo: self.self.textFieldPassword.centerYAnchor),
            self.hidePasswordButton.widthAnchor.constraint(equalToConstant: 40),
            self.hidePasswordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    @objc func HidePassword(){
        self.view.endEditing(true)
        self.textFieldPassword.isSecureTextEntry = !self.textFieldPassword.isSecureTextEntry
    }
    
    func createAlertForError(_ error:String?){
        alertForError = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default)
        alertForError?.addAction(action1)
        
        self.present(self.alertForError!, animated: true)
    }
    
}
