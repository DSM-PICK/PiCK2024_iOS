import UIKit

import SnapKit
import Then

import DesignSystem

public class ScrollTimeTableViewCell: UICollectionViewCell {
    
    static let identifier = "scrollTimeTableViewCellID"
    
    public lazy var view = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
