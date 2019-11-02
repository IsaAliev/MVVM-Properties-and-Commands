//
//  ViewController.swift
//  MVVM Properties and Commands
//
//  Created by Isa Aliev on 02/11/2019.
//  Copyright © 2019 IA. All rights reserved.
//

import UIKit
import Combine

class TextSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == String? {
    private var subscriber: SubscriberType?
    private let textField: UITextField
    
    init(_ subscriber: SubscriberType, textField: UITextField) {
        self.subscriber = subscriber
        self.textField = textField
        
        textField.addTarget(self, action: #selector(handleChange), for: .editingChanged)
    }
    
    func request(_ demand: Subscribers.Demand) {
        
    }
    
    func cancel() {
        subscriber = nil
    }
    
    @objc private func handleChange() {
        _ = subscriber?.receive(textField.text)
    }
}

struct UITextFieldPublisher: Publisher {
    typealias Output = String?
    typealias Failure = Never

    let field: UITextField

    init(field: UITextField) {
        self.field = field
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UITextFieldPublisher.Failure, S.Input == UITextFieldPublisher.Output {
        let subscription = TextSubscription(subscriber, textField: field)
        subscriber.receive(subscription: subscription)
    }
}

class ButtonTapSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == Void {
    private let button: UIButton
    private var subscriber: SubscriberType?
    
    init(_ subscriber: SubscriberType, button: UIButton) {
        self.button = button
        self.subscriber = subscriber
        
        button.addTarget(self, action: #selector(handleTap), for: .primaryActionTriggered)
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
        subscriber = nil
    }
    
    @objc func handleTap() {
        _ = subscriber?.receive(())
    }
}

struct ButtonPublihser: Publisher {
    typealias Output = Void
    typealias Failure = Never
    
    private let button: UIButton

    init(_ button: UIButton) {
        self.button = button
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, ButtonPublihser.Failure == S.Failure, ButtonPublihser.Output == S.Input {
        let subscription = ButtonTapSubscription(subscriber, button: button)
        subscriber.receive(subscription: subscription)
    }
}

protocol CombineCompatible { }
extension UITextField: CombineCompatible {}
extension UIButton: CombineCompatible {}

extension CombineCompatible where Self: UITextField {
    func publisher() -> UITextFieldPublisher {
        return UITextFieldPublisher(field: self)
    }
}

extension CombineCompatible where Self: UIButton {
    func publisher() -> ButtonPublihser {
        return ButtonPublihser(self)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sayHelloButton: UIButton!
    private var disposables = Set<AnyCancellable>()
    
    var model = ViewModel() {
        didSet {
            disposables.removeAll()
            bindWithModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindWithModel()
    }
    
    private func bindWithModel() {
        model.$greeting.assign(to: \.text, on: greetingLabel).store(in: &disposables)
        nameTextField.publisher().assign(to: \.name, on: model).store(in: &disposables)
        
        sayHelloButton.publisher().subscribe(model.sayHelloCommand)
    }
}

