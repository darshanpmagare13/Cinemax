//
//  HttpService.swift
//  AlamofirePractice
//
//  Created by IPS-161 on 04/03/24.
//

import Foundation
import Alamofire

protocol HttpServiceProtocol {
    var sessionManager : Session { get set }
    func request(urlRequest:URLRequestConvertible) -> DataRequest
}
