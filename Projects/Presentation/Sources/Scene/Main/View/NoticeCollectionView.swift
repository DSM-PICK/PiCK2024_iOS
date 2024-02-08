import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class NoticeCollectionView: UIView {
    
    private let date = Date()
    
    private let noticeLabel = UILabel().then {
        $0.text = "공지"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var dateLabel = UILabel().then {
        $0.text = "\(date.toString(DateFormatIndicated.dateAndDays.rawValue))"
        $0.textColor = .neutral300
        $0.font = .body3
    }
    private let moreButton = UIButton(type: .system).then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.neutral200, for: .normal)
        $0.titleLabel?.font = .body3
        $0.setImage(.chevronRightIcon, for: .normal)
        $0.tintColor = .neutral200
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private lazy var noticeTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorColor = .primary900
        $0.rowHeight = 80
        $0.register(NoticeCell.self, forCellReuseIdentifier: NoticeCell.identifier)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
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
    private func addView() {
        [
            noticeLabel,
            dateLabel,
            moreButton,
            noticeTableView
        ].forEach { self.addSubview($0) }
    }
    private func setLayout() {
        noticeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalTo(noticeLabel.snp.right).offset(8)
        }
        moreButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(12)
        }
        noticeTableView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
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
