//
//  HttpRouter.swift
//  AlamofirePractice
//
//  Created by IPS-161 on 04/03/24.
//

import Foundation
import Alamofire

protocol HttpRouterProtocol: URLRequestConvertible {
    var baseUrlString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    func body() throws -> Data?
    func request(service: HttpServiceProtocol) throws -> DataRequest
}

extension HttpRouterProtocol {
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrlString.asURL()
        let urlWithPath = "\(url)\(path)"
        print(urlWithPath)
        var urlRequest = try URLRequest(url: urlWithPath, method: method, headers: headers)
        urlRequest.httpBody = try body()
        return urlRequest
    }
    
    func request(service: HttpServiceProtocol) throws -> DataRequest {
        return try service.request(urlRequest: asURLRequest())
    }
    
}
