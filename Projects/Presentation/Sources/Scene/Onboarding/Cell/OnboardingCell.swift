import UIKit

import SnapKit
import Then

import Core
import DesignSystem

class OnboardingCell: BaseCollectionViewCell {

    static let identifier = "onboardingCellID"

    public lazy var imageView = UIImageView()
    
    override func layout() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
