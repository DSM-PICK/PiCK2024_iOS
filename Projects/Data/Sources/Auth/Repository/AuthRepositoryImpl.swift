import Foundation

import Moya
import RxSwift

import AppNetwork
import Core
import Domain

class AuthRepositoryImpl: AuthRepository {

    let remoteDataSource = AuthDataSource.shared
    private var disposeBag = DisposeBag()

    func login(accountID: String, password: String) -> Completable {

        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create {} }

            self.remoteDataSource.login(accountID: accountID, password: password)
                .subscribe(onSuccess: { tokenData in
                    TokenStorage.shared.accessToken = tokenData.accessToken
                    TokenStorage.shared.refreshToken = tokenData.refreshToken
                    completable(.completed)
                }, onFailure: {
                    completable(.error($0))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create {}
        }
    }
    
    func refreshToken() -> Completable {//수정 필요
        return Completable.empty()
    }
    

}
