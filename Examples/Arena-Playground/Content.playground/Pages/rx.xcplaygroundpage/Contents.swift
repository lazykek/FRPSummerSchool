//: [Previous](@previous)

import RxSwift
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let commonDisposeBag = DisposeBag()

class TestClass {
    var onValueChanged: ((Int) -> Void)?

    init() {
        Timer.scheduledTimer(
            withTimeInterval: 1, repeats: true
        ) { [weak self] _ in
            self?.onValueChanged?(Int.random(in: 0...1000))
        }
    }
}

extension TestClass: ReactiveCompatible {
}

extension Reactive where Base == TestClass {
    var value: Observable<Int> {
        let subject = PublishSubject<Int>()
        self.base.onValueChanged = { value in
            subject.onNext(value)
        }
        return subject.asObserver()
    }
}

let testClass = TestClass()
testClass.rx.value.subscribe(
    onNext: { value in
        print(value)
    }
)
.disposed(by: commonDisposeBag)

//: [Next](@next)
