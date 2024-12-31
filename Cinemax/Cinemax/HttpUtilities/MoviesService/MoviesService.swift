//
//  MoviesService.swift
//  Cinemax
//
//  Created by IPS-161 on 05/03/24.
//

import Foundation
import Alamofire

class MoviesService: HttpServiceProtocol {
    var sessionManager: Session
    
    init() {
        let manager = ServerTrustManager(evaluators: ["api.themoviedb.org": DisabledTrustEvaluator()])
        self.sessionManager = Session(serverTrustManager: manager)
    }
    
    func request(urlRequest: URLRequestConvertible) -> DataRequest {
        return sessionManager.request(urlRequest)
    }
}
