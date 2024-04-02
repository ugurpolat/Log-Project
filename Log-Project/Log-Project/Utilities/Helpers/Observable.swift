//
//  Observable.swift
//  Log-Project
//
//  Created by Uğur Polat on 26.03.2024.
//

import Foundation

class Observable<T> {
    var value:T? {
        didSet{
            _callback?(value)
        }
    }
    
    private var _callback: ((T?) -> Void)?
    
    func bind(callback: @escaping (T?) -> Void) {
        _callback = callback
    }
}
