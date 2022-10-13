import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    @objc private func tapped() {
        let nav = UINavigationController(rootViewController: MyViewController())
        present(nav, animated: true)
    }
}

final class MyViewController: UIViewController {
    deinit {
        print("MyViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    var colorVisible = false

    @objc private func tapped() {

        if colorVisible {
//            presentedViewController?.sheetPresentationController?.prefersGrabberVisible = false
            presentedViewController?.dismiss(animated: true)
//            dismiss(animated: true)
            colorVisible = false
            return
        }

        let color = ColorViewController()
        color.isModalInPresentation = true
        if let sheet = color.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
        }
        present(color, animated: true)

        colorVisible = true
    }
}

final class ColorViewController: UIViewController {
    deinit {
        print("deinit")
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
