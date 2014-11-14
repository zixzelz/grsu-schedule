//
//  RMSidebarControllerTransitioning.swift
//  SubPage
//
//  Created by Ruslan Maslouski on 9/22/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class RMSidebarControllerExpandedAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var transitioningDelegate_: RMSidebarControllerAnimatedTransitioning
    private var transitionContext_: UIViewControllerContextTransitioning?
    
    var presentedViewController: UIViewController?
    var viewControllerToPresent: UIViewController?
    
    var direction_: AnimatedTransitioningDirection = .Right
    var action_: AnimatedTransitioningAction = .Present
    var offset_: CGFloat = 50
    
    init(transitioningDelegate: RMSidebarControllerAnimatedTransitioning) {
        transitioningDelegate_ = transitioningDelegate
        super.init()
    }
    
    // MARK: UIViewControllerAnimatedTransitioning Protocol

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        transitionContext_ = transitionContext
        return transitioningDelegate_.transitionDuration(self)
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if (viewControllerToPresent == nil) {
            transitioningDelegate_.animateTransition(self)
        } else {
            transitioningDelegate_.replaceAnimateTransition(self)
        }
    }
    
    func animationEnded(transitionCompleted: Bool) {
        transitioningDelegate_.animationEnded(transitionCompleted)
    }
}

extension RMSidebarControllerExpandedAnimatedTransitioning: RMSidebarControllerContextTransitioning {
    
    // MARK: - RMSidebarControllerContextTransitioning Protocol
    
    func containerView() -> UIView {
        return self.transitionContext_!.containerView()
    }
    
    func sidebarView() -> UIView {
        var key: NSString
        if (action_ == AnimatedTransitioningAction.Present) {
            key = UITransitionContextToViewControllerKey
        } else {
            key = UITransitionContextFromViewControllerKey
        }
        var viewController = transitionContext_!.viewControllerForKey(key)
        return viewController!.view
    }

    func rootСontainerView() -> UIView {
        var key: NSString
        if (action_ == AnimatedTransitioningAction.Present) {
            key = UITransitionContextFromViewControllerKey
        } else {
            key = UITransitionContextToViewControllerKey
        }
        var viewController = transitionContext_!.viewControllerForKey(key)
        return viewController!.view
    }

    func rootView() -> UIView? {
        var view: UIView?
        if (presentedViewController != nil) {
            view = presentedViewController?.view
        }
        return view
    }
    
    func newRootView() -> UIView? {
        var view: UIView?
        if (viewControllerToPresent != nil) {
            view = viewControllerToPresent?.view
        }
        return view
    }
    
    func direction() -> AnimatedTransitioningDirection {
        return direction_
    }
    
    func action() -> AnimatedTransitioningAction {
        return action_
    }
    
    func offset() -> CGFloat {
        return offset_
    }

    func transitionWasCancelled() -> Bool {
        return transitionContext_!.transitionWasCancelled()
    }
    
    func completeTransition(didComplete: Bool) {
        transitionContext_!.completeTransition(didComplete)
    }
}