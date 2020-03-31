//
//  OnboardingVC.swift
//  StayHome
//
//  Created by Enrico Castelli on 28/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController, TextPresenter, HealthProvider, StoreProvider {

    var nextButton = UIButton()
    var line: LineView?
    var field = UITextField()
    let textColor = UIColor.black.withAlphaComponent(0.8)
    var lastLabel: CAShapeLayer?
    var timer: Timer?
    @IBOutlet weak var imageView: UIImageView!
    
    var stepCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = addText("WELCOME TO", delay: 0, duration: 0.7, position: CGPoint(x: 50, y: imageView.frame.maxY), lineWidth: 0.5, font: Font.with(.hairline, 30), color: textColor)
        let _ = addText("THE LAZY", delay: 1, duration: 1, position: CGPoint(x: 70, y: view.center.y + 50), lineWidth: 1, font: Font.with(.hairline, 50), color: textColor)
        lastLabel = addText("APP", delay: 1.5, duration: 1, position: CGPoint(x: 70, y: view.center.y + 100), lineWidth: 1, font: Font.with(.hairline, 50), color: textColor)
        setButton()
        imageView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation(1.4)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func secondStep() {
        let label1 = addText("FIND  OUT  YOUR", delay: 0, duration: 0.7, position:
            CGPoint(x: 50, y: imageView.frame.maxY),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        let label2 = addText("LAZYNESS  LEVEL", delay: 0.5, duration: 0.7, position:
            CGPoint(x: 50, y: label1.frame.maxY + label1.path!.boundingBox.height + 5),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        let label3 = addText("AND  CHALLENGE", delay: 1, duration: 0.7, position:
            CGPoint(x: 50, y: label2.frame.maxY + label2.path!.boundingBox.height + 5),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        lastLabel = addText("YOUR  FRIENDS", delay: 1.5, duration: 0.7, position:
            CGPoint(x: 50, y: label3.frame.maxY + label3.path!.boundingBox.height + 5),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        startAnimation(1.2)
    }
    
    private func thirdStep() {
        let label1 = addText("WE  NEED  YOUR", delay: 0, duration: 0.7, position:
            CGPoint(x: 50, y: imageView.frame.maxY),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        let label2 = addText("PERMISSION", delay: 0.5, duration: 0.7, position:
            CGPoint(x: 50, y: label1.frame.maxY + label1.path!.boundingBox.height + 5),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        let label3 = addText("TO  CHECK  SOME", delay: 1, duration: 0.7, position:
            CGPoint(x: 50, y: label2.frame.maxY + label2.path!.boundingBox.height + 5),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        lastLabel = addText("DATA...", delay: 1.5, duration: 0.7, position:
            CGPoint(x: 50, y: label3.frame.maxY + label3.path!.boundingBox.height + 5),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        startAnimation(1.2)
    }
    
    private func fourthStep() {
        let label1 = addText("WHAT'S  YOUR", delay: 0, duration: 0.7, position:
            CGPoint(x: 50, y: imageView.frame.maxY),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        lastLabel = addText("LAZY  NAME?", delay: 0.5, duration: 0.7, position:
            CGPoint(x: 50, y: label1.frame.maxY + label1.path!.boundingBox.height + 5),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        addTextField()
    }
    
    private func lastStep() {
        let label1 = addText("GREAT! YOU", delay: 0, duration: 0.7, position:
            CGPoint(x: 50, y: imageView.frame.maxY),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        let label2 = addText("ARE  GOOD  TO GO", delay: 0.5, duration: 0.7, position:
            CGPoint(x: 50, y: label1.frame.maxY + label1.path!.boundingBox.height + 5),
                             lineWidth: 0.5, font: Font.with(.hairline, 25), color: textColor)
        lastLabel = addText("ENJOY!", delay: 1, duration: 0.7, position:
            CGPoint(x: 100, y: label2.frame.maxY + label2.path!.boundingBox.height + 10),
                             lineWidth: 1, font: Font.with(.hairline, 40), color: textColor)
        startAnimation(1)
    }
    
    private func askPermission() {
        askAuthorization()
        nextTapped()
    }
    
    func startAnimation(_ delay: Double) {
        let _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (_) in
            self.line = self.addLine()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseOut, animations: {
                if self.stepCount == 0 {
                    self.imageView.transform = CGAffineTransform.identity
                }
                self.line!.frame.size.width = 200
            }, completion: nil)
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
                self.line!.frame.size.width = self.view.frame.width - 64
            }) { (_) in
                self.showButton()
                if self.stepCount == 0 {
                    self.startImageAnimation()
                }
            }
        }
    }
    
    func startImageAnimation() {
        UIView.animate(withDuration: 0.9, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.015, y: 1.01)
        }, completion: nil)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let label = UILabel(frame: CGRect(x: self.imageView.center.x/1.5, y: self.imageView.center.y/1.3, width: 20, height: 20))
            label.font = Font.with(.thin, 25)
            label.textColor = self.textColor
            label.text = "Z"
            label.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.view.addSubview(label)
            let randomX = random(min: -150, max: 150)
            var transform = CGAffineTransform.identity
            transform = transform.translatedBy(x:  CGFloat(randomX), y: -200)
            transform = transform.scaledBy(x: 0.9, y: 0.9)
            UIView.animate(withDuration: 5, animations: {
                label.transform = transform
            }) { (_) in
                label.removeFromSuperview()
            }
        }
    }
    
    private func addLine() -> LineView {
        guard let lastLabel = lastLabel else { return LineView() }
        let line = LineView(frame: CGRect(x: 0, y: lastLabel.frame.maxY + lastLabel.path!.boundingBox.height + 5, width: 0, height: 1))
        line.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.addSubview(line)
        return line
    }
    
    private func addTextField() {
        guard let lastLabel = lastLabel else { return }
        field.tintColor = textColor
        field.textColor = textColor
        field.placeholder = "zzzz"
        field.font = Font.with(.medium, 20)
        field.delegate = self
        field.autocorrectionType = .no
        field.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        field.frame = CGRect(x: view.center.x - view.frame.width/4, y: lastLabel.frame.maxY + lastLabel.path!.boundingBox.height + 5, width: view.frame.width/2, height: 40)
        field.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        view.addSubview(field)
        UIView.animate(withDuration: 0.5, delay: 1.2, options: .allowUserInteraction, animations: {
            self.field.transform = CGAffineTransform.identity
        }) { (_) in
            self.field.becomeFirstResponder()
        }
    }
    
    @objc func textChanged() {
        if let text = field.text, !text.isEmpty, text.count < 15 {
            if let line = line, !view.contains(line) {
                startAnimation(0)
            }
            setButtonEnabled()
        } else {
            setButtonDisabled()
        }
    }
    
    func setButtonEnabled() {
        nextButton.alpha = 1
    }
    
    func setButtonDisabled() {
        nextButton.alpha = 0
    }
    
    private func setButton() {
        nextButton.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        nextButton.alpha = 0
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.tintColor = UIColor.black.withAlphaComponent(0.8)
        nextButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    private func showButton() {
        view.isUserInteractionEnabled = true
        guard let lastLabel = lastLabel, let line = line else { return }
        view.addSubview(nextButton)
        nextButton.frame = CGRect(x: view.frame.width - 64, y: lastLabel.frame.maxY + lastLabel.path!.boundingBox.height - 20, width: 40, height: 40)
        nextButton.center.y = line.center.y
        UIView.animate(withDuration: 0.5, animations: {
            self.nextButton.alpha = 1
            self.nextButton.transform = CGAffineTransform.identity
        }) { (_) in
            UIView.animate(withDuration: 0.7, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
                self.nextButton.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            }, completion: nil)
        }
    }
    
    @objc func nextTapped() {
        view.isUserInteractionEnabled = false
        nextButton.alpha = 0
        self.removeLine()
        removeLayers()
        stepCount += 1
        nextButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            self.nextStep()
        }
    }
    
    func removeLine() {
        UIView.animate(withDuration: 0.5, animations: {
            self.line!.frame.size.width = 0
        }) { (_) in
            self.line?.removeFromSuperview()
        }
    }
    
    func nextStep() {
        switch stepCount {
        case 1:
            secondStep()
        case 2:
            thirdStep()
        case 3:
            askPermission()
        case 4:
            fourthStep()
        case 5:
            if let text = field.text {
                setName(text)
            }
            lastStep()
        case 6:
            storeFirstTime()
            navigation.push(HomeVC(), shouldRemove: true)
        default:
            break
        }
        
    }
    
    private func removeLayers() {
        guard let sub = view.layer.sublayers, !sub.isEmpty else { return }
        var delay = -0.1
        for layer in sub {
            if layer.delegate?.isKind(of: UIButton.self) ?? false ||
                layer.delegate?.isKind(of: UIImageView.self) ?? false ||
                layer.delegate?.isKind(of: UILabel.self) ?? false ||
                layer.delegate?.isKind(of: LineView.self) ?? false  {
                continue
            }
            delay += 0.1
            let _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (_) in
                self.removeAnimated(layer)
            }
        }
    }
    
    private func removeAnimated(_ layer: CALayer) {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.duration = 0.5
        animation.fromValue = 0
        animation.toValue = -view.frame.width
        layer.position.x = -view.frame.width
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        let _ = Animation(animation: animation, object: layer) {
            layer.removeFromSuperlayer()
        }
    }
}

extension OnboardingVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = field.text, !text.isEmpty else { return true }
        textField.resignFirstResponder()
        nextTapped()
        return true
    }
}

class Animation: NSObject, CAAnimationDelegate {
    
    let completion: (()->Void)

    init(animation: CAAnimation, object: CALayer, completion: @escaping()->()) {
        self.completion = completion
        super.init()
        animation.delegate = self
        object.add(animation, forKey: "")
    }
    
    func load() {}
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion()
    }
    
}

class LineView: UIView {
    
    
}
