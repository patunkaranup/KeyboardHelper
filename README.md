
# KeyboardHelper [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/patunkaranup/KeyboardHelper/blob/master/LICENSE) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
Swift library to help keep text entry view above keyboard. 
* Supports portrait and landscape orientation. 
* Supppots universal code.
* Allows customization.

#How to use 
* Add KeyboardHelper library 
* Import `import KeyboardHelper`
  
* Register scrollView 

  ```SharedKeyboardObserver.registerScrollView(scrollView, owner: self)```

* Provide firstResponder information 

  ```
  extension ScrollViewWithTextFieldViewController: ScrollViewHandler {
      func viewForFirstResponderInScrollView(scrollView: UIScrollView) -> UIView? {
        return textField
    }
  }
  ```
#Carthage support 
Add ```github "patunkaranup/KeyboardHelper"``` in Cartfile.
Follow intructions as per [page] (https://github.com/Carthage/Carthage)
