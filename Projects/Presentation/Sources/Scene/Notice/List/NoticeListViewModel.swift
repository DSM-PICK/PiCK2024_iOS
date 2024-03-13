import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class NoticeListViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    private let fetchNoticeListUseCase: FetchNoticeListUseCase
    
    public init(fetchNoticeListUseCase: FetchNoticeListUseCase) {
        self.fetchNoticeListUseCase = fetchNoticeListUseCase
    }
    
    public struct Input {
        let viewWillAppear: Observable<Void>
        let noticeCellDidClick: Observable<UUID>
    }
    public struct Output {
        let noticeListData: Driver<NoticeListEntity>
    }
    
    let noticeListData = BehaviorRelay<NoticeListEntity>(value: [])
    
    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.fetchNoticeListUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: noticeListData)
            .disposed(by: disposeBag)
        
        input.noticeCellDidClick
            .map { id in
                PiCKStep.detailNoticeRequired(id: id)
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return Output(
            noticeListData: noticeListData.asDriver()
        )
    }
    
}
