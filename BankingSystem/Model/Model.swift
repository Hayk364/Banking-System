//
//  Model.swift
//  BankingSystem
//
//  Created by АА on 16.10.24.
//
import UIKit


final class Model {
    private init(){}
    static let shared = Model()
    private let baseURL = "http://192.168.10.10:5001/api/users"
    
    final func GetCard(username:String,complition:@escaping (Result<CardForBalance,Error>) -> Void){
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: self.baseURL + "/getCard") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do{
                let jsonData = try JSONEncoder().encode(["username":username])
                request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error{
                        complition(.failure(error))
                    }
                    guard let data else { return }
                    do{
                        let card = try JSONDecoder().decode(CardForBalance.self, from: data)
                        complition(.success(card))
                    }catch{
                        complition(.failure(error))
                    }
                }
                task.resume()
            }
            catch{
                complition(.failure(error))
            }
        }
    }
    final func getBalance(username:String?,complition:@escaping (Result<Double,Error>) -> Void){
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: self.baseURL + "/get-balance") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do{
                let jsonData = try JSONEncoder().encode(["username":username])
                request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request){ data,response,error in
                    if let error{
                        complition(.failure(error))
                    }
                    guard let data else{ return }
                    do{
                        let balance = try JSONDecoder().decode(Double.self, from: data)
                        complition(.success(balance))
                    }
                    catch{
                        complition(.failure(error))
                    }
                }
                task.resume()
            }
            catch{
                complition(.failure(error))
            }
        }
    }
    final func GetTrasnaction(username:String?,complition:@escaping (Result<[Transaction],Error>) -> Void){
        guard let url = URL(string: "http://192.168.10.10:5001/api/users/getTransaction") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let jsonData = try JSONEncoder().encode(["username":username])
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) {  data,response, error in
                if let error = error {
                    complition(.failure(error))
                    return
                }
                if let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode != 200{
                    complition(.failure(httpResponse.statusCode.description as! Error))
                }
                guard let data else { return }
                do{
                    let dataBases = try JSONDecoder().decode([Transaction].self, from: data)
                    complition(.success(dataBases))
                }catch{
                    complition(.failure(error))
                }
            }
            task.resume()
        }
        catch{
            complition(.failure(error))
        }
    }
    final func AddBalance(amount:Double?,username:String?,complition:@escaping (Result<Double,Error>) -> Void){
        DispatchQueue.global(qos: .userInteractive).async{
            guard let url = URL(string: self.baseURL + "/add-balance") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do{
                let jsonData = try JSONEncoder().encode(AddData(username: username, amount: amount))
                request.httpBody = jsonData
                let task =  URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error {
                        complition(.failure(error))
                    }
                    guard let data else { return }
                    do{
                        let balance = try JSONDecoder().decode(Double.self, from: data)
                        complition(.success(balance))
                    }
                    catch{
                        complition(.failure(error))
                    }
                }
                task.resume()
            }
            catch{
                complition(.failure(error))
            }
        }
    }
    final func SignUp(user: User,complition:@escaping (Result<Bool,Error>) -> Void){
        DispatchQueue.global(qos: .userInteractive).async {
            self.FindName(name: user.name) { result in
                switch result {
                case .success(let isFind):
                    if isFind {
                        complition(.success(false))
                    }
                    else{
                        guard let url = URL(string: self.baseURL) else { return }
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        do{
                            let jsonData = try JSONEncoder().encode(UserJson(id: nil, number: user.number, name: user.name, password: user.password))
                            request.httpBody = jsonData
                            
                            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                                if let error {
                                    complition(.failure(error))
                                }
                                guard let data else { return }
                                do {
                                    let newUser = try JSONDecoder().decode(Bool.self, from: data)
                                    complition(.success(newUser))
                                }
                                catch {
                                    complition(.failure(error))
                                }
                            }
                            task.resume()
                        }
                        catch {
                            complition(.failure(error))
                        }
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
        }
    }
    final func FindName(name:String?,complition:@escaping (Result<Bool,Error>) -> Void){
        DispatchQueue.global(qos: .userInitiated).async{
            guard let url = URL(string: self.baseURL + "/findName") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let jsonData = try JSONEncoder().encode(UserJson(id: nil, number: nil, name: name, password: nil))
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        complition(.failure(error))
                    }
                    guard let data else { return }
                    do{
                        let isFind = try JSONDecoder().decode(Bool.self, from: data)
                        complition(.success(isFind))
                    }
                    catch{
                        complition(.failure(error))
                    }
                }
                task.resume()
            }
            catch{
                complition(.failure(error))
            }
        }
    }
    final func Login(user:User,complition:@escaping (Result<Bool,Error>) -> Void){
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: self.baseURL + "/findUser") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let jsonData = try JSONEncoder().encode(UserJson(id: nil, number: nil, name: user.name, password: user.password))
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        complition(.failure(error))
                    }
                    guard let data else { return }
                    do{
                        let isFind = try JSONDecoder().decode(Bool.self, from: data)
                        complition(.success(isFind))
                    }
                    catch {
                        complition(.failure(error))
                    }
                }
                task.resume()
            }
            catch{
                complition(.failure(error))
            }
        }
    }
    final func SendMoney(username:String?,senduserkey:String?,amount:Double?,complition:@escaping (Result<Bool,Error>) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: self.baseURL + "/send-money") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do{
                let jsonData = try JSONEncoder().encode(BankingSystem.SendMoney(username: username, amount: amount, senduserkey: senduserkey))
                request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error{
                        complition(.failure(error))
                    }
                    guard let data else { return }
                    do{
                        let response = try JSONDecoder().decode(Bool.self, from: data)
                        complition(.success(response))
                    }
                    catch{
                        complition(.failure(error))
                    }
                }
                task.resume()
            }catch{
                complition(.failure(error))
            }
        }
    }
    final func AddCard(card:Card,complition:@escaping (Result<Bool,Error>) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: self.baseURL + "/addCard") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do{
                let jsonData = try JSONEncoder().encode(CardForBalance(id: nil, number: card.number, username: card.username, cardname: card.cardname, cvv: card.cvv, date: card.date, balance: 5000.0,key:nil,status: "user"))
                request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error{
                        complition(.failure(error))
                    }
                    guard let data else {return}
                    do{
                        let newCard = try JSONDecoder().decode(Bool.self, from: data)
                        complition(.success(newCard))
                    }
                    catch{
                        complition(.failure(error))
                    }
                }
                task.resume()
            }
            catch{
                complition(.failure(error))
            }
        }
    }
}
