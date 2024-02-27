import Foundation

import RxSwift

public class LoginUseCase {

    let disposeBag = DisposeBag()

    let repository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.repository = authRepository
    }

    public func login(accountID: String, password: String) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create {} }
            repository.login(accountID: accountID, password: password)
                .subscribe(
                    with: self,
                    onCompleted: { owner in
                        completable(.completed)
                    },
                    onError: { owner, err in
                        completable(.error(err))
                    }
                )
                .disposed(by: disposeBag)
            return Disposables.create {}
        }
    }
    
}
