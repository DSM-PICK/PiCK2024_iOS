import Foundation

import RxSwift

public protocol EarlyLeaveRepository {
    func earlyLeaveApply(reason: String, startTime: String) -> Completable
}
