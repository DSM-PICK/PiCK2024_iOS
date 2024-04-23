import Foundation

import RxSwift

import Domain

class OutingRepositoryImpl: OutingRepository {
    let remoteDataSource = OutingDataSource.shared
    
    func outingApply(reason: String, startTime: String, endTime: String) -> Completable {
        return remoteDataSource.outingApply(
            reason: reason,
            startTime: startTime,
            endTime: endTime
        )
    }
    
    func fetchOutingPass() -> Single<OutingPassEntity> {
        return remoteDataSource.fetchOutingPass()
            .map(OutingPassDTO.self)
            .map { $0.toDomain() }
    }
}
