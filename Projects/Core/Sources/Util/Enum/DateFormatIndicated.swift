import Foundation

public enum DateFormatIndicated: String {
    ///M월 d일 (E)
    case dateAndDays = "M월 d일 (E)"
    ///yyyy-MM-dd
    case fullDate = "yyyy-MM-dd"
    ///yyyy년 MM월
    case yearsAndMonthKor = "yyyy년 MM월"
    ///yyyy
    case year = "yyyy"
    ///MMMM
    case fullMonth = "MMMM"
    ///M월
    case month = "M월"
    ///d
    case day = "d"
    ///M월 d일
    case monthAndDay = "M월 d일"
    ///yyyy년 M월 d일
    case fullDateKor = "yyyy년 M월 d일"
}
