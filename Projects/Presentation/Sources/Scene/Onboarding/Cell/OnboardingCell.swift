import UIKit

import SnapKit
import Then

import DesignSystem

class OnboardingCell: UICollectionViewCell {

    static let identifier = "onboardingCellID"

    public lazy var imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }

}
