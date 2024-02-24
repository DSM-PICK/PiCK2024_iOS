import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class PiCKApplyView: BaseView {
    
    public func getter(
        text: String,
        image: UIImage
    ) {
        applyLabel.text = text
        applyImageView.image = image
    }
    
    private let todayLabel = UILabel().then {
        $0.text = "오늘"
        $0.textColor = .neutral300
        $0.font = .body3
    }
    private let applyLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let applyImageView = UIImageView()
    
    public override func attribute() {
        self.backgroundColor = .primary1200
        self.layer.cornerRadius = 8
    }
    public override func addView() {
        [
            todayLabel,
            applyLabel,
            applyImageView
        ].forEach { self.addSubview($0) }
    }
    public override func setLayout() {
        todayLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(16)
        }
        applyLabel.snp.makeConstraints {
            $0.top.equalTo(todayLabel.snp.bottom)
            $0.left.equalToSuperview().inset(16)
        }
        applyImageView.snp.makeConstraints {
            $0.right.bottom.equalToSuperview().inset(12)
        }
    }
    
}
