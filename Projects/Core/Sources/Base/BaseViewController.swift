import UIKit

import SnapKit
import RxSwift
import RxCocoa

open class BaseViewController<ViewModel: BaseViewModel>: UIViewController {
    
    public let disposeBag = DisposeBag()
    public var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        attribute()
        bind()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addView()
        setLayout()
    }
    
    open func configureNavigationBar() {
        //네비게이션바 관련 코드를 설정하는 함수
    }
    open func attribute() {
        view.backgroundColor = .white
        //뷰 관련 코드를 설정하는 함수
    }
    open func bind() {
        //UI 바인딩을 설정하는 함수
    }
    open func addView() {
        //서브뷰를 구성하는 함수
    }
    open func setLayout() {
        //레이아웃을 설정하는 함수
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
