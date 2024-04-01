import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

class EarlyLeaveDataSource {
    private let provider = MoyaProvider<EarlyLeaveAPI>(plugins: [MoyaLoggingPlugin()])
    
    static let shared = EarlyLeaveDataSource()
    private init() {}
    
    func earlyLeaveApply(reason: String, startTime: String) -> Completable {
        return provider.rx.request(.earlyLeaveApply(
            reason: reason,
            startTime: startTime
        ))
        .asCompletable()
    }
    
    
}
