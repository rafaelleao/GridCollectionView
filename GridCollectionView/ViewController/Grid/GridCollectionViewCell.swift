import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    static let identifier = "GridCollectionViewCell"
    var viewModel: GridCellViewModel!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var debugLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor

        textView.delegate = self
        textView.text = viewModel.gridCell.text

        debugLabel.isHidden = !viewModel.debugEnabled
        if viewModel.debugEnabled {
            debugLabel.text = "(\(viewModel.gridCell.column):\(viewModel.gridCell.row)) \(self.frame.size.width)x\(self.frame.size.height)"
        }

        let selected = viewModel.gridCell.selected
        backgroundColor = selected ? .lightGray : .none
    }
}

extension GridCollectionViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.gridCell.text = textView.text
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
   }
}
