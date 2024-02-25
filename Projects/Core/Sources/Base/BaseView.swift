import UIKit

import RxSwift
import RxCocoa

open class BaseView: UIView {
    
    public let disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        bind()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        addView()
        setLayout()
    }
    
    open func attribute() {
        self.backgroundColor = .white
        //UIView에 관련된 설정을 하는 함수
    }
    open func bind() {
        //UIView의 버튼 동작을 설정하는 함수
    }
    open func addView() {
        //UIView의 서브뷰를 추가하는 함수
    }
    open func setLayout() {
        //UIView의 레이아웃을 설정하는 함수
    }

}
