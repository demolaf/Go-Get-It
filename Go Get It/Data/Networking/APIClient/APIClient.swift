//
//  APIRepository.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 08/07/2023.
//

import Foundation

protocol APIClient {
    /// GET Method
    @discardableResult
    func get<ResponseType: Decodable>(url: URL?, headers: [String: String]?, response: ResponseType.Type, skipDecoding: Bool, completion: @escaping (Any?, Error?) -> Void) -> URLSessionTask?
    
    /// POST Method
    @discardableResult
    func post<RequestType: Encodable, ResponseType: Decodable>(url: URL?, headers: [String: String]?, body: RequestType, response: ResponseType.Type, skipDecoding: Bool, completion: @escaping (Any?, Error?) -> Void) -> URLSessionTask?
}
