import UIKit

import SnapKit
import Then

import DesignSystem

public class MainCell: UICollectionViewCell {
    
    static let identifier = "mainCellID"
    
    public lazy var view = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
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
    
    private func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
    
}
