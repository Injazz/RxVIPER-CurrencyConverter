//
//  Reachability.swift
//  currencyconvert
//
//  Created by Admin on 08.02.2021.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class ReachabilityService {
    
    static let shared = ReachabilityService()
    
    let hasInternetConnection = BehaviorRelay<Bool>(value: true)
    let reachability = NetworkReachabilityManager()
    
    init() {
        subscribeToReachability()
    }
    
    func subscribeToReachability() {
        reachability?.startListening(onUpdatePerforming: { [weak self] status in
            switch status {
            case .unknown:
                print("Connection Reachability Service: status unknown")
            case .notReachable:
                self?.hasInternetConnection.accept(false)
            case .reachable(_):
                self?.hasInternetConnection.accept(true)
            }
        })
        
        if reachability != nil {
            hasInternetConnection.accept(reachability!.isReachable)
        }
    }
    
    func reachabilityError() -> NSError {
        let error = NSError(domain: "NoConnectionException", code: 0, userInfo: nil)
        return error
    }
    
}
