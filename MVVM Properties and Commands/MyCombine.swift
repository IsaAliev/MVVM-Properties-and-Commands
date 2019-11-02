//
//  MyCombine.swift
//  MVVM Properties and Commands
//
//  Created by Isa Aliev on 02/11/2019.
//  Copyright © 2019 IA. All rights reserved.
//

import Foundation
import Combine

// Bonus: Custom Publisher

struct MyCombine<T, S>: Publisher where T: Publisher, S: Publisher, T.Failure == S.Failure {
    typealias Output = (T.Output, S.Output)
    typealias Failure = T.Failure
    
    private let t: T
    private let s: S
 
    init(_ pub1: T, pub2: S) {
        t = pub1
        s = pub2
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, MyCombine.Failure == S.Failure, MyCombine.Output == S.Input {
        let subsc = MyCombineSubscription(t, pub2: s, subscriber: subscriber)
        subscriber.receive(subscription: subsc)
    }
}

extension MyCombine {
    class MyCombineSubscription<A,B,SubscriberType: Subscriber>: Subscription where
    A: Publisher, B: Publisher, A.Failure == B.Failure,
    SubscriberType.Input == (A.Output, B.Output) {
        
        private var subscriber: SubscriberType?
        
        private let a: A
        private let b: B
        
        private var aVal: A.Output?
        private var bVal: B.Output?
        
        private var hasAVal = false
        private var hasBVal = false
        private var disposables = Set<AnyCancellable>()
        
        deinit {
            disposables.removeAll()
        }
        
        init(_ pub1: A, pub2: B, subscriber: SubscriberType) {
            self.subscriber = subscriber
            a = pub1
            b = pub2
            
            startObservingPublishers()
        }
        
        private func startObservingPublishers() {
            a.sink(receiveCompletion: { (compl) in })
            { [weak self] (out) in
                self?.aVal = out
                self?.hasAVal = true
                self?.send()
            }.store(in: &disposables)
            
            b.sink(receiveCompletion: { (compl) in })
            { [weak self] (out) in
                self?.bVal = out
                self?.hasBVal = true
                self?.send()
            }.store(in: &disposables)
        }
        
        func send() {
            if hasAVal && hasBVal {
                _ = subscriber?.receive((aVal!, bVal!))
            }
        }
        
        func request(_ demand: Subscribers.Demand) {
            
        }
        
        func cancel() {
            subscriber = nil
        }
    }
}

extension Publisher {
    func myCombine<S>(p2: S) -> MyCombine<Self, S> {
        return MyCombine(self, pub2: p2)
    }
}
