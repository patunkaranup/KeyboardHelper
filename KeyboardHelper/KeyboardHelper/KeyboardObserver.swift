//
//  KeyboardObserver.swift
//  KeyboardHelper
//
//  Created by Anup Patunkar on 3/9/16.
//  Copyright © 2016 Anup Patunkar. All rights reserved.
//

import Foundation
import UIKit

public let SharedKeyboardObserver: KeyboardObserver = {
    let observer = KeyboardObserver()
    observer.delegate = SharedKeyboardHandler
    return observer
}()

//MARK:- KeyboardObserverDelegate
public protocol KeyboardObserverDelegate: class {
    func keyboardObserver(observer:KeyboardObserver, keyboardWillShow info: KeyboardObserverInformation)
    func keyboardObserver(observer:KeyboardObserver, keyboardWillHide info: KeyboardObserverInformation)
    func keyboardObserver(observer:KeyboardObserver, keyboardDidShow info: KeyboardObserverInformation)
    func keyboardObserver(observer:KeyboardObserver, keyboardDidHide info: KeyboardObserverInformation)
}

//MARK:- KeyboardObserver
public final class KeyboardObserver : NSObject {
    
    public weak var delegate: KeyboardObserverDelegate?
    
    override init() {
        super.init()
        
        addKeyboardMethodObservers()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private var scrollViewHandlerMapping = {
        return NSMapTable(keyOptions: .WeakMemory, valueOptions: .WeakMemory)
    }()
    
    private var scrollViewContentInsetMapping = {
        return NSMapTable(keyOptions: .WeakMemory, valueOptions: .StrongMemory)
    }()
    
    private var scrollViewContentOffsetMapping = {
        NSMapTable(keyOptions: .WeakMemory, valueOptions: .StrongMemory)
    }()
    
    private var cachedScrollViewAndFirstResponder: ScrollViewAndFirstResponder?
}

//MARK:- Public methods
public extension KeyboardObserver {
    
    public func registerScrollView(scrollView: UIScrollView, owner: ScrollViewHandler) {
        scrollViewHandlerMapping.setObject(owner, forKey: scrollView)
    }
    
    public func originalContentInsetForScrollView(scrollView: UIScrollView) -> UIEdgeInsets {
        let contentInset: UIEdgeInsets
        if let rectWrapper = scrollViewContentInsetMapping[scrollView] as? StructWrapper<UIEdgeInsets> {
            contentInset = rectWrapper.structValue
        } else {
            contentInset = scrollView.contentInset
            scrollViewContentInsetMapping[scrollView] = StructWrapper(structValue: scrollView.contentInset)
        }
        return contentInset
    }
    
    public func originalContentOffsetForScrollView(scrollView: UIScrollView) -> CGPoint {
        let contentOffset: CGPoint
        if let rectWrapper = scrollViewContentOffsetMapping[scrollView] as? StructWrapper<CGPoint> {
            contentOffset = rectWrapper.structValue
        } else {
            contentOffset = scrollView.contentOffset
            scrollViewContentOffsetMapping[scrollView] = StructWrapper(structValue: scrollView.contentOffset)
        }
        return contentOffset
    }
}

//MARK:- Internal methods
extension KeyboardObserver {
    private func addKeyboardMethodObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name:UIKeyboardDidShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidHide:"), name:UIKeyboardDidHideNotification, object: nil);
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboard = Keyboard(notification: notification),
            let scrollViewAndFirstResponder = findScrollViewWithFirstResponder() else {
                return
        }
        let info = KeyboardObserverInformation(
            keyboard: keyboard,
            scrollViewAndFirstResponder: scrollViewAndFirstResponder)
        delegate?.keyboardObserver(self, keyboardWillShow: info)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        guard let keyboard = Keyboard(notification: notification),
            let scrollViewAndFirstResponder = findScrollViewWithFirstResponder() else {
                return
        }
        let info = KeyboardObserverInformation(
            keyboard: keyboard,
            scrollViewAndFirstResponder: scrollViewAndFirstResponder)
        delegate?.keyboardObserver(self, keyboardDidShow: info)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let keyboard = Keyboard(notification: notification),
            let scrollViewAndFirstResponder = findScrollViewWithFirstResponder() else {
                return
        }
        let info = KeyboardObserverInformation(
            keyboard: keyboard,
            scrollViewAndFirstResponder: scrollViewAndFirstResponder)
        delegate?.keyboardObserver(self, keyboardDidShow: info)
    }
    
    func keyboardDidHide(notification: NSNotification) {
        guard let keyboard = Keyboard(notification: notification),
            let scrollViewAndFirstResponder = findScrollViewWithFirstResponder() else {
                return
        }
        let info = KeyboardObserverInformation(
            keyboard: keyboard,
            scrollViewAndFirstResponder: scrollViewAndFirstResponder)
        delegate?.keyboardObserver(self, keyboardWillHide: info)
        clearCache()
    }
    
    private func findScrollViewWithFirstResponder() -> ScrollViewAndFirstResponder? {
        if let cachedFirstResponder = cachedScrollViewAndFirstResponder?.firstResponder where cachedFirstResponder.isFirstResponder() {
            return cachedScrollViewAndFirstResponder
        }
        let enumerator = scrollViewHandlerMapping.keyEnumerator()
        while let scrollView: UIScrollView = enumerator.nextObject() as? UIScrollView {
            if let handler = scrollViewHandlerMapping[scrollView] as? ScrollViewHandler,
                let view = handler.viewForFirstResponderInScrollView(scrollView) {
                    cachedScrollViewAndFirstResponder = ScrollViewAndFirstResponder(scrollView, view)
                    return cachedScrollViewAndFirstResponder
            }
        }
        
        return nil
    }
    
    private func clearCache() {
        scrollViewContentInsetMapping.removeAllObjects()
        scrollViewContentOffsetMapping.removeAllObjects()
    }
}