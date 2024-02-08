import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class DetailNoticeViewController: BaseVC<DetailNoticeViewModel> {
    
    private lazy var navigationTitleLabel = UILabel().then {
        $0.text = "[중요] 오리엔테이션날 일정 안내"
        $0.textColor = .neutral50
        $0.font = .subTitle1M
    }
    private let titleLabel = UILabel().then {
        $0.text = "[중요] 오리엔테이션날 일정 안내"
        $0.textColor = .neutral50
        $0.font = .subTitle2M
    }
    private let dateLabel = UILabel().then {
        $0.text = "2024-02-09"
        $0.textColor = .neutral400
        $0.font = .caption2
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .neutral900
    }
    private let contentLabel = UILabel().then {
        $0.text = """
        신입생 오리엔테이션 책자에 있는 입학전 과제의 양식입니다.
        첨부파일을 다운받아 사용하시고,
        영어와 전공은 특별한 양식이 없으니 내용에 맞게 작성하여 학교 홈
        페이지
        에 제출하시기 바랍니다.
         
        ■ 과제 제출 마감: 2024년 2월 20일 화요일
        ■ 학교 홈페이지 학생 회원가입 -> 학교 담당자가 승인
        ■ 학교 홈페이지 로그인 후 [과제제출 – 신입생 - 각 교과] 게시판
        에 제출
        ■ 과제 중 자기소개 PPT는 첨부한 파일을 참고하되, 자유롭게 만들
        어도
        됩니다.
        """
        $0.textColor = .neutral50
        $0.font = .caption2
        $0.numberOfLines = 0
    }
    
    public override func addView() {
        [
            navigationTitleLabel,
            titleLabel,
            dateLabel,
            lineView,
            contentLabel
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        navigationTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(55)
            $0.left.right.equalToSuperview().inset(95)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(119)
            $0.left.equalToSuperview().inset(24)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(24)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(5)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    
}
