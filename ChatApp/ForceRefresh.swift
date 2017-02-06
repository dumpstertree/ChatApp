//
//  ForceRefresh.swift
//  ChatApp
//
//  Created by Zachary Collins on 2/5/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
class ForceRefresh{
    
    static var delegates : [ForceRefreshProtocol] = []
    static func forceRefresh(){
        for delegate in delegates{
            delegate.forceRefresh()
        }
    }
}

protocol ForceRefreshProtocol {
    func forceRefresh()
}
