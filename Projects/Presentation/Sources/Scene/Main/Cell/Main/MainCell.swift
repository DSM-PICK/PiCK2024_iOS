import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class MainCell: BaseCollectionViewCell {
    
    public var disposeBag = DisposeBag()
    
    private let date = Date()
    private lazy var todayDate = date.toString(type: .dateAndDays)
    
    static let identifier = "mainCellID"
    
    private let titleLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var dateLabel = UILabel().then {
        $0.text = todayDate
        $0.textColor = .neutral300
        $0.font = .body3
    }
    public let moreButton = UIButton(type: .system).then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.neutral200, for: .normal)
        $0.titleLabel?.font = .body3
        $0.semanticContentAttribute = .forceRightToLeft
        $0.isHidden = true
    }
    public var view = UIView()
    
    public func configureUI(
        title: String,
        buttonVisiable: Bool,
        dateVisiable: Bool
    ) {
        self.titleLabel.text = title
        self.moreButton.isHidden = buttonVisiable
        self.dateLabel.isHidden = dateVisiable
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    public override func attribute() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
    public override func layout() {
        [
            titleLabel,
            dateLabel,
            moreButton,
            view
        ].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.left.equalTo(titleLabel.snp.right).offset(8)
        }
        moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(10)
        }
        view.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(21)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}
