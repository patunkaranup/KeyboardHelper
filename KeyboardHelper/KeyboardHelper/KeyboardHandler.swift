//
//  KeyboardHandler.swift
//  KeyboardHelper
//
//  Created by Anup Patunkar on 3/9/16.
//  Copyright © 2016 Anup Patunkar. All rights reserved.
//

import Foundation
import UIKit

public let SharedKeyboardHandler: KeyboardHandler = {
    return KeyboardHandler()
}()

public class KeyboardHandler: KeyboardObserverDelegate {
    
    public var firstResponderMargin: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0)
    
    public func keyboardObserver(observer:KeyboardObserver, keyboardWillShow info: KeyboardObserverInformation) {
        let firstResponder = info.firstResponder
        guard let firstResponderSuperView = firstResponder.superview else {
            return
        }
        
        let firstResponderFrameWRTWindow = firstResponderSuperView.convertRect(firstResponder.frame, toView: nil)
        guard CGRectIntersectsRect(firstResponderFrameWRTWindow, info.keyboard.endFrame) else {
            return
        }
        
        let scrollView = info.scrollView
        guard let scrollViewSuperView = scrollView.superview else {
            return
        }
        
        var contentInset = observer.originalContentInsetForScrollView(scrollView)
        
        let scrollViewFrameWRTWindow = scrollViewSuperView.convertRect(scrollView.frame, toView: nil)
        contentInset.bottom = CGRectIntersection(scrollViewFrameWRTWindow, info.keyboard.endFrame).height
        contentInset.bottom += firstResponderMargin.bottom
        contentInset.top += firstResponderMargin.top
        scrollView.contentInset = contentInset
    }
    
    public func keyboardObserver(observer: KeyboardObserver, keyboardDidShow info: KeyboardObserverInformation) {
        //No Implementation
    }
    
    public func keyboardObserver(observer: KeyboardObserver, keyboardWillHide info: KeyboardObserverInformation) {
        let scrollView = info.scrollView
        scrollView.contentOffset = observer.originalContentOffsetForScrollView(scrollView)
        scrollView.contentInset = observer.originalContentInsetForScrollView(scrollView)
    }
    
    public func keyboardObserver(observer: KeyboardObserver, keyboardDidHide info: KeyboardObserverInformation) {
        //No Implementation
    }
}
