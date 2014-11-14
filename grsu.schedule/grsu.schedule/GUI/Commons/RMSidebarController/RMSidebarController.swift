//
//  RMSideBarController.swift
//  SubPage
//
//  Created by Ruslan Maslouski on 9/11/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

enum RMSidebar : Int {
    case None = 0
    case Left
    case Right
}
// TODO: add spring when trnsition was canceled

class RMSidebarController: UIViewController, UIViewControllerTransitioningDelegate, RMSidebarInteractiveTransitionDelegate {

    var leftSidebarViewController : UIViewController?
    var rightSidebarViewController : UIViewController?
    var rootViewController : UIViewController?
    private var animationController : RMSidebarControllerExpandedAnimatedTransitioning?
    private var interactionController : RMSidebarInteractiveTransition?

    private var shownSidebar : RMSidebar = .None
    
    @IBInspectable var leftOffset : CGFloat = 20
    @IBInspectable var rightOffset : CGFloat = 20
    
    @IBInspectable var panOnlyRootView : Bool = true
    
    @IBInspectable var panRootView : Bool = true
//    @IBInspectable var bezelPanRootView : Bool = true
    
    override init() {
        super.init()
        setup();
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup();
    }
    
    private func setup() {
        var slideAnimatedTransitioning = SlideAnimatedTransitioning()
        self.animationController = RMSidebarControllerExpandedAnimatedTransitioning(transitioningDelegate: slideAnimatedTransitioning)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactionController = RMSidebarInteractiveTransition(view: view)
        interactionController?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.setupWithStoryboard();
    }

    func setupWithStoryboard() {
        for identifier in [/*"left", */"root"] {
            self.performSegueWithIdentifier(identifier, sender: self);
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "left") {
            self.leftSidebarViewController = segue.destinationViewController as? UIViewController;
        } else if (segue.identifier == "right") {
            self.rightSidebarViewController = segue.destinationViewController as? UIViewController;
        } else if (segue.identifier == "root") {
            self.rootViewController = segue.destinationViewController as? UIViewController;
        }
    }
    
    // MARK: - RootViewController Navigation Bar
    
    func setupRootNavigationController(vc: UIViewController) {
        if ((vc.isKindOfClass(UINavigationController.classForCoder())) != true) {
            return;
        }
        
        let rootNavigationController = vc as UINavigationController
        
        if ((leftSidebarViewController) != nil) {
            let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "leftRootBarButtonItemPressed:")
            rootNavigationController.topViewController.navigationItem.leftBarButtonItem = item
        }
        if ((rightSidebarViewController) != nil) {
            let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "rightRootBarButtonItemPressed:")
            rootNavigationController.topViewController.navigationItem.rightBarButtonItem = item
        }
    }
    
    func leftRootBarButtonItemPressed(sender: AnyObject) {
        if (self.shownSidebar == .Left) {
            hideSidebar();
        } else {
            showLeftSidebar();
        }
    }
    
    func rightRootBarButtonItemPressed(sender: AnyObject) {
        
    }
    
    // MARK: - RootViewController
    
    func presentRootViewController(viewControllerToPresent: UIViewController, animated flag: Bool) {
        setupRootNavigationController(viewControllerToPresent)

        if (shownSidebar == .None) {
            replaceRootViewController(viewControllerToPresent, animated: flag)
            return
        }
        
        self.addChildViewController(viewControllerToPresent)
        
        animationController?.viewControllerToPresent = viewControllerToPresent
        self.animationController?.presentedViewController = rootViewController
        
        hideSidebar { (completed) -> Void in
            self.animationController?.viewControllerToPresent = nil
            self.animationController?.presentedViewController = nil
            if (completed) {
                self.rootViewController?.removeFromParentViewController()
                self.rootViewController = viewControllerToPresent
            } else {
                viewControllerToPresent.removeFromParentViewController()
            }
        }
    }
    
    private func replaceRootViewController(viewControllerToPresent: UIViewController, animated flag: Bool) {
        if (flag == false) {
            rootViewController?.removeFromParentViewController()
            rootViewController?.view.removeFromSuperview()
            
            self.addChildViewController(viewControllerToPresent)
            viewControllerToPresent.view.frame = self.view.bounds
            self.view.addSubview(viewControllerToPresent.view)
            
            rootViewController = viewControllerToPresent
        } else {
            animatedReplaceRootViewController(viewControllerToPresent)
        }
    }

    private func animatedReplaceRootViewController(viewControllerToPresent: UIViewController) {
        
        UIView.transitionFromView(rootViewController!.view,
            toView: viewControllerToPresent.view,
            duration: 0.3,
            options: UIViewAnimationOptions.TransitionFlipFromLeft) { (animated) -> Void in
                self.rootViewController?.removeFromParentViewController()
                self.addChildViewController(viewControllerToPresent)
                self.rootViewController = viewControllerToPresent
        }
    }
    
    // MARK: - RootViewController Utils
  
    func enableRootViewController(enabled: Bool) {
        var vc = rootViewController
        if ((vc?.isKindOfClass(UINavigationController.classForCoder())) == true) {
            vc = (rootViewController as UINavigationController).topViewController
        }
        vc?.view.userInteractionEnabled = enabled
    }
    
    // MARK: - Sidebar
    
    func showLeftSidebar() {
        showSidebar(.Left, animated: true);
    }
    
    func showRightSidebar() {
        showSidebar(.Right, animated: true);
    }
    
    func showSidebar(sidebar: RMSidebar, animated: Bool) {
        var sidebarViewController: UIViewController?
        switch (sidebar) {
        case .Left: sidebarViewController = self.leftSidebarViewController
        case .Right: sidebarViewController = self.rightSidebarViewController
        default: break
        }
        
        if (sidebarViewController == nil) {
            return;
        }
        shownSidebar = sidebar
        showSidebarViewController(leftSidebarViewController!, animated: true);
    }

    func showSidebarViewController(sidebarVC: UIViewController, animated: Bool) {
        sidebarVC.transitioningDelegate = self
        sidebarVC.modalPresentationStyle = .Custom;
        self.presentViewController(sidebarVC, animated: animated, completion: { () -> Void in
            if (self.presentedViewController == nil) {
                self.shownSidebar = .None;
            } else {
                self.enableRootViewController(false)
            }
        })
    }
    
    func hideSidebar() {
        hideSidebar(nil)
    }
    
    func hideSidebar(completion: ((completed: Bool) -> Void)?) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            var completed = false
            if (self.presentedViewController == nil) {
                self.enableRootViewController(true)
                self.shownSidebar = .None
                completed = true
            }
            if (completion != nil) {
                completion!(completed: completed)
            }
        })
    }

    // MARK: - RMSidebarInteractiveTransitionDelegate
    
    func interactiveTransitionStarted(interactiveTransitioning: RMSidebarInteractiveTransition, direction: GestureDirection) {
        
        if (shownSidebar == RMSidebar.None) {
            
            var sidebar : RMSidebar
            switch (direction) {
            case .Right: sidebar = .Left
            case .Left: sidebar = .Right
            }
            showSidebar(sidebar, animated: true)
        } else {
            hideSidebar();
        }
    }

    func canInteractiveTransition(interactiveTransitioning: RMSidebarInteractiveTransition, direction: GestureDirection) -> Bool {
        if (panRootView == false) {
            return false
        }
        
        if (panOnlyRootView == true) {
            var nc = rootViewController as UINavigationController
            if ((nc.isKindOfClass(UINavigationController.classForCoder())) == true && nc.viewControllers.count > 1) {
                return false
            }
        }
        return true
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationController?.direction_ = .Right;
        animationController?.action_ = .Present
        animationController?.offset_ = offsetForSidebar(shownSidebar);
        return animationController;
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationController?.direction_ = .Left;
        animationController?.action_ = .Dismiss
        animationController?.offset_ = offsetForSidebar(shownSidebar);
        return animationController;
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if (interactionController?.interactive == true) {
            interactionController?.offset = offsetForSidebar(shownSidebar)
            return interactionController
        } else {
            return nil
        }
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if (interactionController?.interactive == true) {
            interactionController?.offset = offsetForSidebar(shownSidebar)
            return interactionController
        } else {
            return nil
        }
    }
    
    // MARK: - Utils
    
    func offsetForSidebar(sidebar: RMSidebar) -> CGFloat {
        var offset : CGFloat
        switch (sidebar) {
        case .Left: offset = leftOffset
        case .Right: offset = rightOffset
        default: offset = 50;
        }
        return CGRectGetWidth(self.view.bounds) - offset;
    }
}
