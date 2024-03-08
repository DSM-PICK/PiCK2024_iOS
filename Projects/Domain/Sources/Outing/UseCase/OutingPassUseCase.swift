import Foundation

import RxSwift

public class FetchOutingPassUseCase {
    
    let repository: OutingRepository
    
    public init(repository: OutingRepository) {
        self.repository = repository
    }
    
    public func excute() -> Single<OutingPassEntity> {
        return repository.fetchOutingPass()
    }
    
}
