import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class NoticeCollectionView: UIView, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    public var clickToAction: () -> Void
    
    private let date = Date()
    
    private let noticeLabel = UILabel().then {
        $0.text = "공지"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    public let moreButton = UIButton(type: .system).then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.neutral200, for: .normal)
        $0.titleLabel?.font = .body3
//        $0.setImage(.chevronRightIcon, for: .normal)
//        $0.imageEdgeInsets = .init(
//            top: 5,
//            left: 12,
//            bottom: 5,
//            right: 8)
//        $0.tintColor = .neutral200
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private lazy var noticeTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorColor = .primary900
        $0.rowHeight = 80
        $0.layer.cornerRadius = 8
        $0.showsVerticalScrollIndicator = false
        $0.register(NoticeCell.self, forCellReuseIdentifier: NoticeCell.identifier)
    }
    
    init(
        clickToAction: @escaping () -> Void
    ) {
        self.clickToAction = clickToAction
        super.init(frame: .zero)
        setup()
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        addView()
        setLayout()
    }
    
    private func setup() {
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
    }
    private func bind() {
        moreButton.rx.tap
            .bind { [weak self] in
                self?.clickToAction()
            }.disposed(by: disposeBag)
    }
    private func addView() {
        [
            noticeLabel,
            moreButton,
            noticeTableView
        ].forEach { self.addSubview($0) }
    }
    private func setLayout() {
        noticeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }
        moreButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(12)
        }
        noticeTableView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(8)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
}

extension NoticeCollectionView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.identifier, for: indexPath) as? NoticeCell
        else {
            return UITableViewCell()
        }
        return cell
    }
    
}
