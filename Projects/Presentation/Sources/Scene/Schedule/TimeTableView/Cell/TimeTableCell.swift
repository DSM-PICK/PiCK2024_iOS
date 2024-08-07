import UIKit

import SnapKit
import Then

import Kingfisher
import SVGKit

import Core
import DesignSystem

public class TimeTableCell: BaseCollectionViewCell {
    
    static let identifier = "timeTableCellID"
    
    private var periodLabel = UILabel().then {
        $0.textColor = .primary50
        $0.font = .subTitle3B
    }
    private var subjectImageView = UIImageView()
    private var subjectLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    private var timeLabel = UILabel().then {
        $0.textColor = .neutral300
        $0.font = .caption3
    }
    
    public func setup(
        period: Int,
        subjectImage: String,
        subjectName: String,
        time: String
    ) {
        self.periodLabel.text = "\(period)교시"
        self.subjectLabel.text = subjectName
        self.timeLabel.text = time

        let url = URL(string: subjectImage)
        self.subjectImageView.kf.setImage(
            with: url,
            options: [.processor(SVGProcessor())]
        )
//        self.subjectImageView.load(url: url!)
    }
    
    public override func layout() {
        [
            periodLabel,
            subjectImageView,
            subjectLabel,
            timeLabel
        ].forEach { contentView.addSubview($0) }
        
        periodLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        subjectImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(periodLabel.snp.right).offset(24)
            $0.width.height.equalTo(32)
        }
        subjectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.left.equalTo(subjectImageView.snp.right).offset(24)
        }
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(subjectLabel.snp.bottom)
            $0.left.equalTo(subjectImageView.snp.right).offset(24)
        }
    }
    
}



public struct SVGProcessor: ImageProcessor {
    public var identifier: String = "com.PrintingAlley"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }

    public init() {

    }
}



extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else {
                print("Failed to load data from URL: \(url)")
                return
            }
            
            if url.pathExtension.lowercased() == "svg" {
                guard let svgImage = SVGKImage(data: data) else {
                    print("Failed to create SVGKImage")
                    return
                }
                
                DispatchQueue.main.async {
                    svgImage.size = self?.bounds.size ?? CGSize(width: 200, height: 200)
                    self?.image = svgImage.uiImage
                }
            } else {
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
        }
    }
}
