//: [Previous](@previous)

import RxSwift
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

func example(of name: String, executable: () -> Void) {
    print("---------")
    print("Пример: \(name)")
    executable()
    print("\n")
}
let commonDisposeBag = DisposeBag()

//example(of: "delay") {
//    Observable.just(1)
//        .delay(.seconds(1), scheduler: MainScheduler.instance)
//        .subscribe(
//            onNext: { number in
//                print(number)
//            }
//        )
//        .disposed(by: commonDisposeBag)
//}

example(of: "debounce") {
    Observable.merge(
        Observable.just(1),
        Observable.just(2).delay(
            .milliseconds(100),
            scheduler: MainScheduler.instance
        ),
        Observable.just(3).delay(
            .milliseconds(350),
            scheduler: MainScheduler.instance
        ),
        Observable.just(4).delay(
            .milliseconds(450),
            scheduler: MainScheduler.instance
        )
    )
    .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
    .subscribe(
        onNext: { number in
            print(number)
        }
    )
    .disposed(by: commonDisposeBag)
}

//: [Next](@next)
