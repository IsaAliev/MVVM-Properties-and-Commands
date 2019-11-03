//
//  ViewController.swift
//  MVVM Properties and Commands
//
//  Created by Isa Aliev on 02/11/2019.
//  Copyright © 2019 IA. All rights reserved.
//

import UIKit
import Combine

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
        
        // Bonus: Check Out MyCombine.swift for custom Publisher
        model.$greeting.myCombine(p2: model.$name)
            .map({ ($0.0 ?? "", $0.1 ?? "") })
            .sink(receiveValue: { (gr, name) in
            //print((gr, name))
        }).store(in: &disposables)
        
        sayHelloButton.publisher().trigger(model.sayHelloCommand).store(in: &disposables)
    }
}

