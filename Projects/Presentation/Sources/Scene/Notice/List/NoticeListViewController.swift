import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class NoticeListViewController: BaseVC<NoticeListViewModel> {
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "공지사항"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var noticeTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorColor = .primary900
        $0.rowHeight = 80
        $0.register(NoticeCell.self, forCellReuseIdentifier: NoticeCell.identifier)
    }
    
    public override func attribute() {
        navigationItem.titleView = navigationTitleLabel
        
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
    }
    public override func addView() {
        view.addSubview(noticeTableView)
    }
    public override func setLayout() {
        noticeTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(106)
            $0.left.right.bottom.equalToSuperview()
        }
    }

}

extension NoticeListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.identifier, for: indexPath) as? NoticeCell
        else {
            return UITableViewCell()
        }
        return cell
    }
    
}
