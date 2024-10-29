//
//  TrasactionHistoryViewController.swift
//  BankingSystem
//
//  Created by АА on 28.10.24.
//

import UIKit

class TrasactionHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userSender:[Transaction]? = []
    var userReceiver:[Transaction]? = []
    var mainData:[Transaction]? = []
    
    var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewManager.shared.addGradient(to: self.view, colors: [UIColor(hex: "#6CB1A2")!,UIColor(hex:"#4D70A4")!])
        DataBases()
        createTableView()
    }
    func DataBases(){
        self.userSender = []
        self.userReceiver = []
        self.mainData = []
        Model.shared.GetTrasnaction(username: UserDefaults.standard.string(forKey: "username")) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let dataBases):
                    for i in dataBases{
                        if i.sendername! == UserDefaults.standard.string(forKey: "username"){
                            self.userSender?.append(i)
                        }
                        else if i.recipient! == UserDefaults.standard.string(forKey: "username"){
                            self.userReceiver?.append(i)
                        }
                    }
                    self.mainData = self.userSender! + self.userReceiver!
                    self.tableView.reloadData()
                }
            }
        }
    }
    func createTableView(){
        self.tableView = UITableView()
        self.tableView.backgroundColor = .none
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
                    self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
                ])
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if self.mainData![indexPath.row].sendername == UserDefaults.standard.string(forKey: "username"){
            cell.textLabel?.text = "You Send \(self.mainData![indexPath.row].amount!) \(self.mainData![indexPath.row].recipient!)"
        }
        else if self.mainData![indexPath.row].recipient == UserDefaults.standard.string(forKey: "username"){
            cell.textLabel?.text = "\(self.mainData![indexPath.row].sendername!) Send \(self.mainData![indexPath.row].amount!) You"
        }
        cell.backgroundColor = UIColor(red: 0.2, green: 0.7, blue: 0.5, alpha: 0.1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Type \(self.mainData![indexPath.row])")
    }
}
