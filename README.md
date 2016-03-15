
# KeyboardHelper [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
Swift library to help keep text entry view above keyboard.
#How to use 
* Add KeyboardHelper Library 
* Import `import keyboardHelper`
  
* Register scrollView 

  ```SharedKeyboardObserver.registerScrollView(scrollView, owner: self)```

* Provide firstResponder Information 

  ```
  extension ScollViewWithTextFieldViewController: ScrollViewHandler {
      func viewForFirstResponderInScrollView(scrollView: UIScrollView) -> UIView? {
        return textField
    }
  }
  ```
