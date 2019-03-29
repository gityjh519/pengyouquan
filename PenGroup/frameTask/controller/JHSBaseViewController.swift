//
//  YyBaseViewController.swift
//  StudyApp
//

import UIKit
//import 

class JHSBaseViewController: BaseController {

    var nothingImageView: UIImageView!
    var nothingTipLabel: UILabel!
    

    
    var isUserEnableSubviews = true {
        didSet{
            for item in view.subviews{
                item.isUserInteractionEnabled = isUserEnableSubviews;
            }
        }
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    
    
    func showNothingData(show: Bool = true) -> Void {
        if show && nothingImageView == nil {
            nothingImageView = UIImageView(frame: CGRect(x: 0, y: 200, width: width(), height: height() - 200));
            addView(tempView: nothingImageView);
            nothingImageView.contentMode = .center;
            nothingImageView.backgroundColor = UIColor.clear;
        }
        nothingImageView?.isHidden = !show;
    }
    
    func showNothingData(text: String,show: Bool) -> Void {
        if show && nothingTipLabel == nil {
            nothingTipLabel = createLabel(rect: self.bounds(), text: text);
            nothingTipLabel.textAlignment = .center;
            nothingTipLabel.textColor = UIColor.gray;
        }
        nothingTipLabel?.isHidden = !show;
    }
    
    
    
    func loadDataFromNet(net: Bool = false) -> Void {
        
    }
    
    
    
    


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
        self.baseTable?.isUserInteractionEnabled = true;
        self.isUserEnableSubviews = true;
        super.touchesBegan(touches, with: event);
    }
    
    func didSelectedImage(info:[String : Any],image: UIImage) -> Void {
        
    }
    
    deinit {
        printObject("deinit = \(self)");
    }

}

// MARK: - create sub view

extension JHSBaseViewController {
    func createLabel(rect: CGRect,text: String) -> UILabel {
        let label = UILabel(frame: rect);
        label.text = text;
        label.textColor = UIColor.gray;
        addView(tempView: label);
        label.numberOfLines = 0;
        return label;
    }
    
    func createTextField(rect: CGRect) -> UITextField {
        let textFiel = UITextField(frame: rect);
        textFiel.autocorrectionType = .no;
        textFiel.autocapitalizationType = .none;
        textFiel.spellCheckingType = .no;
        addView(tempView: textFiel);
        textFiel.layer.cornerRadius = 4;
        textFiel.layer.masksToBounds = true;
        return textFiel;
    }
    
    
    
    func createButton(rect: CGRect,text: String) -> UIButton {
        let btn = UIButton(frame: rect);
        btn.setTitle(text, for: .normal);
        btn.backgroundColor = UIColor.clear;
        btn.setTitleColor(UIColor.white, for: .normal);
        addView(tempView: btn);
        return btn;
    }
    
    
    func createImageView(rect: CGRect,name: String?) -> UIImageView {
        let imageView = UIImageView(frame: rect);
        imageView.contentMode = .scaleAspectFill;
        imageView.clipsToBounds = true;
        addView(tempView: imageView);
        if let prefix = name {
            imageView.image = UIImage(named:prefix);
        }
        imageView.backgroundColor = UIColor.clear;
        return imageView;
    }
    
    func createView(rect: CGRect,isAdd: Bool = true) -> UIView {
        let tempView = UIView(frame: rect);
        if isAdd {
            addView(tempView: tempView);
        }
        tempView.backgroundColor = UIColor.lightGray;
        return tempView;
    }
}

extension JHSBaseViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func showSystemCamera(canEdit: Bool = true) -> Void {
        let alert = UIAlertController(title: "", message: "打开文件", preferredStyle: .actionSheet);
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        };
        let camer = UIAlertAction(title: "打开相机", style: .default) { (action) in
            self.openAppCamera(sourceType: .camera,canEdit: canEdit);
        };
        let phonto = UIAlertAction(title: "打开照片", style: .default) { (action) in
            self.openAppCamera(sourceType: .photoLibrary,canEdit: canEdit);
        };
        alert.addActions(aItems: [cancel,camer,phonto]);
        
        
        
        self.present(alert, animated: true) {
            
        };
    }
    
    // MARK: - open camera and phone
    
    fileprivate func openAppCamera(sourceType: UIImagePickerController.SourceType,canEdit: Bool = true) -> Void {
        
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let name = sourceType == .camera ? "相机" : "相册";
            showTip(msg: "不能打开\(name)", showCancel: false, finsihed: { (tag) -> (Void) in
                
            });
            return;
        }
        let name = sourceType == .camera ? "相机" : "相册";

        BlurModelView.showText(text: "正在打开\(name)");
        
        let ctrl = UIImagePickerController();
        ctrl.sourceType = sourceType;
        ctrl.allowsEditing = canEdit;
        ctrl.delegate = self;
        self.present(ctrl, animated: true) {
            BlurModelView.dimss();
        };
        
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) {
            
        };
        
        if let image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            didSelectedImage(info: info, image: image.screenImage);
        }else if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            didSelectedImage(info: info, image: image.screenImage);
        }
        
    }
    
}
var isShowingAlert = false;
extension UIViewController {
    func width() -> CGFloat {
        return view.frame.width;
    }
    func height() -> CGFloat {
        return view.frame.height;
    }
    
    func frame() -> CGRect {
        return self.view.frame;
    }
    func bounds(y: CGFloat = 0) -> CGRect {
        
        return CGRect(x: 0, y: y, width: width(), height: height() - y);
    }
    func addView(tempView: UIView) {
        self.view.addSubview(tempView);
    }
    
    
    
    func showTip(msg: String,showCancel: Bool = false,finsihed: ((Int) -> (Void))? = nil) -> Void {
        if isShowingAlert {
            return;
        }
        isShowingAlert = true;
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert);
        
        if showCancel {
            let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
                finsihed?(0);
                isShowingAlert = false;
            };
            alert.addAction(cancel);
        }
        
        let confim = UIAlertAction(title: "确定", style: .destructive) { (action) in
            finsihed?(1);
            isShowingAlert = false;

        };
        alert.addAction(confim);
        
        
        self.present(alert, animated: true) { 
            
        };
    }
    
    func showAlertView(alertTitle: String,msg: String,finished: @escaping ((Int,String) -> (Void))) ->Void {
        let alert = UIAlertController(title: alertTitle, message: msg, preferredStyle: .alert);
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        };
        let confim = UIAlertAction(title: "确定", style: .destructive) { (action) in
            
            if let textView = alert.textFields?.first {
                if !textView.text!.isEmpty {
                   finished(1,textView.text!);
                }

            }
            
        };
        
        alert.addTextField { (textView) in
            textView.keyboardType = .default;
        }
        alert.addAction(cancel);
        alert.addAction(confim);
        self.present(alert, animated: true) { 
            
        }
    }
    
}

extension UIAlertController{
    func addActions(aItems: [UIAlertAction]) -> Void {
        for item in aItems {
            addAction(item);
        }
    }
}
