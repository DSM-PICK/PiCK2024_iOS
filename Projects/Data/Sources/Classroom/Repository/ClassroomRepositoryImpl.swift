import Foundation

import RxSwift

import Domain

class ClassroomRepositoryImpl: ClassroomRepository {
    let remoteDataSource = ClassroomDataSource.shared
    
    func classroomMoveApply(floor: Int, classroomName: String) -> Completable {
        return remoteDataSource.classroomMoveApply(
            floor: floor, classroomName: classroomName
        )
    }
    
}
