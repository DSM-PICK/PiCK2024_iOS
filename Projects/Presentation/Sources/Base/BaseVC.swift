import UIKit

import RxSwift

public class BaseVC<ViewModel: ViewModelType>: UIViewController {
    
    public var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        attribute()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addView()
        setLayout()
    }

    @objc private func dismissKeyboard(sender: UIView) {
        view.endEditing(true)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    public func attribute() {}
    public func bind() {}
    public func addView() {}
    public func setLayout() {}
    
}
