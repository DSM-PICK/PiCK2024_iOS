import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import DesignSystem

public class DetailNoticeViewController: BaseViewController<DetailNoticeViewModel> {
    
    private let viewWillAppearRelay = PublishRelay<UUID>()
    public var id = UUID()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainView = UIView()
    
    private lazy var navigationTitleLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .subTitle1M
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .subTitle2M
    }
    private let dateLabel = UILabel().then {
        $0.textColor = .neutral400
        $0.font = .caption2
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .neutral900
    }
    private let contentLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .caption2
        $0.numberOfLines = 0
    }
    
    public override func configureNavgationBarLayOutSubviews() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func bindAction() {
        viewWillAppearRelay.accept(id)
    }
    public override func bind() {
        let input = DetailNoticeViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.contentData.asObservable()
            .subscribe(
                onNext: { notice in
                    self.navigationTitleLabel.text = notice.title
                    self.titleLabel.text = notice.title
                    self.dateLabel.text = notice.createAt
                    self.contentLabel.text = notice.content
                }
            )
            .disposed(by: disposeBag)
        
    }
    public override func addView() {
        [
            titleLabel,
            dateLabel,
            lineView,
            scrollView
        ].forEach { view.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(mainView)
        
        mainView.addSubview(contentLabel)
    }
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(119)
            $0.left.equalToSuperview().inset(24)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(24)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(5)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(self.view.frame.height * 1.2)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.right.equalToSuperview().inset(24)
        }
        
    }
    
}
