import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import Lottie

import AppNetwork
import Core
import DesignSystem

public class LoginViewController: BaseViewController<LoginViewModel> {
    
    private let pickLogoImageView = UIImageView(image: .PiCKLogo)
    private let explainLabel = UILabel().then {
        $0.text = "스퀘어 계정으로 로그인 해주세요."
        $0.textColor = .neutral400
        $0.font = .body2
    }
    private let idTextField = PiCKTextField().then {
        $0.placeholder = "아이디"
        $0.textContentType = .username
    }
    private let passwordTextField = PiCKTextField().then {
        $0.placeholder = "비밀번호"
        $0.textContentType = .password
        $0.isSecurity = true
    }
    private let loginButton = UIButton(type: .system).then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .buttonS
        $0.backgroundColor = .primary400
        $0.layer.cornerRadius = 4
    }
    
    public override func configureNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    public override func bind() {
        let input = LoginViewModel.Input(
            idText: idTextField.rx.text.orEmpty.asObservable(),
            passwordText: passwordTextField.rx.text.orEmpty.asObservable(),
            loginButtonSignal: loginButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.idErrorDescription.asObservable()
            .bind(to: self.idTextField.errorMessage)
            .disposed(by: disposeBag)
        
        output.passwordErrorDescription.asObservable()
            .bind(to: self.passwordTextField.errorMessage)
            .disposed(by: disposeBag)
    }
    public override func addView() {
        [
            pickLogoImageView,
            explainLabel,
            idTextField,
            passwordTextField,
            loginButton
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        pickLogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(184)
            $0.left.equalToSuperview().inset(24)
            $0.width.equalTo(120)
            $0.height.equalTo(68)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(pickLogoImageView.snp.bottom).offset(3)
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
