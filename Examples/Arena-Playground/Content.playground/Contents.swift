// Playground generated with 🏟 Arena (https://github.com/finestructure/arena)
// ℹ️ If running the playground fails with an error "No such module"
//    go to Product -> Build to re-trigger building the SPM package.
// ℹ️ Please restart Xcode if autocomplete is not working.

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

enum TestError: Error {
    case someError
}

let commonDisposeBag = DisposeBag()

example(of: "Создание Observable с onCompleted") {
    let observable = Observable.create { observer in
        observer.onNext(1)
        observer.onNext(2)
        observer.onCompleted()

        return Disposables.create()
    }

    observable.subscribe(
        onNext: { number in
            print(number)
        }, onError: { error in
            print(error)
        },onCompleted: {
            print("On completed")
        }, onDisposed: {
            print("On disposed")
        }
    )
    .disposed(by: commonDisposeBag)
}

example(of: "Observable.just") {
    Observable.just(1)
        .subscribe(
            onNext: { number in
                print(number)
            }
        )
        .disposed(by: commonDisposeBag)
}

example(of: "Observable.from(_ array:)") {
    Observable.from([1, 2, 3])
        .subscribe(
            onNext: { number in
                print(number)
            }
        )
        .disposed(by: commonDisposeBag)
}

example(of: "Создание Observable с ошибкой") {
    let observable = Observable<Int>.create { observer in
        observer.onNext(1)
        observer.onNext(2)
        observer.onError(TestError.someError)
        observer.onCompleted()

        return Disposables.create()
    }

    observable.subscribe(
        onNext: { number in
            print(number)
        }, onError: { error in
            print(error)
        },onCompleted: {
            print("On completed")
        }, onDisposed: {
            print("On disposed")
        }
    )
    .disposed(by: commonDisposeBag)
}

example(of: "PublishSubject") {
    let subject = PublishSubject<Int>()
    subject.onNext(1)

    subject.subscribe(
        onNext: { number in
            print(number)
        }, onCompleted: {
            print("On completed")
        }
    )
    subject.onNext(2)
    subject.onCompleted()

    subject.subscribe(
        onNext: { number in
            print(number)
        }, onCompleted: {
            print("On completed")
        }
    )
}

example(of: "BehaviorSubject") {
    let subject = BehaviorSubject<Int>(value: 0)
    subject.onNext(1)

    subject.subscribe(
        onNext: { number in
            print(number)
        }, onCompleted: {
            print("On completed")
        }
    )
    subject.onNext(2)

    subject.subscribe(
        onNext: { number in
            print(number)
        }, onCompleted: {
            print("On completed")
        }
    )

    subject.onCompleted()
    subject.subscribe(
        onNext: { number in
            print(number)
        }, onCompleted: {
            print("On completed")
        }
    )
}

example(of: "AsyncSubject") {
    let subject = AsyncSubject<Int>()

    subject.subscribe(
        onNext: { number in
            print(number)
        }, onCompleted: {
            print("On completed")
        }
    )
    subject.onNext(1)

    subject.subscribe(
        onNext: { number in
            print(number)
        }, onCompleted: {
            print("On completed")
        }
    )

    subject.onCompleted()
}

example(of: "ReplaySubject") {
    let subject = ReplaySubject<Int>.create(bufferSize: 2)
    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
    subject.subscribe(
        onNext: { number in
            print(number)
        }, onCompleted: {
            print("On completed")
        }
    )
    subject.onNext(4)

    subject.onCompleted()
}

example(of: "map") {
    Observable
        .from([1, 2, 3])
        .map { number in
            "\(number) * 2 = \(number * 2)"
        }
        .subscribe(
            onNext: { string in
                print(string)
            }
        )
        .disposed(by: commonDisposeBag)
}

example(of: "reduce") {
    Observable
        .from([1, 2, 3])
        .reduce("String: ") { accumulator, number in
            accumulator + "\(number)"
        }
        .subscribe(
            onNext: { string in
                print(string)
            }
        )
        .disposed(by: commonDisposeBag)
}

example(of: "compactMap") {
    Observable
        .from([1, nil, 2, 3, nil])
        .compactMap { $0 }
        .subscribe(
            onNext: { string in
                print(string)
            }
        )
        .disposed(by: commonDisposeBag)
}

example(of: "Swift.flatMap") {
    let array = [[1, 2, 3], [4, 5], [6, 7, 8, 9]]
        .flatMap { $0 }
    print(array)
}

example(of: "flatMap simple") {
    Observable
        .from([1, 2, 3])
        .flatMap { number in
            Observable
                .from([4 * number, 5 * number])
        }
        .subscribe(
            onNext: { string in
                print(string)
            }
        )
        .disposed(by: commonDisposeBag)
}

example(of: "flatMap lifecycle") {
    let parentSubject = PublishSubject<Int>()
    let childSubject = PublishSubject<Int>()

    parentSubject
        .flatMap { value in
            childSubject
        }
        .subscribe(
            onNext: { number in
                print(number)
            }, onError: { error in
                print(error)
            },onCompleted: {
                print("On completed")
            }, onDisposed: {
                print("On disposed")
            }
        )
        .disposed(by: commonDisposeBag)

    parentSubject.onNext(1)
    parentSubject.onNext(2)

    childSubject.onNext(3)
    childSubject.onNext(4)
    childSubject.onCompleted()
    childSubject.onNext(5)

    parentSubject.onNext(6) // не отработает, так как child-стрим завершился
    parentSubject.onCompleted() // нужно пробросить два onCompleted(), иначе стрим не завершится
    // https://stackoverflow.com/questions/65078033/why-calling-completable-method-inside-of-flatmap-does-not-working
}

example(of: "merge") {
    Observable.merge(
        .from([1, 2, 3]),
        .from([4, 5, 6])
    )
    .subscribe(
        onNext: { number in
            print(number)
        }
    )
    .disposed(by: commonDisposeBag)
}

example(of: "combineLatest") {
    Observable.combineLatest(
        Observable.from([1, 2, 3]),
        Observable.from([4, 5, 6])
    )
    .subscribe(
        onNext: { pair in
            print(pair)
        }
    )
    .disposed(by: commonDisposeBag)
}

example(of: "Schedulers") {
    let firstSchedulers = SerialDispatchQueueScheduler(qos: .default)
    let secondSchedulers = SerialDispatchQueueScheduler(qos: .default)
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
}
