import Foundation

import RxSwift

import Domain

class EarlyLeaveRepositoryImpl: EarlyLeaveRepository {
    let remoteDataSource = EarlyLeaveDataSource.shared
    
    func earlyLeaveApply(reason: String, startTime: String) -> Completable {
        return remoteDataSource.earlyLeaveApply(
            reason: reason,
            startTime: startTime
        )
    }
    
}
