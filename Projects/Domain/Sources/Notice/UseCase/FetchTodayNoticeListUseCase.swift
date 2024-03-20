import Foundation

import RxSwift

public class FetchTodayNoticeListUseCase {
    let repository: NoticeRepository
    
    public init(repository: NoticeRepository) {
        self.repository = repository
    }
    
    public func execute() -> Single<TodayNoticeListEntity> {
        return repository.fetchTodayNoticeList()
    }
    
}
