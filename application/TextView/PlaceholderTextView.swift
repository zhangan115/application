//
//  PlaceholderTextView.swift
//  Evpro
//
//  Created by piggybear on 2018/5/7.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation
import UIKit

@objc protocol PlaceholderTextViewDelegate {
    @objc optional func placeholderTextViewDidChangeText(_ text:String)
    @objc optional func placeholderTextViewDidEndEditing(_ text:String)
    @objc optional func placeholderTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

final class PlaceholderTextView: UITextView {
    
    var notifier:PlaceholderTextViewDelegate?
    
    @IBInspectable var placeholder: String? {
        didSet {
            placeholderLabel?.text = placeholder
            layoutSubviews()
        }
    }
    var placeholderColor = UIColor.lightGray
    var placeholderFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            placeholderLabel?.font = placeholderFont
        }
    }
    
    fileprivate var placeholderLabel: UILabel?
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textDidChangeHandler(notification:)), name: UITextView.textDidChangeNotification, object: nil)
        placeholderLabel = UILabel()
        placeholderLabel?.textColor = placeholderColor
        placeholderLabel?.text = placeholder
        placeholderLabel?.textAlignment = .left
        placeholderLabel?.numberOfLines = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeholderLabel?.font = placeholderFont
        
        var height:CGFloat = placeholderFont.lineHeight
        if let data = placeholderLabel?.text {
            
            let expectedDefaultWidth:CGFloat = bounds.size.width
            let fontSize:CGFloat = placeholderFont.pointSize
            
            let textView = UITextView()
            textView.text = data
            textView.font = UIFont.systemFont(ofSize: fontSize)
            let sizeForTextView = textView.sizeThatFits(CGSize(width: expectedDefaultWidth,
                                                               height: CGFloat.greatestFiniteMagnitude))
            let expectedTextViewHeight = sizeForTextView.height
            
            if expectedTextViewHeight > height {
                height = expectedTextViewHeight
            }
        }
        
        placeholderLabel?.frame = CGRect(x: 10,
                                         y: 0,
                                         width: bounds.size.width - 16,
                                         height: height)
        
        if text.count == 0 {
            addSubview(placeholderLabel!)
            bringSubviewToFront(placeholderLabel!)
        } else {
            placeholderLabel?.removeFromSuperview()
        }
    }
    
    @objc func textDidChangeHandler(notification: Notification) {
        layoutSubviews()
    }
    
}

extension PlaceholderTextView : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return (notifier?.placeholderTextView?(textView, shouldChangeTextIn: range, replacementText: text)) ?? true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        notifier?.placeholderTextViewDidChangeText?(textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        notifier?.placeholderTextViewDidEndEditing?(textView.text)
    }
}
