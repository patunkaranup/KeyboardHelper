# KeyboardHelper
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
