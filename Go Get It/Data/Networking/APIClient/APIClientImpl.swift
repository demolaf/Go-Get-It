//
//  APIRepositoryImpl.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 08/07/2023.
//

import Foundation

class APIClientImpl: APIClient {
    func get<ResponseType: Decodable>(url: URL?, headers: [String: String]?, response: ResponseType.Type, skipDecoding: Bool = false, completion: @escaping (Any?, Error?) -> Void) -> URLSessionTask? {
        guard let url = url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
    
            do {
                if skipDecoding {
                    DispatchQueue.main.async {
                        completion(data, nil)
                    }
                } else {
                    let responseObject = try decoder.decode(ResponseType.self, from: data)
                    debugPrint(responseObject)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                debugPrint(error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
        return task
    }
    
    func post<RequestType: Encodable, ResponseType: Decodable>(url: URL?, headers: [String: String]?, body: RequestType, response: ResponseType.Type, skipDecoding: Bool = false, completion: @escaping (Any?, Error?) -> Void) -> URLSessionTask? {
        guard let url = url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                if skipDecoding {
                    DispatchQueue.main.async {
                        completion(data, nil)
                    }
                } else {
                    let responseObject = try decoder.decode(ResponseType.self, from: data)
                    debugPrint(responseObject)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                debugPrint(error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
        return task
    }
}
