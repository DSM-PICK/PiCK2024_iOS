import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

class ClassroomDataSource {
    private let provider = MoyaProvider<ClassroomAPI>(plugins: [MoyaLoggingPlugin()])
    
    static let shared = ClassroomDataSource()
    private init() {}
    
    func classroomMoveApply(floor: Int, classroomName: String) -> Completable {
        return provider.rx.request(.classroomMoveApply(
            floor: floor,
            classroom: classroomName
        ))
        .asCompletable()
    }
    
    func fetchClassroomCheck() -> Single<Response> {
        return provider.rx.request(.classroomCheck)
            .filterSuccessfulStatusCodes()
    }
    
    func classroomReturn() -> Completable {
        return provider.rx.request(.classroomReturn)
            .asCompletable()
    }
    
}
