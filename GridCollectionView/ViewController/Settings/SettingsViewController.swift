import UIKit
import Combine

protocol SettingsViewControllerDelegate: AnyObject {
    func showGrid(settings: GridSettings)
}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsViewControllerDelegate?
    var viewModel: SettingsViewModel!
    private var bindings: [AnyCancellable] = []

    @IBOutlet private var rowsLabel, columnsLabel, widthLabel, heightLabel: UILabel!
    @IBOutlet private var rowsStepper, columnsStepper, widthStepper, heightStepper: UIStepper!

    static func instantiate() -> SettingsViewController {
        let storyboard = UIStoryboard(name: "SettingsViewController", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! SettingsViewController
        viewController.viewModel = SettingsViewModel()
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSteppers()
        setUpBindings()
    }

    private func configureSteppers() {
        for stepper in [columnsStepper, rowsStepper] {
            stepper?.minimumValue = Double(viewModel.minItems)
            stepper?.maximumValue = Double(viewModel.maxItems)
        }
        columnsStepper.value = Double(viewModel.columns)
        rowsStepper.value = Double(viewModel.rows)

        for stepper in [heightStepper, widthStepper] {
            stepper?.stepValue = viewModel.step
        }
        widthStepper.minimumValue = Double(viewModel.minSize.width)
        heightStepper.maximumValue = Double(viewModel.minSize.height)

        widthStepper.value = Double(viewModel.width)
        heightStepper.value = Double(viewModel.height)

        for stepper in [columnsStepper, rowsStepper, heightStepper, widthStepper] {
            stepper?.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        }
    }

    private func setUpBindings() {
        viewModel.$columns.sink { [weak self] value in
            self?.columnsLabel.text = "Number of columns: \(value)"
        }.store(in: &bindings)

        viewModel.$rows.sink { [weak self] value in
            self?.rowsLabel.text = "Number of row: \(value)"
        }.store(in: &bindings)

        viewModel.$width.sink { [weak self] value in
            self?.widthLabel.text = "Column width: \(value)"
        }.store(in: &bindings)

        viewModel.$height.sink { [weak self] value in
            self?.heightLabel.text = "Row height: \(value)"
        }.store(in: &bindings)
    }

    @objc
    func stepperValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        if sender == columnsStepper {
            viewModel.columns = value
        }
        if sender == rowsStepper {
            viewModel.rows = value
        }
        if sender == widthStepper {
            viewModel.width = value
        }
        if sender == heightStepper {
            viewModel.height = value
        }
    }

    @IBAction func showGrid() {
        delegate?.showGrid(settings: viewModel.gridSettings())
    }
}
