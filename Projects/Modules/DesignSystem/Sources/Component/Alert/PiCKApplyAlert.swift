import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core

public class PiCKApplyAlert: UIViewController, Stepper {
    
    public var steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    
    private var clickToAction: () -> Void = {}
    
    private let alertView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    private let questionLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let checkButton = UIButton(type: .system).then {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .buttonS
        $0.backgroundColor = .primary600
        $0.layer.cornerRadius = 4
    }    
    public init(
        questionText: String,
        checkButtonTitle: String,
        clickToAction: @escaping () -> Void
    ) {
        super.init(nibName: nil, bundle: nil)
        self.questionLabel.text = questionText
        self.checkButton.setTitle(checkButtonTitle, for: .normal)
        self.clickToAction = clickToAction
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        bind()
    }
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addView()
        setLayout()
    }
    
    private func attribute() {
        view.backgroundColor = .placeholderText
    }
    private func bind() {
        checkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.clickToAction()
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    private func addView() {
        view.addSubview(alertView)
        
        [
            questionLabel,
            checkButton
        ].forEach { alertView.addSubview($0) }
    }
    private func setLayout() {
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(132)
        }
        questionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(24)
        }
        checkButton.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
    }
    
}
