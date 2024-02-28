import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

class ProfileDataSource {
    private let provider = MoyaProvider<ProfileAPI>(plugins: [MoyaLoggingPlugin()])

    static let shared: ProfileDataSource = ProfileDataSource()

    func fetchSimpleProfile() -> Single<Response> {
        return provider.rx.request(.fetchSimpleProfile)
            .filterSuccessfulStatusCodes()
            .catch { .error($0.toError(ProfileError.self)) }
    }
    func fetchDetailProfile() -> Single<Response> {
        return provider.rx.request(.fetchDetailProfile)
            .filterSuccessfulStatusCodes()
            .catch { .error($0.toError(ProfileError.self)) }
    }
    
}
