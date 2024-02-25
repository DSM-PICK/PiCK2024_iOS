import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class DetailNoticeViewController: BaseViewController<DetailNoticeViewModel> {
    
    private lazy var navigationTitleLabel = UILabel().then {
        $0.text = "[중요] 오리엔테이션날 일정 안내"
        $0.textColor = .neutral50
        $0.font = .subTitle1M
    }
    private let titleLabel = UILabel().then {
        $0.text = "[중요] 오리엔테이션날 일정 안내"
        $0.textColor = .neutral50
        $0.font = .subTitle2M
    }
    private let dateLabel = UILabel().then {
        $0.text = "2024-02-09"
        $0.textColor = .neutral400
        $0.font = .caption2
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .neutral900
    }
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(DetailNoticeCell.self, forCellReuseIdentifier: DetailNoticeCell.identifier)
    }
    
    public override func attribute() {
        super.attribute()
        tableView.delegate = self
        tableView.dataSource = self
    }
    public override func addView() {
        [
            navigationTitleLabel,
            titleLabel,
            dateLabel,
            lineView,
            tableView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        navigationTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(55)
            $0.left.right.equalToSuperview().inset(95)
        }
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
        tableView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
}

extension DetailNoticeViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailNoticeCell.identifier, for: indexPath) as? DetailNoticeCell
        else {
            return UITableViewCell()
        }
        return cell
    }
    
}
