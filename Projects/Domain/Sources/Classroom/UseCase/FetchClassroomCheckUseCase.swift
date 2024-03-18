import Foundation

import RxSwift

public class FetchClassroomCheckUseCase {

    let repository: ClassroomRepository
    
    public init(repository: ClassroomRepository) {
        self.repository = repository
    }

    public func execute() -> Single<ClassroomCheckEntity> {
        return repository.fetchClassroomCheck()
    }
    
}
