//
//  ManagerViewController.swift
//  YaGanasteWallet
//
//  Created by Jonathan Pabel Saldivar Mendoza on 17/08/20.
//  Copyright © 2020 PagaTodo Holdings S.A.P.I. de C.V. All rights reserved.
//

import UIKit

class ManagerViewController: UIViewController {
    
    var manageKeyBoard = false
    var manageFullLoad = false
    var navigationBarStyle: NavigationBarStyle = .blue
    var ManagerFullLoadStatus:FullLoadStatus {
        return ManagerFullLoad.shared.status ?? .stop
    }
    private var generalLoadingView: GeneralLoadingView!
    private var isgeneralLoadingViewVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBarStyle()
        if manageKeyBoard {
            registerKeyBoardNotifications()
        }
        
        if manageFullLoad {
            registerFullLoadNotifications()
            let lastversion = UserDefaultsService.shared.getLastVersionBD()
            if lastversion != UserDefaultsService.shared.getUpdateBD() || UserDefaultsService.shared.getDataZipSize() == 0  || UserDefaultsService.shared.getIconsZipSize() == 0 {
                ManagerFullLoad.shared.startFullLoad()
            }else{
                finishFullLoad(notification: Notification(name: ManagerFullLoad.didfinishFullLoad))
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setBlueNavigationBarStyle()
        if manageKeyBoard {
            unregisterKeyBoardNotifications()
        }
        
        if manageFullLoad {
            unregisterFullLoadNotifications()
        }
    }
    
    // MARK: - Navigation Bar Style
    private func configureNavigationBarStyle() {
        switch navigationBarStyle {
        case .blue:
            setBlueNavigationBarStyle()
        case .white:
            setWhiteNavigationBarStyle()
        }
    }
    
    private func setBlueNavigationBarStyle() {
        let textAttributes:[NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor(named: "Blue Text")!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor(named: "Blue Text")
    }
    
    private func setWhiteNavigationBarStyle() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - Keyboard
    private func registerKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        // Override func when you need to manage keyboard
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        // Override func when you need to manage keyboard
    }
    
    func setTranslucentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - FullLoad Notifications
    private func registerFullLoadNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(startFullLoad(notification:)), name: ManagerFullLoad.didStartFullLoad, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(progressFullLoad(notification:)), name: ManagerFullLoad.didInProgressFullLoad, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishFullLoad(notification:)), name: ManagerFullLoad.didfinishFullLoad, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failFullLoad(notification:)), name: ManagerFullLoad.didfailFullLoad, object: nil)
        
    }
    
    private func unregisterFullLoadNotifications() {
        NotificationCenter.default.removeObserver(self, name: ManagerFullLoad.didStartFullLoad, object: nil)
        NotificationCenter.default.removeObserver(self, name: ManagerFullLoad.didInProgressFullLoad, object: nil)
        NotificationCenter.default.removeObserver(self, name: ManagerFullLoad.didfinishFullLoad, object: nil)
        NotificationCenter.default.removeObserver(self, name: ManagerFullLoad.didfailFullLoad, object: nil)
    }
    
    @objc func startFullLoad(notification: Notification) {
        // Override func when you need to manage full load
        if let _ = UIApplication.shared.keyWindow?.viewWithTag(020685) {
        } else {
            self.showGeneralLoading(message: "Un Momento, Estamos Configurando tu Cuenta...")
        }
    }
    
    @objc func progressFullLoad(notification: Notification) {
        // Override func when you need to manage full load
        DispatchQueue.main.async(execute: {
            if let _ = UIApplication.shared.keyWindow?.viewWithTag(020685) {
            } else {
                self.showGeneralLoading(message: "Un Momento, Estamos Configurando tu Cuenta...")
            }
        })
    }
    
    @objc func finishFullLoad(notification: Notification) {
        // Override func when you need to manage full load
        hideGeneralLoading()
    }
    
    @objc func failFullLoad(notification: Notification) {
        // Override func when you need to manage full load
        if  let error = notification.userInfo as? Error {
            print(error.localizedDescription)
        }
        hideGeneralLoading()
    }
    
    func showMessageDialog(_ dialogType: MessageDialogType? = .alert, title:String? = nil, message:String? = nil, canDismissView:Bool = true, buttonType:ButtonType? = nil, titleColor:UIColor? = nil, actionHandler: (() -> Void)? = nil, cancelHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "CustomAlerts", bundle: nil)
            let messageDialogViewController = storyboard.instantiateViewController(withIdentifier: "MessageDialogViewController") as! MessageDialogViewController
            messageDialogViewController.dialogType = dialogType
            messageDialogViewController.dialogTitle = title
            messageDialogViewController.dialogMessage = message
            messageDialogViewController.canDismissView = canDismissView
            messageDialogViewController.actionHandler = actionHandler
            messageDialogViewController.cancelHandler = cancelHandler
            messageDialogViewController.titleColor = titleColor
            messageDialogViewController.buttonType = buttonType
            messageDialogViewController.modalPresentationStyle = .overFullScreen
            messageDialogViewController.modalTransitionStyle = .crossDissolve
            if self.navigationController != nil {
                self.navigationController?.present(messageDialogViewController, animated: true, completion: nil)
            } else {
                self.present(messageDialogViewController, animated: true)
            }
        }
    }
    
    // MARK: - General loading
    
    func showGeneralLoading(message: String? = nil) {
        AppManager.shared.automaticLogoutEnable = false
        DispatchQueue.main.async {
            if self.isgeneralLoadingViewVisible {
                return
            }
            if self.generalLoadingView == nil {
                self.generalLoadingView = (Bundle.main.loadNibNamed("GeneralLoadingView", owner: nil, options: [:])![0] as! GeneralLoadingView)
            }
            
            var mainView: UIView?
            if #available(iOS 13.0, *) {
                if let mainScene = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first {
                    mainView = mainScene
                } else {
                    mainView = self.view
                }
            } else {
                if let mainWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    mainView = mainWindow
                } else {
                    mainView = self.view
                }
            }
            
            if let mainView = mainView {
                self.generalLoadingView.alpha = 0
                self.generalLoadingView.messageLabel.text = message ?? "Cargando..."
                mainView.addSubview(self.generalLoadingView)
                self.generalLoadingView.startAnimating()
                self.generalLoadingView.translatesAutoresizingMaskIntoConstraints = false
                let views: [String: Any] = [
                    "generalLoadingView" : self.generalLoadingView as Any
                ]
                
                let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[generalLoadingView]|", options: .alignAllFirstBaseline, metrics: nil, views: views)
                mainView.addConstraints(widthConstraints)
                
                let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[generalLoadingView]|", options: .alignAllFirstBaseline, metrics: nil, views: views)
                mainView.addConstraints(heightConstraints)
                
                UIView.animate(withDuration: 0.05, animations: {
                    self.generalLoadingView.alpha = 1
                })
                self.isgeneralLoadingViewVisible = true
            }
        }
    }
    
    func updateGeneralLoading(message: String) {
        AppManager.shared.automaticLogoutEnable = false
        DispatchQueue.main.async {
            if self.generalLoadingView != nil {
                self.generalLoadingView.messageLabel.text = message
            }
        }
    }
    
    func hideGeneralLoading() {
        AppManager.shared.automaticLogoutEnable = true
        DispatchQueue.main.async {
            if self.generalLoadingView != nil {
                self.generalLoadingView.removeFromSuperview()
                self.generalLoadingView = nil
                self.isgeneralLoadingViewVisible = false
            }
        }
    }
}
