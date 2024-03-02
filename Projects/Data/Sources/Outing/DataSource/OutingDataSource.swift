import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

class OutingDataSource {
    private let provider = MoyaProvider<OutingAPI>(plugins: [MoyaLoggingPlugin()])
    
    static let shared = OutingDataSource()
    private init() {}
    
    func outingApply(reason: String, startTime: String, endTime: String) -> Completable {
        return provider.rx.request(.outingApply(
            reason: reason,
            startTime: startTime,
            endTime: endTime
        ))
        .asCompletable()
    }
    func fetchOutingPass() -> Single<Response> {
        return provider.rx.request(.fetchOutingPass)
            .filterSuccessfulStatusCodes()
    }
    
}
