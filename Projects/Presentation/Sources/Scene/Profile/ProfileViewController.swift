import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class ProfileViewController: BaseVC<ProfileViewModel>, Stepper {
    
    private let disposeBag = DisposeBag()
    public let steps = PublishRelay<Step>()
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "my"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 40
    }
    private let cameraIconImageView = UIImageView(image: .cameraIcon)
    private let profileImageChangeButton = UIButton(type: .system).then {
        $0.setTitle("변경하기", for: .normal)
        $0.setTitleColor(.neutral100, for: .normal)
        $0.titleLabel?.font = .body2
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
        $0.text = "조영준"
        $0.textColor = .neutral50
        $0.font = .body2
    }
    private let userBirthDateLabel = UILabel().then {
        $0.text = "2007년 3월 12일"
        $0.textColor = .neutral50
        $0.font = .body2
    }
    private let userStudentIDLabel = UILabel().then {
        $0.text = "1학년 1반 15번"
        $0.textColor = .neutral50
        $0.font = .body2
    }
    private let userIDLabel = UILabel().then {
        $0.text = "cyj513"
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
    
    public override func attribute() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func bind() {
        logOutButton.rx.tap
            .bind { [weak self] in
                self?.steps.accept(PiCKStep.logoutAlertRequired)
            }.disposed(by: disposeBag)
    }
    public override func addView() {
        [
            profileImageView,
            profileImageChangeButton,
            userInfoLabelStackView,
            userInfoStackView,
            lineView,
            accountManagementLabel,
            accountManagementExplainLabel,
            logOutButton
        ].forEach { view.addSubview($0) }
        
        profileImageView.addSubview(cameraIconImageView)
        
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
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(118)
            $0.width.height.equalTo(80)
        }
        cameraIconImageView.snp.makeConstraints  {
            $0.top.left.equalToSuperview().inset(56)
        }
        profileImageChangeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
        }
        userInfoLabelStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageChangeButton.snp.bottom).offset(28)
            $0.left.equalToSuperview().inset(24)
        }
        userInfoStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageChangeButton.snp.bottom).offset(28)
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
    }
    
}
