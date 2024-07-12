//: [Previous](@previous)

import RxSwift
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let firstSchedulers = SerialDispatchQueueScheduler(qos: .default)
let secondSchedulers = SerialDispatchQueueScheduler(qos: .default)
let commonDisposeBag = DisposeBag()

Observable
    .just(1)
    .map { number in
        print("map: ", Thread.current)
        return number * 2
    }
    .flatMap { number in
        print("flatMap: ", Thread.current)
        return Observable.just("\(number)")
    }
    .observe(on: secondSchedulers)
    .subscribe(on: firstSchedulers)
    .filter { string in
        print("filter: ", Thread.current)
        return !string.isEmpty
    }
    .observe(on: MainScheduler.instance)
    .subscribe(
        onNext: { number in
            print("onNext: ", Thread.current)
            print(number)
        }
    )
    .disposed(by: commonDisposeBag)

//: [Next](@next)
