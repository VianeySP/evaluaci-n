import UIKit

protocol WireframeInterface: class {
}

class BaseWireframe {

    private unowned var _viewController: UIViewController

    //to retain view controller reference upon first access
    private var _temporaryStoredViewController: UIViewController?

    init(viewController: UIViewController) {
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe: WireframeInterface {

}

extension BaseWireframe {

    var viewController: UIViewController {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }

    var navigationController: UINavigationController? {
        return viewController.navigationController
    }
    
    var tabBarController: UITabBarController? {
        return viewController.tabBarController
    }

}

extension UIViewController {

    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
    }
    
    func presentWireframeOnNewNavController(_ wireframe: BaseWireframe, animated: Bool = true) {
        let navigationController = UINavigationController(rootViewController: wireframe.viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

extension UINavigationController {

    func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.pushViewController(wireframe.viewController, animated: animated)
    }
    
    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.present(wireframe.viewController, animated: true, completion: nil)
    }
    
    func setRootWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.setViewControllers([wireframe.viewController], animated: animated)
    }
    
    func popWireframeFromLeft(animated: Bool = false) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let colorAnimation = CABasicAnimation.init(keyPath: "backgroundColor")
         colorAnimation.duration = 0.5
         colorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        colorAnimation.toValue = UIColor.white.cgColor
        colorAnimation.fromValue = UIColor.white.cgColor

        view.window?.backgroundColor = UIColor.white
        view.layer.backgroundColor = UIColor.white.cgColor
        view.window?.layer.add(colorAnimation , forKey: nil)
        view.layer.add(transition, forKey: nil)
        self.popViewController(animated: animated)
    }
    
    func pushWireframeFromLeft(_ wireframe: BaseWireframe, animated: Bool = false) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        //        view.window?.layer.add(transition, forKey: kCATransition)

        let colorAnimation = CABasicAnimation.init(keyPath: "backgroundColor")
         colorAnimation.duration = 0.5
         colorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        colorAnimation.toValue = UIColor.white.cgColor
        colorAnimation.fromValue = UIColor.white.cgColor

        view.window?.backgroundColor = UIColor.white
        view.layer.backgroundColor = UIColor.white.cgColor
        view.window?.layer.add(colorAnimation , forKey: nil)
        view.layer.add(transition, forKey: nil)
        
        self.pushViewController(wireframe.viewController, animated: animated)
    }

}
