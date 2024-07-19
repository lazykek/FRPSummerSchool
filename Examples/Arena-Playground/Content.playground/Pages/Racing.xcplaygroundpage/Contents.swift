//: [Previous](@previous)

import RxSwift
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let commonDisposeBag = DisposeBag()
let synchronizationScheduler = SerialDispatchQueueScheduler(
    internalSerialQueueName: "StorageSerialQueue"
)

func testRacing() {
    let subject = BehaviorSubject<Int>(value: 1)
    subject.subscribe(
        onNext: { number in
            print(number)
        }
    )

    (1...10).forEach { _ in
        DispatchQueue.global().async {
            var val = (try? subject.value()) ?? 0
            val += 1
            subject.onNext(val)
        }
    }
}

func testFix() {
    let subject = BehaviorSubject<Int>(value: 1)
    subject.subscribe(
        onNext: { number in
            print(number)
        }
    )

    (1...10).forEach { _ in
        DispatchQueue.global().async {
            Observable.just(0)
                .observe(on: synchronizationScheduler)
                .subscribe(
                    onNext: { _ in
                        var val = (try? subject.value()) ?? 0
                        val += 1
                        subject.onNext(val)
                    }
                )
                .disposed(by: commonDisposeBag)
        }
    }
}

//test()
testFix()

//: [Next](@next)
