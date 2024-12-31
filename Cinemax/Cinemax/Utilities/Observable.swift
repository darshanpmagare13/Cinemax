//
//  Observable.swift
//  Cinemax
//
//  Created by IPS-177  on 01/05/24.
//

import Foundation

class Observable<T>{
    
    var value: T? {
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.listener?(self.value)
            }
        }
    }
    
    init(value:T?) {
        self.value = value
    }
    
    private var listener : ((T?)->())?
    
    func bind(listener: @escaping (T?)->() ){
        listener(value)
        self.listener = listener
    }
    
}
