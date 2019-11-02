//
//  ViewController.swift
//  MVVM Properties and Commands
//
//  Created by Isa Aliev on 02/11/2019.
//  Copyright © 2019 IA. All rights reserved.
//

import UIKit
import Bond

class ViewController: UIViewController {
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sayHelloButton: UIButton!
    
    let model = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindWithModel()
    }
    
    private func bindWithModel() {
        model.greeting.bind(to: greetingLabel.reactive.text).dispose(in: bag)
        model.name.bidirectionalBind(to: nameTextField.reactive.text).dispose(in: bag)
        sayHelloButton.reactive.tap.bind(to: model.sayHelloCommand).dispose(in: bag)
    }
}

