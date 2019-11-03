//
//  ViewModel.swift
//  MVVM Properties and Commands
//
//  Created by Isa Aliev on 02/11/2019.
//  Copyright © 2019 IA. All rights reserved.
//

import Foundation
import Combine

class ActionCommand: Command {
    private var actionBlock: () -> ()
    internal var subscription: Subscription?
    
    init(_ actionBlock: @escaping () -> ()) {
        self.actionBlock = actionBlock
    }
    
    func execute() {
        actionBlock()
    }
}

class ViewModel {
    @Published var name: String?
    @Published var greeting: String?
    
    lazy var sayHelloCommand: ActionCommand = {
        return ActionCommand { [unowned self] in
            self.sayHello()
        }
    }()
    
    private func sayHello() {
        greeting = "Hello, \(name ?? "")"
    }
}
