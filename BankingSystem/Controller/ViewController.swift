import UIKit

class ViewController: UIViewController {
    
    var textFieldName = UITextField()
    var textFieldPassword = UITextField()
    
    var loginButton = UIButton()
    var signupButton = UIButton()
    var passwordForGotButton = UIButton()
    var hidePasswordButton = UIButton()
    
    var alertForError:UIAlertController?
    
    var xView = UIImageView()
    var facebookView = UIImageView()
    var instagramView = UIImageView()
    
    var label = UILabel()
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("ViewController", forKey: "lastControllerName")
        
        UserDefaults.standard.set("", forKey: "username")
        self.title = "Login"
        ViewManager.shared.addGradient(to: self.view, colors: [UIColor(hex: "#6CB1A2")!,UIColor(hex:"#4D70A4")!])
        
        setupTextFieldForName()
        setupTextFieldForPassword()
        
        setupLoginButton()
        setupSignUpButton()
        setupForgotPasswordButton()
        setupHidePassword()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        setupSocialNetworkViews()
        setupMainLabel()
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
            self.xView.centerYAnchor.constraint(equalTo: self.signupButton.centerYAnchor,constant: 150),
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
            self.facebookView.centerYAnchor.constraint(equalTo: self.signupButton.centerYAnchor,constant: 150),
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
            self.instagramView.centerYAnchor.constraint(equalTo: self.signupButton.centerYAnchor,constant: 150),
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
            self.label.centerYAnchor.constraint(equalTo: self.textFieldName.centerYAnchor, constant: -100),
            self.label.widthAnchor.constraint(equalToConstant: 200),
            self.label.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    @objc func updateUI(){
        UIView.animate(withDuration: 1.5) {
            if self.textFieldName.backgroundColor == UIColor(hex: "#70709F") && self.textFieldPassword.backgroundColor == UIColor(hex: "#6CB1A2"){
                self.textFieldName.backgroundColor = UIColor(hex: "#6CB1A2")
                self.textFieldPassword.backgroundColor = UIColor(hex: "#70709F")
            }
            else{
                self.textFieldName.backgroundColor = UIColor(hex: "#70709F")
                self.textFieldPassword.backgroundColor = UIColor(hex: "#6CB1A2")
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
    func setupLoginButton(){
        self.loginButton.setTitle("Login", for: .normal)
        self.loginButton.setTitleColor(.white, for: .normal)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.backgroundColor = .systemBlue
        self.loginButton.addTarget(self, action: #selector(Login), for: .touchUpInside)
        
        self.view.addSubview(self.loginButton)
        NSLayoutConstraint.activate([
            self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loginButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 110),
            self.loginButton.widthAnchor.constraint(equalToConstant: 125),
            self.loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func Login(){
        print("Login")
        Model.shared.Login(user: User(_id: nil, number: nil, name: self.textFieldName.text!, password: self.textFieldPassword.text!)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let login):
                    if login{
                        UserDefaults.standard.set(self.textFieldName.text, forKey: "username")
                        self.navigationController?.viewControllers = [HomeViewController()]
                    }
                    else{
                        self.createAlertForError(String(login))
                    }
                case .failure(let error):
                    self.createAlertForError(error.localizedDescription)
                }
            }
        }
    }
    func setupSignUpButton(){
        self.signupButton.setTitle("Sign Up", for: .normal)
        self.signupButton.setTitleColor(.systemBlue, for: .normal)
        self.signupButton.addTarget(self, action: #selector(SignUp), for: .touchUpInside)
        self.signupButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.signupButton)
        NSLayoutConstraint.activate([
            self.signupButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.signupButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: 160),
            self.signupButton.widthAnchor.constraint(equalToConstant: 125),
            self.signupButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    @objc func SignUp(){
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    func setupForgotPasswordButton(){
        self.passwordForGotButton.setTitle("Forgot Password", for: .normal)
        self.passwordForGotButton.translatesAutoresizingMaskIntoConstraints = false
        self.passwordForGotButton.setTitleColor(.systemBlue, for: .normal)
        self.passwordForGotButton.addTarget(self, action: #selector(ForgotPassword), for: .touchUpInside)
        
        self.view.addSubview(self.passwordForGotButton)
        NSLayoutConstraint.activate([
            self.passwordForGotButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.passwordForGotButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 60),
            self.passwordForGotButton.widthAnchor.constraint(equalToConstant: 200),
            self.passwordForGotButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    @objc func ForgotPassword(){
        self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
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
