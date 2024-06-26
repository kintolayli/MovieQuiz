import UIKit


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - variables
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private lazy var alertPresenter = ResultAlertPresenter(
        viewController: self
    )
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - Actions
    
    func showLoadingIndicator() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.style = .large
        self.activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(
            accessibilityId: "ErrorAlert", title: "Ошибка",
            message: message, buttonText: "Попробовать еще раз") { [ weak self ] in
                guard let self = self else { return }
                
                presenter.restartGame()
            }
        
        alertPresenter.show(in: self, model: model)
    }
    
    // MARK: - Methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func enableOrDisableButtonsToggle() {
        for button in [yesButton, noButton] {
            button?.isEnabled.toggle()
        }
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
        let model = AlertModel(accessibilityId: "EndGameAlert",
                               title: result.title,
                               message: result.text,
                               buttonText: result.buttonText,
                               completion: presenter.restartGame)
        
        alertPresenter.show(in: self, model: model)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
}
