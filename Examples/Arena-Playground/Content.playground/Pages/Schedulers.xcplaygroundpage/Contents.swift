//: [Previous](@previous)

import RxSwift
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let commonDisposeBag = DisposeBag()

let firstScheduler = SerialDispatchQueueScheduler(qos: .default)
let secondScheduler = SerialDispatchQueueScheduler(qos: .default)
Observable
    .just(1)
    .map { num in
        print("map: ", Thread.current)
        return num * 2
    }
    .flatMap { num in
        print("flatMap: ", Thread.current)
        return Observable.just("\(num)")
    }
    .observe(on: secondScheduler)
    .subscribe(on: firstScheduler)
    .filter { str in
        print("filter: ", Thread.current)
        return !str.isEmpty
    }
    .observe(on: MainScheduler.instance)
    .subscribe(
        onNext: { str in
            print("onNext: ", Thread.current)
            print(str)
        }
    )
    .disposed(by: commonDisposeBag)

//: [Next](@next)
