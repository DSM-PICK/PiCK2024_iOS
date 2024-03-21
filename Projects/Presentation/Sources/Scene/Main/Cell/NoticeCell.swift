import UIKit

import SnapKit
import Then

import Core
import DesignSystem
import Domain

public class NoticeCell: BaseCollectionViewCell {
    
    static let identifier = "noticeCellID"
    
    public var id: UUID?
    
    private let noticeIconImageView = UIImageView(image: .noticeIcon)
    private let noticeLabel = UILabel().then {
        $0.text = "공지"
        $0.textColor = .neutral400
        $0.font = .caption3
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .body3
    }
    private let dateLabel = UILabel().then {
        $0.textColor = .neutral200
        $0.font = .caption3
    }
    public lazy var newNoticeIconImageView = UIImageView(image: .newNoticeIcon).then {
        $0.isHidden = true
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .primary900
    }
    
    public func setup(
        id: UUID,
        title: String,
        date: String
    ) {
        self.id = id
        self.titleLabel.text = title
        self.dateLabel.text = date
    }
    public override func attribute() {
        contentView.backgroundColor = .white
    }
    public override func layout() {
        [
            noticeIconImageView,
            noticeLabel,
            titleLabel,
            dateLabel,
            newNoticeIconImageView,
            lineView
        ].forEach { contentView.addSubview($0) }
        
        noticeIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(34)
        }
        noticeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.equalTo(noticeIconImageView.snp.right).offset(22)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(4)
            $0.left.equalTo(noticeIconImageView.snp.right).offset(22)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalTo(noticeIconImageView.snp.right).offset(22)
        }
        newNoticeIconImageView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(7)
            $0.left.equalTo(titleLabel.snp.right).offset(3)
        }
        lineView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
}
