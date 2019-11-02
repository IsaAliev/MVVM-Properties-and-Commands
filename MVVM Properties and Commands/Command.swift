//
//  Command.swift
//  MVVM Properties and Commands
//
//  Created by Isa Aliev on 02/11/2019.
//  Copyright © 2019 IA. All rights reserved.
//

import Foundation
import Combine

protocol Command: class, Subscriber where Input == Void, Failure == Never {
    var subscription: Subscription? { get set }
    
    func execute()
    func stop()
}

extension Command {
    func receive(_ input: Void) -> Subscribers.Demand {
        execute()
        return .unlimited
    }
    
    func receive(subscription: Subscription) {
        self.subscription = subscription
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {}
    
    func stop() {
        subscription?.cancel()
    }
}
