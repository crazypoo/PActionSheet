//
//  PActionSheet.swift
//  PActionSheet
//
//  Created by 邓杰豪 on 2016/9/13.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

typealias _PActionSheetDidSelectButtonBlock = (_ actionSheet:PActionSheet,_ buttonIndex:NSInteger) ->Void

class PActionSheet: UIView {
    var _backView:UIView?
    var _actionSheet:UIView?
    var _actionSheetHeight:CGFloat?
    var _isShow:Bool?
    var _title:NSString?
    var _cancelButtonTitle:NSString?
    var _destructiveButtonTitle:NSString?
    var _otherButtonTitles:NSArray?
    var _selectRowBlock:_PActionSheetDidSelectButtonBlock?

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
    }

    init(title:NSString, cancelButtonTitle:NSString,destructiveButtonTitle:NSString,otherButtonTitles:NSArray,handler:@escaping _PActionSheetDidSelectButtonBlock) {
        self.init()
        _title = title
        _cancelButtonTitle = cancelButtonTitle
        _otherButtonTitles = otherButtonTitles
        _destructiveButtonTitle = destructiveButtonTitle
        _selectRowBlock = handler

        _backView = UIView.init(frame: self.frame)
        _backView?.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2)
        _backView?.alpha = 0
        self.addSubview(_backView!)

        _actionSheet = UIView.init()
        _actionSheet?.backgroundColor = UIColor.init(colorLiteralRed: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.addSubview(_actionSheet!)

        var offy:CGFloat = 0
        let width = self.frame.size.width

        let normalImage = self.imageWithColor(color: UIColor.white)
        let highlightedImage = self.imageWithColor(color: UIColor.init(colorLiteralRed: 242/255, green: 242/255, blue: 242/255, alpha: 1))

        if _title != nil && (_title?.length)! > 0
        {

            let spacing:CGFloat = 15
            let titleHeight = ceil((_title?.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 13)], context: nil).size.height)!) + spacing * 2

            let titleLabel:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: titleHeight))
            titleLabel.backgroundColor = UIColor.white
            titleLabel.textColor = UIColor.init(colorLiteralRed: 111/255, green: 111/255, blue: 111/255, alpha: 1)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 13)
            titleLabel.numberOfLines = 0
            titleLabel.text = String(describing: _title)
            _actionSheet?.addSubview(titleLabel)

            offy += titleHeight + 0.5
        }

        if (_otherButtonTitles?.count)! > 0
        {
            for i in 0 ..< (_otherButtonTitles?.count)!
            {
                let btn = UIButton.init()
                btn.frame = CGRect.init(x: 0, y: offy, width: width, height: 48)
                btn.tag = i
                btn.backgroundColor = UIColor.white
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.setTitle(_otherButtonTitles?.object(at: i) as! String?, for: .normal)
                btn.setImage(normalImage, for: .normal)
                btn.setImage(highlightedImage, for: .highlighted)
                btn.addTarget(self, action: #selector(self.didSelectAction(sender:)), for: .touchUpInside)
                _actionSheet?.addSubview(btn)

                offy += 48 + 0.5
            }

            offy -= 0.5
        }

        if _destructiveButtonTitle != nil && (_destructiveButtonTitle?.length)! > 0
        {
            offy += 0.5
            let destructiveButton = UIButton.init()
            destructiveButton.frame = CGRect.init(x: 0, y: offy, width: width, height: 48)
            destructiveButton.tag = _otherButtonTitles?.count ?? 0
            destructiveButton.backgroundColor = UIColor.white
            destructiveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            destructiveButton.setTitleColor(UIColor.init(colorLiteralRed: 1, green: 10/255, blue: 10/255, alpha: 1), for: .normal)
            destructiveButton.setTitle(_destructiveButtonTitle as String?, for: .normal)
            destructiveButton.setImage(normalImage, for: .normal)
            destructiveButton.setImage(highlightedImage, for: .highlighted)
            destructiveButton.addTarget(self, action: #selector(self.didSelectAction(sender:)), for: .touchUpInside)
            _actionSheet?.addSubview(destructiveButton)

            offy += 48
        }

        let separatorView = UIView.init(frame: CGRect.init(x: 0, y: offy, width: width, height: 5))
        separatorView.backgroundColor = UIColor.init(colorLiteralRed: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        _actionSheet?.addSubview(separatorView)

        offy += 5

        let cancelBtn = UIButton.init()
        cancelBtn.frame = CGRect.init(x: 0, y: offy, width: width, height: 48)
        cancelBtn.tag = -1
        cancelBtn.backgroundColor = UIColor.white
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelBtn.setTitleColor(UIColor.blue, for: .normal)
        cancelBtn.setTitle(_cancelButtonTitle as? String ?? "取消", for: .normal)
        cancelBtn.setImage(normalImage, for: .normal)
        cancelBtn.setImage(highlightedImage, for: .highlighted)
        cancelBtn.addTarget(self, action: #selector(self.didSelectAction(sender:)), for: .touchUpInside)
        _actionSheet?.addSubview(cancelBtn)

        offy += 48

        _actionSheetHeight = offy

        _actionSheet?.frame = CGRect.init(x: 0, y: self.frame.height, width: self.frame.width, height: _actionSheetHeight!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func showActionSheetWithTitle(title:NSString,cancelButtonTitle:NSString,destructiveButtonTitle:NSString,otherButtonTitles:NSArray,handler:@escaping _PActionSheetDidSelectButtonBlock)->PActionSheet
    {
        let actionSheet = PActionSheet.init(title: title, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: destructiveButtonTitle, otherButtonTitles: otherButtonTitles, handler: handler)
        return actionSheet
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let point:CGPoint = touch.location(in: _backView)

        if (_actionSheet?.frame)!.contains(point) == false
        {
            dismiss()
        }

    }

    func didSelectAction(sender:UIButton)
    {
        if _selectRowBlock != nil
        {
            let index = sender.tag
            _selectRowBlock!(self,index)
        }
        dismiss()
    }

    func imageWithColor(color:UIColor)->UIImage
    {
        let rect:CGRect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!

        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    func show()
    {
        if _isShow == true
        {
            return
        }
        _isShow = true
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: [UIViewAnimationOptions.curveEaseInOut,UIViewAnimationOptions.beginFromCurrentState,UIViewAnimationOptions.layoutSubviews], animations: {
            UIApplication.shared.delegate?.window??.addSubview(self)
            self._backView?.alpha = 1

            self._actionSheet?.frame = CGRect.init(x: 0, y: self.frame.height - self._actionSheetHeight!, width: self.frame.width, height: self._actionSheetHeight!)
        }) { (finish:Bool) in
        }
    }

    func dismiss()
    {
        _isShow = false

        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: [UIViewAnimationOptions.curveEaseInOut,UIViewAnimationOptions.beginFromCurrentState,UIViewAnimationOptions.layoutSubviews], animations: {
            UIApplication.shared.delegate?.window??.addSubview(self)
            self._backView?.alpha = 0

            self._actionSheet?.frame = CGRect.init(x: 0, y: self.frame.height, width: self.frame.width, height: self._actionSheetHeight!)
        }) { (finish:Bool) in
            self.removeFromSuperview()
        }
    }

}
