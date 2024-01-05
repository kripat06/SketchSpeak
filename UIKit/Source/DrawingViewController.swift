//
//  Created by Krish Patel on 4/14/23.
//
import CoreML
import CoreGraphics
import SafariServices
import UIKit
import AVFoundation

struct ButtonAudio {
    var utteranceB1 = "label"
}

public class DrawingViewController: UIViewController, DrawingViewDelegate {
    // MARK: - IBOutlets
    let mapping = EmojiMap()
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var buttonOneLabel: UILabel!
    @IBOutlet weak var buttonTwoLabel: UILabel!
    @IBOutlet weak var buttonThreeLabel: UILabel!
    @IBOutlet weak var buttonFourLabel: UILabel!
    var buttonOneText = "empty"
    var buttonTwoText = "empty"
    var buttonThreeText = "empty"
    var buttonFourText = "empty"

    @IBOutlet weak var canvasSize: NSLayoutConstraint!

    let synthesizer = AVSpeechSynthesizer()
    // MARK: - Private properties
    private let drawnImageClassifier = DrawnImageClassifier()
    private var labelNames: [String] = []
    private var currentPrediction: DrawnImageClassifierOutput? {
        didSet {
            if let currentPrediction = currentPrediction {
                
                // display top 5 scores
                let sorted = currentPrediction.category_softmax_scores.sorted { $0.value > $1.value }
                let top5 = sorted.prefix(5)
                resultsLabel.text = top5.map { $0.key }.joined(separator: ", ")
                buttonOneText = top5.map { $0.key }[0]
                buttonTwoText = top5.map { $0.key }[1]
                buttonThreeText = top5.map { $0.key }[2]
                buttonFourText = top5.map { $0.key }[3]
                var resultButtonOne = ""
                var resultButtonTwo = ""
                var resultButtonThree = ""
                var resultButtonFour = ""

                
                for match in mapping.getMatchesFor(buttonOneText) {
                    resultButtonOne+=match.emoji + "        "
                }
                for match in mapping.getMatchesFor(buttonTwoText) {
                    resultButtonTwo+=match.emoji + "        "
                }
                for match in mapping.getMatchesFor(buttonThreeText) {
                    resultButtonThree+=match.emoji + "        "
                }
                for match in mapping.getMatchesFor(buttonFourText) {
                    resultButtonFour+=match.emoji + "        "
                }
                buttonOneLabel.text = resultButtonOne
                buttonTwoLabel.text = resultButtonTwo
                buttonThreeLabel.text = resultButtonThree
                buttonFourLabel.text = resultButtonFour
                
                // check if it's correct
            }
            else {
                resultsLabel.text = "Waiting for drawing..."

            }
        }
    }
    
    
    // MARK: - View Controller Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // read labels
        if let path = Bundle.main.path(forResource: "labels", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let labelNames = data.components(separatedBy: .newlines).filter { $0.count > 0 }
                self.labelNames.append(contentsOf: labelNames)
            } catch {
                print("error loading labels: \(error)")
            }
        }
        
        // setup drawing view and start challenge
        drawingView.delegate = self
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // set stroke width to 4% of the width
        let strokeWidth = drawingView.bounds.width * 0.04
        drawingView.strokeWidth = strokeWidth
        
        // set size of canvas
        //canvasSize.constant = min(view.bounds.width, view.bounds.height) * 0.7
    }
    
    
    // MARK: - IBActions

    @IBAction func clear(_ sender: Any) {
        clearDrawingView()
    }

    @IBAction func buttonOne(_ sender: Any) {
        synthesizer.speak(AVSpeechUtterance(string: buttonOneText))
        
    }
    @IBAction func buttonTwo(_ sender: Any) {
        synthesizer.speak(AVSpeechUtterance(string: buttonTwoText))
    }
    @IBAction func buttonThree(_ sender: Any) {
        synthesizer.speak(AVSpeechUtterance(string: buttonThreeText))
    }
    @IBAction func buttonFour(_ sender: Any) {
        synthesizer.speak(AVSpeechUtterance(string: buttonFourText))
    }
    // MARK: - Game methods
    // MARK: - Delegate methods
    private func clearDrawingView() {
        // clear view and reset label
        drawingView.clear()
        currentPrediction = nil
    }
    
    public func didEndDrawing() {
        // get image and resize it
        let image = UIImage(view: drawingView)
        let resized = image.resize(newSize: CGSize(width: 28, height: 28))
        
        guard let pixelBuffer = resized.grayScalePixelBuffer() else {
            print("couldn't create pixel buffer")
            return
        }
        
        do {
            currentPrediction = try drawnImageClassifier.prediction(image: pixelBuffer)
        }
        catch {
            print("error making prediction: \(error)")
        }
    }
}

