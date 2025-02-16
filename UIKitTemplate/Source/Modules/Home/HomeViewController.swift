import Cartography
import RxCocoa
import RxFeedback
import RxSwift
import UIKit

class HomeViewController: UIViewController {

    private let disposeBag = DisposeBag()

    typealias State = Int
            
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        
        self.prepareLayout()

        enum Event {
            case increment
            case decrement
        }

        Observable.system(
            initialState: 0,
            reduce: { state, event -> State in
                switch event {
                case .increment:
                    return state + 1
                case .decrement:
                    return state - 1
                }
            },
            scheduler: MainScheduler.instance,
            feedback: bind(self) { owner, state -> Bindings<Event> in
                let subscriptions = [
                    state.map(String.init).bind(to: owner.label.rx.text)
                ]

                let events = [
                    owner.plus.rx.tap.map { Event.increment },
                    owner.minus.rx.tap.map { Event.decrement }
                ]

                return Bindings(subscriptions: subscriptions, events: events)
            }
        )
        .subscribe()
        .disposed(by: disposeBag)
    }

    private func prepareLayout() {
        let buttonContainer = UIView()
        buttonContainer.addSubviews(minus, plus)

        Cartography.constrain(buttonContainer, minus, plus) { container, minus, plus in
            align(centerY: container, minus, plus)
            align(top: container, minus, plus)
            align(bottom: container, minus, plus)
            minus.trailing == plus.leading
            minus.leading == container.leading
            plus.trailing == container.trailing
        }
        
        view.addSubviews(label, buttonContainer)
        Cartography.constrain(view, label, buttonContainer) { view, label, buttons in
            align(centerX: label, buttons, view)
            align(centerY: label, view)
            label.bottom == buttons.top - 8
        }
    }
    
    // MARK: - Views
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 72)
        return label
    }()
    
    lazy var minus: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "minus.circle",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        let button = UIButton(configuration: config)
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var plus: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "plus.circle",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()
}
