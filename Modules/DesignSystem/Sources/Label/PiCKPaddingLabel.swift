import UIKit

public class PiCKPaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 10.0
    @IBInspectable var bottomInset: CGFloat = 10.0
    @IBInspectable var leftInset: CGFloat = 12.0
    @IBInspectable var rightInset: CGFloat = 12.0
 
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
    public override var bounds: CGRect {
        didSet { preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset) }
    }

}
