import Foundation

import RxSwift

public protocol NoticeRepository {
    func fetchTodayNoticeList() -> Single<TodayNoticeListEntity>
    func fetchNoticeList() -> Single<NoticeListEntity>
    func fetchDetailNotice(id: UUID) -> Single<DetailNoticeEntity>
}
