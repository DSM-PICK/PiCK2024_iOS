import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import DesignSystem

public class OutingPassViewController: BaseViewController<OutingPassViewModel> {
    
    private let outingPassRelay = PublishRelay<Void>()
    
    private let navigationTitleLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let userInfoLabel = UILabel().then {
        $0.textColor = .neutral100
        $0.font = .heading6M
    }
    private let outingTimeLabel = UILabel().then {
        $0.text = "외출 시간"
        $0.textColor = .neutral400
        $0.font = .label2
    }
    private let outingTimeRangeLabel = PiCKPaddingLabel().then {
        $0.textColor = .neutral100
        $0.font = .subTitle3M
        $0.backgroundColor = .primary1200
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    private let outingReasonLabel = UILabel().then {
        $0.text = "사유"
        $0.textColor = .neutral400
        $0.font = .label2
    }
    private let outingReasonDescriptionLabel = PiCKPaddingLabel().then {
        $0.textColor = .neutral100
        $0.font = .subTitle3M
        $0.backgroundColor = .primary1200
        $0.layer.cornerRadius = 4
        $0.numberOfLines = 0
        $0.clipsToBounds = true
    }
    private let approvedTeacherLabel = UILabel().then {
        $0.text = "확인 교사"
        $0.textColor = .neutral400
        $0.font = .label2
    }
    private let approvedTeacherNameLabel = PiCKPaddingLabel().then {
        $0.textColor = .neutral100
        $0.font = .subTitle3M
        $0.backgroundColor = .primary1200
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    private let backgroundImage = UIImageView(image: .outingPassBackgroundIamge)

    public override func bindAction() {
        outingPassRelay.accept(())
    }
    public override func bind() {
        let input = OutingPassViewModel.Input(
            outingPassLoad: outingPassRelay.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.outingPassData.asObservable()
            .subscribe(
                onNext: { data in
                    if data.num ?? 0 < 10 {
                        self.userInfoLabel.text = "\(data.grade ?? 0)\(data.classNum ?? 0)0\(data.num ?? 0) \(data.userName)"
                    } else {
                        self.userInfoLabel.text = "\(data.grade ?? 0)\(data.classNum ?? 0)\(data.num ?? 0) \(data.userName)"
                    }

                    if data.end?.isEmpty == false {
                        self.outingTimeRangeLabel.text = "\(data.start ?? "") ~ \(data.end ?? "")"
                        self.navigationTitleLabel.text = "외출증"
                        self.navigationItem.titleView = self.navigationTitleLabel
                        self.userInfoLabel.text = "\(data.schoolNum ?? 0000) \(data.userName)"
                    } else {
                        self.outingTimeRangeLabel.text = "\(data.startTime ?? "")"
                        self.navigationTitleLabel.text = "조기귀가증"
                        self.navigationItem.titleView = self.navigationTitleLabel
                    }

                    self.outingReasonDescriptionLabel.text = data.reason
                    self.approvedTeacherNameLabel.text = "\(data.teacherName) 선생님"
                }
            )
            .disposed(by: disposeBag)
    }
    public override func addView() {
        [
            userInfoLabel,
            outingTimeLabel,
            outingTimeRangeLabel,
            outingReasonLabel,
            outingReasonDescriptionLabel,
            approvedTeacherLabel,
            approvedTeacherNameLabel,
            backgroundImage
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        userInfoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.left.equalToSuperview().inset(24)
        }
        outingTimeLabel.snp.makeConstraints {
            $0.top.equalTo(userInfoLabel.snp.bottom).offset(32)
            $0.left.equalToSuperview().inset(24)
        }
        outingTimeRangeLabel.snp.makeConstraints {
            $0.top.equalTo(outingTimeLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        outingReasonLabel.snp.makeConstraints {
            $0.top.equalTo(outingTimeRangeLabel.snp.bottom).offset(32)
            $0.left.equalToSuperview().inset(24)
        }
        outingReasonDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(outingReasonLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview().inset(24)
        }
        approvedTeacherLabel.snp.makeConstraints {
            $0.top.equalTo(outingReasonDescriptionLabel.snp.bottom).offset(32)
            $0.left.equalToSuperview().inset(24)
        }
        approvedTeacherNameLabel.snp.makeConstraints {
            $0.top.equalTo(approvedTeacherLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        backgroundImage.snp.makeConstraints {
            $0.top.equalTo(approvedTeacherNameLabel.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(68)
        }
    }
    
}
