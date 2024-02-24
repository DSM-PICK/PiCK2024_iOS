import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class NoticeCell: BaseCollectionViewCell {
    
    static let identifier = "noticeCellID"
    
    private let noticeIconImageView = UIImageView(image: .noticeIcon)
    private let noticeLabel = UILabel().then {
        $0.text = "공지"
        $0.textColor = .neutral400
        $0.font = .caption3
    }
    private let titleLabel = UILabel().then {
        $0.text = "[중요] 오리엔테이션날 일정 안내"
        $0.textColor = .black
        $0.font = .body3
    }
    private lazy var dateLabel = UILabel().then {
        $0.text = "1일전"
        $0.textColor = .neutral200
        $0.font = .caption3
    }
    public lazy var newNoticeIconImageView = UIImageView(image: .newNoticeIcon).then {
        $0.isHidden = true
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
            newNoticeIconImageView
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
    }
    
}
