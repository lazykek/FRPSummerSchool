// Playground generated with 🏟 Arena (https://github.com/finestructure/arena)
// ℹ️ If running the playground fails with an error "No such module"
//    go to Product -> Build to re-trigger building the SPM package.
// ℹ️ Please restart Xcode if autocomplete is not working.

import RxSwift
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

example(of: "Создание Observable с ошибкой") {
  let observable = Observable.create { observer in
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
