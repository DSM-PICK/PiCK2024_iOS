import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class LoginViewController: BaseViewController<LoginViewModel>, Stepper {
    
    public var steps = PublishRelay<Step>()
    
    private let pickLabel = UILabel().then {
        $0.text = "PiCK"
        $0.textColor = .primary300
        $0.font = .heading3
    }
    private let explainLabel = UILabel().then {
        $0.text = "스퀘어 계정으로 로그인 해주세요."
        $0.textColor = .neutral400
        $0.font = .body2
    }
    private let idTextField = PiCKTextField().then {
        $0.placeholder = "아이디"
    }
    private let passwordTextField = PiCKTextField().then {
        $0.placeholder = "비밀번호"
        $0.isSecurity = true
    }
    private let loginButton = PiCKLoginButton().then {
        $0.isEnabled = true//임시
    }

    public override func configureNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    public override func bind() {
        loginButton.rx.tap
            .bind(onNext: {
                self.steps.accept(PiCKStep.mainRequired)
            }).disposed(by: disposeBag)
    }
    public override func addView() {
        [
            pickLabel,
            explainLabel,
            idTextField,
            passwordTextField,
            loginButton
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        pickLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(184)
            $0.left.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(pickLabel.snp.bottom).offset(3)
            $0.left.equalToSuperview().inset(24)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(84)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(47)
        }
    }

}
