//
//  ViewModel.swift
//  MVVM Properties and Commands
//
//  Created by Isa Aliev on 02/11/2019.
//  Copyright © 2019 IA. All rights reserved.
//

import Foundation
import Bond

class ActionCommand: Command {
    typealias Element = Void
    private var actionBlock: () -> ()
    
    init(_ actionBlock: @escaping () -> ()) {
        self.actionBlock = actionBlock
    }
    
    func execute() {
        actionBlock()
    }
}

class ViewModel {
    let name = Observable<String?>(nil)
    let greeting = Observable<String?>(nil)
    lazy var sayHelloCommand: ActionCommand = {
        return ActionCommand { [unowned self] in
            self.sayHello()
        }
    }()
    
    private func sayHello() {
        greeting.value = "Hello, \(name.value ?? "")"
    }
}
