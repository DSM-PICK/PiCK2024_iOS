import Foundation

import RxSwift

public class EarlyLeaveApplyUseCase {

    let repository: EarlyLeaveRepository

    public init(repository: EarlyLeaveRepository) {
        self.repository = repository
    }

    public func execute(reason: String, startTime: String) -> Completable {
        return repository.earlyLeaveApply(reason: reason, startTime: startTime)
    }
}
