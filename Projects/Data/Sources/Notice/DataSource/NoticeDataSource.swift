import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

class NoticeDataSource {
    private let provider = MoyaProvider<NoticeAPI>(plugins: [MoyaLoggingPlugin()])

    static let shared = NoticeDataSource()
    
    func fetchTodayNoticeList() -> Single<Response> {
        return provider.rx.request(.fetchTodayNoticeList)
            .filterSuccessfulStatusCodes()
    }
    
    func fetchNoticeList() -> Single<Response> {
        return provider.rx.request(.fetchNoticeList)
            .filterSuccessfulStatusCodes()
    }
    
    func fetchDetailNotice(id: UUID) -> Single<Response> {
        return provider.rx.request(.fetchDetailNotice(id: id))
            .filterSuccessfulStatusCodes()
    }
    
}
