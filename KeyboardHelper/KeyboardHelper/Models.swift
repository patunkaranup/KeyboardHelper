//
//  Models.swift
//  KeyboardHelper
//
//  Created by Anup Patunkar on 3/9/16.
//  Copyright © 2016 Anup Patunkar. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Keyboard
public struct Keyboard {
    let beginFrame: CGRect
    let endFrame: CGRect
    let animationDuration: Double?
    let animationCurve: UIViewAnimationCurve?
    let isLocal: Bool?
    
    init?(notification: NSNotification) {
        guard let beginFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue,
            let endFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else  {
                return nil
        }
        self.beginFrame = beginFrame
        self.endFrame = endFrame
        
        self.animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        if let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey]?.integerValue {
            self.animationCurve = UIViewAnimationCurve(rawValue: curve)
        } else {
            self.animationCurve = nil
        }
        
        self.isLocal = notification.userInfo?[UIKeyboardIsLocalUserInfoKey]?.boolValue
    }
}

//MARK:- ScrollViewHandler
public protocol ScrollViewHandler: class {
    func viewForFirstResponderInScrollView(scrollView: UIScrollView) -> UIView?
}

//MARK:- KeyboardObserverInformation
public struct KeyboardObserverInformation {
    public let keyboard: Keyboard
    public let scrollView: UIScrollView
    public let firstResponder: UIView
    
    init(keyboard: Keyboard, scrollViewAndFirstResponder: ScrollViewAndFirstResponder) {
        self.keyboard = keyboard
        self.scrollView = scrollViewAndFirstResponder.scrollView
        self.firstResponder = scrollViewAndFirstResponder.firstResponder
    }
}

//MARK:- StructWrapper
public class StructWrapper<T> {
    let structValue: T
    init(structValue: T){
        self.structValue = structValue
    }
}

//MARK:- NSMapTable extension
extension NSMapTable {
    subscript(key: AnyObject) -> AnyObject? {
        get {
            return objectForKey(key)
        }
        
        set {
            if newValue != nil {
                setObject(newValue, forKey: key)
            } else {
                removeObjectForKey(key)
            }
        }
    }
}

typealias ScrollViewAndFirstResponder = (scrollView: UIScrollView, firstResponder: UIView)
