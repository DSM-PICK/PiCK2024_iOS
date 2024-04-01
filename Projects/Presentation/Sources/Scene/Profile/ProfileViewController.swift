import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ProfileViewController: BaseViewController<ProfileViewModel> {
    
    private let viewWillAppearRelay = PublishRelay<Void>()
    private let logoutAlertRelay = PublishRelay<Void>()
    
    private let keychain = KeychainStorage.shared
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "my"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let userInfoLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.backgroundColor = .clear
        $0.distribution = .fillEqually
    }
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.textColor = .neutral200
        $0.font = .body2
    }
    private let birthDateLabel = UILabel().then {
        $0.text = "생년월일"
        $0.textColor = .neutral200
        $0.font = .body2
    }
    private let studentIDLabel = UILabel().then {
        $0.text = "학번"
        $0.textColor = .neutral200
        $0.font = .body2
    }
    private let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.textColor = .neutral200
        $0.font = .body2
    }
    private let userInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.backgroundColor = .clear
        $0.alignment = .trailing
        $0.distribution = .fillEqually
    }
    private let userNameLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .body2
    }
    private let userBirthDateLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .body2
    }
    private let userStudentIDLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .body2
    }
    private let userIDLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .body2
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .neutral700
    }
    private let accountManagementLabel = UILabel().then {
        $0.text = "계정관리"
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    private let accountManagementExplainLabel = UILabel().then {
        $0.text = "기기내 계정에서 로그아웃 할 수 있어요."
        $0.textColor = .neutral300
        $0.font = .body3
    }
    private let logOutButton = UIButton(type: .system).then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .body3
        $0.backgroundColor = .primary1200
        $0.layer.cornerRadius = 8
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    private let withdrawalButton = UIButton(type: .system).then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.setTitleColor(.red, for: .normal)
        $0.titleLabel?.font = .body3
        $0.backgroundColor = .primary1200
        $0.layer.cornerRadius = 8
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }

    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func bindAction() {
        viewWillAppearRelay.accept(())
    }
    public override func bind() {
        let input = ProfileViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            logoutDidClick: logoutAlertRelay.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.userProfileData.asObservable()
            .subscribe(
                onNext: { [self] data in
                    userNameLabel.text = data.name
                    userBirthDateLabel.text = data.birthDay
                    userStudentIDLabel.text = "\(data.grade)학년 \(data.classNum)반 \(data.num)번"
                    userIDLabel.text = data.accountID
                }
            )
            .disposed(by: disposeBag)
        
        logOutButton.rx.tap
            .subscribe(
                onNext: {
                    let logoutAlert = PiCKAlert(
                        questionText: "정말 로그아웃 하시겠습니까?",
                        cancelButtonTitle: "아니요",
                        checkButtonTitle: "예",
                        clickToAction: {
                            self.logoutAlertRelay.accept(())
                            self.keychain.removeKeychain()
                        }
                    )
                    logoutAlert.modalPresentationStyle = .overFullScreen
                    logoutAlert.modalTransitionStyle = .crossDissolve
                    self.present(logoutAlert, animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        withdrawalButton.rx.tap
            .subscribe(
                onNext: {
                    let logoutAlert = PiCKAlert(
                        questionText: "정말 회원탈퇴 하시겠습니까?",
                        cancelButtonTitle: "아니요",
                        checkButtonTitle: "예",
                        clickToAction: {
                            self.logoutAlertRelay.accept(())
                            self.keychain.removeKeychain()
                        }
                    )
                    logoutAlert.modalPresentationStyle = .overFullScreen
                    logoutAlert.modalTransitionStyle = .crossDissolve
                    self.present(logoutAlert, animated: true)
                }
            )
            .disposed(by: disposeBag)
        
    }
    public override func addView() {
        [
            userInfoLabelStackView,
            userInfoStackView,
            lineView,
            accountManagementLabel,
            accountManagementExplainLabel,
            logOutButton,
            withdrawalButton
        ].forEach { view.addSubview($0) }
        
        [
            nameLabel,
            birthDateLabel,
            studentIDLabel,
            idLabel
        ].forEach { userInfoLabelStackView.addArrangedSubview($0) }
        
        [
            userNameLabel,
            userBirthDateLabel,
            userStudentIDLabel,
            userIDLabel
        ].forEach { userInfoStackView.addArrangedSubview($0) }
    }
    public override func setLayout() {
        userInfoLabelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(122)
            $0.left.equalToSuperview().inset(24)
        }
        userInfoStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(122)
            $0.right.equalToSuperview().inset(24)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(userInfoLabelStackView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(5)
        }
        accountManagementLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(24)
        }
        accountManagementExplainLabel.snp.makeConstraints {
            $0.top.equalTo(accountManagementLabel.snp.bottom).offset(7)
            $0.left.equalToSuperview().inset(24)
        }
        logOutButton.snp.makeConstraints {
            $0.top.equalTo(accountManagementExplainLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
        withdrawalButton.snp.makeConstraints {
            $0.top.equalTo(logOutButton.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }
    
}
