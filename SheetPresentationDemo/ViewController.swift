import Combine
import UIKit

class Counter {
    @Published var numberOfColorViewControllerInstances = 0
    static let shared = Counter()
}

final class ViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    var colorVisible = false
    var prefersGrabberVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        let label = UILabel()
        label.text = "Number of ColorViewController instances: \(Counter.shared.numberOfColorViewControllerInstances)"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(toggleChanged), for: .primaryActionTriggered)
        view.addSubview(toggle)

        let descriptionLabel = UILabel()
        descriptionLabel.text = "prefersGrabberVisible"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toggle.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            toggle.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            descriptionLabel.centerYAnchor.constraint(equalTo: toggle.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: toggle.trailingAnchor, constant: 20),
        ])
        Counter.shared
            .$numberOfColorViewControllerInstances
            .receive(on: DispatchQueue.main)
            .sink { value in
                label.text = "Number of ColorViewController instances: \(value)"
            }
            .store(in: &cancellables)
    }

    @objc private func toggleChanged(toggle: UISwitch) {
        prefersGrabberVisible = toggle.isOn
    }

    @objc private func tapped() {
        if colorVisible {
            presentedViewController?.dismiss(animated: true)
            colorVisible = false
            return
        }
        let color = ColorViewController()
        if let sheet = color.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = prefersGrabberVisible
        }
        present(color, animated: true)
        colorVisible = true
    }
}

final class ColorViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        Counter.shared.numberOfColorViewControllerInstances += 1
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("ColorViewController deinit")
        Counter.shared.numberOfColorViewControllerInstances -= 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    @objc private func tapped() {
        dismiss(animated: true)
    }
}
