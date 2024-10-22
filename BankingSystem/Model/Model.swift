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
    private let baseURL = "http://192.168.10.12:5001/api/users"
    
    
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
    final func AddCard(card:Card,complition:@escaping (Result<Bool,Error>) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: self.baseURL + "/addCard") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do{
                let jsonData = try JSONEncoder().encode(card)
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
