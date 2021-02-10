//
//  Network.swift
//  currencyconvert
//
//  Created by Admin on 08.02.2021.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import Moya
import Alamofire

class Network {
    static let authException = BehaviorRelay<Bool>(value: false)
    static let serverException = BehaviorRelay<Void>(value: ())
    static let updateAppException = BehaviorRelay<Bool>(value: false)
    
    fileprivate static var provider = MoyaProvider<RapidApi>(
        endpointClosure: { (target) -> Endpoint in
            return Endpoint(
                url: target.url,
                sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers)}, plugins: [CachePolicyPlugin()])
}

extension Network {
    static func request(_ target: RapidApi) -> Observable<Response> {
        print(target.method, target.headers ?? "", target.url, target.parameters ?? "")
        return provider.rx.request(target).asObservable().handleResponse().filterSuccessfulStatusCodes()
    }
    static func requestWithProgress(_ target: RapidApi) -> Observable<ProgressResponse> {
        print(target.method, target.headers ?? "", target.url, target.parameters ?? "")
        return provider.rx.requestWithProgress(target).asObservable().handleResponse()
    }
}

extension Observable {
    
    func handleResponse() -> Observable<Element> {
        return self.do(onNext: { response in
            if let r = response as? Response {
                if r.statusCode == 403 {
                    Network.authException.accept(true)
                }
                if r.statusCode == 500 {
                    print("500 \(r.description)")
                    Network.serverException.accept(())
                }
                if r.statusCode == 426 {
                    Network.updateAppException.accept(true)
                }
            }
        }, onError: { error in
            if ReachabilityService.shared.hasInternetConnection.value == false {
                throw ReachabilityService.shared.reachabilityError() as Error
            }
            
            guard let e = error as? MoyaError else { throw error }
            guard case .statusCode(let response) = e else { throw error }
            
            if response.statusCode == 403 {
                Network.authException.accept(true)
            }
            if response.statusCode == 500 {
                print("error 500")
                Network.serverException.accept(())
            }
            if response.statusCode == 426 {
                Network.updateAppException.accept(true)
            }
            
        })
    }
    
}
