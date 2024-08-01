import Foundation
import UIKit

import DesignSystem

public enum SubjectImageType: String {
    
    //MARK: 일반과목
    case creative = "창체"
    case english1 = "영어"
    case english2 = "영어Ⅰ"
    
    case koreaHistory = "한국사"
    
    case korean1 = "국어"
    case korean2 = "문학"
    
    case math1 = "수학"
    case math2 = "수학Ⅰ"
    case math3 = "확률과 통계"
    
    case science = "통합과학"
    case society = "통합사회"
    
    case music = "음악"
    case art = "미술"
    case pe1 = "체육"
    case pe2 = "운동과 건강"
    case pe3 = "스포츠 생활"
    
    case job1 = "성공적인 직업생활"
    case job2 = "진로와 직업"
    
    case army = "군대 윤리"
    case dream = "진로활동"
    case club = "동아리활동"
    
    //MARK: 공통과정
    case c = "프로그래밍"
    case computerStructrue = "컴퓨터 구조"
    case dataStructure = "자료구조"
    case baseWeb = "웹프로그래밍기초"
    case aiBase = "인공지능프로그래밍"
    
    //MARK: 공통 전공 과목
    case dataBase = "DB 프로그래밍"
    case os = "운영체제"
    case network = "컴퓨터 네트워크"
    
    //MARK: SW 개발과
    case server = "서버 프로그래밍"
    case web1 = "웹프로그래밍"
    case web2 = "프론트엔드 프로그래밍"
    case java = "자바 프로그래밍"
    case project1 = "프로젝트실무Ⅰ"
    case project2 = "프로젝트실무Ⅱ"
    
    //MARK: 임베디드 SW과
    case linux1 = "리눅스 시스템 프로그래밍"
    case linux2 = "임베디드 리눅스 프로그래밍"
    case pcb = "정보통신기기 PCB보드 개발"
    case processor1 = "마이크로프로세서 제어"
    case processor2 = "마이크로프로세서 응용"
    case embeddedSystem = "임베디드 시스템"
    case embeddedOS = "임베디드 실시간 운영체제"
    case physicalComputing = "인공지능과 피지컬컴퓨팅"
    case firmware = "정보통신기기 펌웨어구현"
    case electric = "전기・전자 기초"
    
    //MARK: AI & 정보보안과
    case ai1 = "인공지능론"
    case ai2 = "인공지능 활용"
    case bigData = "빅데이터 분석"
    case hacking = "해킹"
    case forensic = "디지털 포렌식"
    
    //MARK: 3학년
    case swEngineering = "소프트웨어공학 실무"
    case swManage1 = "응용SW 운영관리"
    case swMange2 = "응용SW 변경관리"
    case algorithm = "알고리즘실무"
    case economy = "실용 경제"
}

extension SubjectImageType {
    func toImage() -> UIImage {
        switch self {
                //MARK: 일반과목
            case .creative:
                return .creative
            case .english1, .english2:
                return .english
            case .koreaHistory:
                return .koreaHistory
            case .korean1, .korean2:
                return .korean
            case .math1, .math2, .math3:
                return .math
            case .science:
                return .science
            case .society:
                return .society
            case .music:
                return .music
            case .pe1, .pe2, .pe3:
                return .pe
            case .art:
                return .art
            case .job1, .job2:
                return .job
            case .economy:
                return .economy
            case .army:
                return .army
                //MARK: 공통 전공 과목
            case .c:
                return .c
            case .aiBase:
                return .ai
            case .computerStructrue, .os:
                return .computerStructrue
            case .dataBase:
                return .dataBase
            case .dataStructure:
                return .dataStructure
            case .baseWeb:
                return .web
                
                //MARK: SW 개발과
            case .server, .web1, .web2:
                return .web
            case .java:
                return .java
            case .algorithm:
                return .algorithm
            case .project1, .project2:
                return .project
                
                //MARK: 임베디드 SW과
            case .processor1, .processor2:
                return .processor
            case .pcb, .embeddedSystem:
                return .pcb
            case .linux1, .linux2:
                return .linux
            case .embeddedOS:
                return .pcb
            case .firmware:
                return .pcb
            case .physicalComputing:
                return .ai
            case .electric:
                return .forensic
                
                //MARK: AI & 정보보안과
            case .ai1, .ai2:
                return .ai
            case .bigData:
                return .bigData
            case .hacking:
                return .hacking
            case .forensic:
                return .forensic
            case .swEngineering:
                return .swEngineering
            case .swManage1, .swMange2:
                return .swManage
            default:
            return .web
        }
    }
}
