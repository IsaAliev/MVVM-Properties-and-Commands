//
//  Command.swift
//  MVVM Properties and Commands
//
//  Created by Isa Aliev on 02/11/2019.
//  Copyright © 2019 IA. All rights reserved.
//

import Foundation
import ReactiveKit

protocol Command: class, BindableProtocol {
    func execute()
}

extension Command {
    func bind(signal: Signal<Void, Never>) -> Disposable {
        return signal.observeNext { [weak self] _ in
            self?.execute()
        }
    }
}
