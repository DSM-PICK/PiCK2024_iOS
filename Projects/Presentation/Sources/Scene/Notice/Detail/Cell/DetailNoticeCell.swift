import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class DetailNoticeCell: UITableViewCell {
    
    static let identifier = "detailNoticeCellID"
    
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
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(contentLabel)
        self.isUserInteractionEnabled = false
        
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
    

}
