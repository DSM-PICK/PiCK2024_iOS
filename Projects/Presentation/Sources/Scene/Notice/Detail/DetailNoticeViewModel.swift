import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class DetailNoticeViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    private let fetchDetailNoticeUseCase: FetchDetailNoticeUseCase
    
    public init(fetchDetailNoticeUseCase: FetchDetailNoticeUseCase) {
        self.fetchDetailNoticeUseCase = fetchDetailNoticeUseCase
    }
    
    public struct Input {
        let viewWillAppear: Observable<UUID>
    }
    public struct Output {
        let contentData: Signal<DetailNoticeEntity>
    }
    
    let contentData = PublishRelay<DetailNoticeEntity>()
    
    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap { id in
                self.fetchDetailNoticeUseCase.execute(id: id)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: contentData)
            .disposed(by: disposeBag)
        
        return Output(
            contentData: contentData.asSignal()
        )
    }
    
}
