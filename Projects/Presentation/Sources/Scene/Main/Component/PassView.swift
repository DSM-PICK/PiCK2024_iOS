import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class PassView: BaseView, Stepper {
    
    public var steps = PublishRelay<Step>()
    
    public var clickToAction: () -> Void
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.backgroundColor = .clear
    }
    private let topLabel = UILabel().then {
        $0.textColor = .neutral300
        $0.font = .caption2
        $0.numberOfLines = 0
    }
    
    private lazy var bottomLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .caption1
    }
    private var checkButton = UIButton(type: .system).then {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .buttonES
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .secondary500
        $0.contentEdgeInsets = .init(
            top: 11,
            left: 20,
            bottom: 11,
            right: 20
        )
    }
    
    public func setup(
        topLabel: String,
        bottomLabel: String,
        buttonTitle: String,
        firstPointText: String
    ) {
        self.topLabel.text = topLabel
        self.bottomLabel.attributedText = bottomLabel.attributed(
            of: firstPointText,
            key: .foregroundColor,
            value: UIColor.primary400
        ).addAttribute(
            of: firstPointText,
            key: .font,
            value: UIFont.subTitle3M
        )
        self.checkButton.setTitle(buttonTitle, for: .normal)
    }
    
    init(
        clickToAction: @escaping () -> Void
    ) {
        self.clickToAction = clickToAction
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func attribute() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
    }
    public override func bind() {
        checkButton.rx.tap
            .bind { [weak self] in
                self?.clickToAction()
            }.disposed(by: disposeBag)
    }
    public override func addView() {
        [
            labelStackView,
            checkButton
        ].forEach { self.addSubview($0) }
        
        [
            topLabel,
            bottomLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
    }
    public override func setLayout() {
        labelStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(12)
        }
        checkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
}


extension NSMutableAttributedString {
    func addAttribute(of searchString: String, key: NSAttributedString.Key, value: Any) -> NSMutableAttributedString {
        let length = self.string.count
        var range = NSRange(location: 0, length: length)
        var rangeArray = [NSRange]()

        while range.location != NSNotFound {
            range = (self.string as NSString).range(of: searchString, options: .caseInsensitive, range: range)
            rangeArray.append(range)

            if range.location != NSNotFound {
                range = NSRange(location: range.location + range.length, length: self.string.count - (range.location + range.length))
            }
        }

        rangeArray.forEach {
            self.addAttribute(key, value: value, range: $0)
        }

        return self
    }
}

extension String {
    func attributed(of searchString: String, key: NSAttributedString.Key, value: Any) -> NSMutableAttributedString {
    
        // 문자열을 속성 문자열로 변환
        let attributedString = NSMutableAttributedString(string: self)
        
        // 문자열의 길이 확인
        let length = self.count
        
        var range = NSRange(location: 0, length: length)
        var rangeArray = [NSRange]()

        // 문자열에서 특정 문자열의 위치 찾기
        while range.location != NSNotFound {
            range = (attributedString.string as NSString).range(of: searchString, options: .caseInsensitive, range: range)
            rangeArray.append(range)

            if range.location != NSNotFound {
                range = NSRange(location: range.location + range.length, length: self.count - (range.location + range.length))
            }
        }

        // 찾은 범위의 문자열에 속성 추가
        rangeArray.forEach {
            attributedString.addAttribute(key, value: value, range: $0)
        }

        return attributedString
    }
}
