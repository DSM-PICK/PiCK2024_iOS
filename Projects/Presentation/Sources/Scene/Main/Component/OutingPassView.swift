import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class OutingPassView: UIView, Stepper {
    
    public var clickToAction: () -> Void
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    private let label = UILabel().then {
        $0.text = "강해민님의 조기 귀가 가능 시간은\n12 : 34 부터 입니다."
        $0.textColor = .neutral300
        $0.font = .caption2
        $0.numberOfLines = 0
    }
    private let checkButton = UIButton(type: .system).then {
        $0.setTitle("외출증 보러가기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .buttonES
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .secondary500
    }
    
    init(
        clickToAction: @escaping () -> Void
    ) {
        self.clickToAction = clickToAction
        super.init(frame: .zero)
        setup()
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
    }
    private func bind() {
        checkButton.rx.tap
            .bind { [weak self] in
                self?.clickToAction()
            }.disposed(by: disposeBag)
    }
    private func layout() {
        [
            label,
            checkButton
        ].forEach { self.addSubview($0) }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(12)
        }
        checkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
    }
    
}
