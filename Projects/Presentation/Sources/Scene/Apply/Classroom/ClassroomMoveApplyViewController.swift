import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ClassroomMoveApplyViewController: BaseViewController<ClassroomMoveApplyViewModel> {
    
    private let floorText = BehaviorRelay<Int>(value: 1)
    private let classroomNameText = BehaviorRelay<String>(value: "")
    private lazy var currentFloorClassroomArray = BehaviorRelay<[String]>(value: firstFloorClassroomArray)
    
    private lazy var firstFloorClassroomArray = [
        "산학협력부", "새롬홀", "무한 상상실", "청죽관", "탁구실", "운동장"
    ]
    private lazy var secondFloorClassroomArray = [
        "3-1", "3-2", "3-3", "3-4", "세미나실 2-1", "세미나실 2-2", "세미나실 2-3", "SW 1실", "SW 2실", "SW 3실",
        "본부교무실", "제 3교무실", "카페테리아", "창조실", "방송실", "진로 상담실", "여자 헬스장"
    ]
    private lazy var thirdFloorClassroomArray = [
        "2-1", "2-2", "2-3", "2-4", "세미나실 3-1", "세미나실 3-2", "세미나실 3-3", "세미나실 3-4",
        "보안 1실", "보안 2실", "제 2교무실", "그린존", "남자 헬스장"
    ]
    private lazy var fourthFloorClassroomArray = [
        "1-1", "1-2", "1-3", "1-4", "세미나실 4-1", "세미나실 4-2", "세미나실 4-3", "세미나실 4-4",
        "임베 1실", "임베 2실", "제 1교무실"
    ]
    private lazy var fifthFloorClassroomArray = [
        "음악실", "상담실", "수학실", "과학실", "음악 준비실"
    ]
    private lazy var floorButtonArray = [
        firstFloorButton,
        secondFloorButton,
        thirdFloorButton,
        fourthFloorButton,
        fifthFloorButton
    ]
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "교실 이동"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let classroomMoveApplyButton = PiCKNavigationApplyButton(type: .system)
    private let floorButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
        $0.backgroundColor = .clear
    }
    private let firstFloorButton = PiCKFloorButton(type: .system).then {
        $0.setTitle("1층", for: .normal)
        $0.tag = 1
        $0.isSelected = true
    }
    private let secondFloorButton = PiCKFloorButton(type: .system).then {
        $0.setTitle("2층", for: .normal)
        $0.tag = 2
    }
    private let thirdFloorButton = PiCKFloorButton(type: .system).then {
        $0.setTitle("3층", for: .normal)
        $0.tag = 3
    }
    private let fourthFloorButton = PiCKFloorButton(type: .system).then {
        $0.setTitle("4층", for: .normal)
        $0.tag = 4
    }
    private let fifthFloorButton = PiCKFloorButton(type: .system).then {
        $0.setTitle("5층", for: .normal)
        $0.tag = 5
    }
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 12
        $0.minimumInteritemSpacing = 15
        $0.itemSize = .init(width: self.view.frame.width / 4, height: 36)
    }
    private lazy var floorCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.bounces = false
        $0.backgroundColor = .white
        $0.register(FloorCell.self, forCellWithReuseIdentifier: FloorCell.identifier)
    }
    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: classroomMoveApplyButton)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    public override func bind() {
        let input = ClassroomMoveApplyViewModel.Input(
            floorText: floorText.asObservable(),
            classroomNameText: classroomNameText.asObservable(),
            classroomMoveApplyButton: classroomMoveApplyButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.isApplyButtonEnable.asObservable()
            .subscribe(
                onNext: { [self] status in
                    classroomMoveApplyButton.isEnabled = status
                }
            )
            .disposed(by: disposeBag)
        
        currentFloorClassroomArray
            .bind(to: floorCollectionView.rx.items(
                cellIdentifier: FloorCell.identifier,
                cellType: FloorCell.self
            )) { row, element, cell in
                cell.classroomLabel.text = element
            }
            .disposed(by: disposeBag)
        
        floorCollectionView.rx.itemSelected
            .subscribe(
                onNext: { [self] index in
                    classroomNameText.accept(currentFloorClassroomArray.value[index.row])
                    print(classroomNameText.value)
                    print(floorText.value)
                }
            )
            .disposed(by: disposeBag)
        
        floorButtonArray.forEach { button in
            button.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.clickRadioButtons(selectedButton: button)
                    self?.floorText.accept(button.tag)
                    self?.classroomNameText.accept("")
                    self?.floorCollectionView.reloadData()
                    
                    switch button.tag {
                        case 1:
                            self?.currentFloorClassroomArray.accept(self?.firstFloorClassroomArray ?? [])
                            return
                        case 2:
                            self?.currentFloorClassroomArray.accept(self?.secondFloorClassroomArray ?? [])
                            return
                        case 3:
                            self?.currentFloorClassroomArray.accept(self?.thirdFloorClassroomArray ?? [])
                            return
                        case 4:
                            self?.currentFloorClassroomArray.accept(self?.fourthFloorClassroomArray ?? [])
                            return
                        case 5:
                            self?.currentFloorClassroomArray.accept(self?.fifthFloorClassroomArray ?? [])
                            return
                        default:
                            return
                    }
                }).disposed(by: disposeBag)
        }
    }
    public override func addView() {
        [
            floorButtonStackView,
            floorCollectionView
        ].forEach { view.addSubview($0) }
        
        [
            firstFloorButton,
            secondFloorButton,
            thirdFloorButton,
            fourthFloorButton,
            fifthFloorButton
        ].forEach { floorButtonStackView.addArrangedSubview($0) }
    }
    public override func setLayout() {
        floorButtonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(114)
            $0.left.equalToSuperview().inset(24)
        }
        floorCollectionView.snp.makeConstraints {
            $0.top.equalTo(floorButtonStackView.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
    private func clickRadioButtons(selectedButton: PiCKFloorButton) {
        guard !selectedButton.isSelected else { return }
        
        selectedButton.isSelected.toggle()
        
        floorButtonArray.filter { $0 != selectedButton }.forEach { button in
            button.isSelected = false
        }
    }
    
}
