import Foundation

import RxSwift

public protocol ClassroomRepository {
    func classroomMoveApply(floor: Int, classroomName: String) -> Completable
    func fetchClassroomCheck() -> Single<ClassroomCheckEntity>
    func classroomReturn() -> Completable
}
