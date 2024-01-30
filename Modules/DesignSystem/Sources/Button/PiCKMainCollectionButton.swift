import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

public class PiCKMainCollectionButton: UIButton {
    
    private let disposeBag = DisposeBag()
    
    private var isClick = false
    
    private var titleColor: UIColor {
        !isClick ? .primary400: .primary900
    }
    
    private var bgColor: UIColor {
        !isClick ? .primary900: .primary100
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        layout()
    }

    private func attribute() {
        self.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isClick.toggle()
            }).disposed(by: disposeBag)
    }
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 14
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .buttonES
        self.backgroundColor = bgColor
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }
    
    private func layout() {
        self.snp.makeConstraints {
            $0.height.equalTo(28)
        }
    }
}
