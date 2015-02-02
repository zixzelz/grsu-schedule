//
//  RMSidebarInteractiveTransition.swift
//  SubPage
//
//  Created by Ruslan Maslouski on 9/16/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

enum GestureDirection : Int {
    case Left
    case Right
}

let minCompletionSpeed : CGFloat = 1.0
let cancelCompletionSpeed : CGFloat = 0.5

class RMSidebarInteractiveTransition: UIPercentDrivenInteractiveTransition {
   
    weak var delegate: RMSidebarInteractiveTransitionDelegate?
    var offset: CGFloat = 50
    var interactive: Bool = false
    private var initialDirection: GestureDirection = .Right
    
    init(view: UIView) {
        super.init()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        panGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!;
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!;

        var initialFromFrame = transitionContext.initialFrameForViewController(fromViewController)
        var initialToFrame = transitionContext.initialFrameForViewController(toViewController)
        var finalFromFrame = transitionContext.finalFrameForViewController(fromViewController)
        var finalToFrame = transitionContext.finalFrameForViewController(toViewController)
        
        super.startInteractiveTransition(transitionContext)
    }
    
    func handlePanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        
        switch (panGestureRecognizer.state) {
        case .Began:
            initialDirection = directionWithGestureRecognizer(panGestureRecognizer)
            
            if (self.delegate?.canInteractiveTransition(self, direction: initialDirection) == false) {
                panGestureRecognizer.enabled = false
                panGestureRecognizer.enabled = true
                
                return
            }
            
            interactive = true
            delegate?.interactiveTransitionStarted(self, direction: initialDirection)
        case .Changed:
            var percentComplete : CGFloat = percentCompleteWithGestureRecognizer(panGestureRecognizer)
//             NSLog("percentComplete \(percentComplete)")
            percentComplete = min(percentComplete, 0.999)
            percentComplete = max(percentComplete, 0.001)
            updateInteractiveTransition(percentComplete)
        case .Ended:
            //NSLog("Ended")
            interactive = false
            var velocity : CGFloat = velocityWithGestureRecognizer(panGestureRecognizer)
            var percentComplete : CGFloat = percentCompleteWithGestureRecognizer(panGestureRecognizer)
            var translation = translationWithGestureRecognizer(panGestureRecognizer)
            
            var completionSpeed = fabs((velocity / 1000))
            completionSpeed = max(completionSpeed, minCompletionSpeed)
            
            var completionCurve : UIViewAnimationCurve = .EaseOut
            var isFinish = false
            if (fabs(velocity) > 200) {
                if (velocity > 0) {
                    isFinish = true
                } else {
                    isFinish = false
                    completionSpeed = cancelCompletionSpeed
                    completionCurve = .EaseInOut
                }
            } else {
                if (percentComplete >= 0.5) {
                    isFinish = true
                } else {
                    isFinish = false
                    completionSpeed = cancelCompletionSpeed
                    completionCurve = .EaseInOut
                }
            }
            
            if (percentComplete == 0.0) {
                dispatch_after(1, dispatch_get_main_queue(), { () -> Void in
                    self.cancelInteractiveTransition()
                })
                return
            }
            
//            NSLog("completionSpeed \(completionSpeed)")
//            NSLog("velocity \(velocity)")
            
            self.completionSpeed = completionSpeed
            self.completionCurve = completionCurve
            if (isFinish) {
                finishInteractiveTransition()
            } else {
                cancelInteractiveTransition()
            }
        case .Cancelled:
            interactive = false
            cancelInteractiveTransition()
        default: break
        }
    }

    // MARK: - Utils
    
    func directionWithGestureRecognizer(panGestureRecognizer: UIPanGestureRecognizer) -> GestureDirection {
        var direction: GestureDirection
        if (realVelocityWithGestureRecognizer(panGestureRecognizer) > 0) {
            direction = .Right
        } else {
            direction = .Left
        }
        return direction
    }
    
    func percentCompleteWithGestureRecognizer(panGestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        var translation = translationWithGestureRecognizer(panGestureRecognizer)
        return max(0, translation / offset)
    }
    
    func translationWithGestureRecognizer(panGestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        var translation = panGestureRecognizer.translationInView(panGestureRecognizer.view!.window!).x
        if (initialDirection == GestureDirection.Left) {
            translation = -translation
        }
        return translation
    }

    func velocityWithGestureRecognizer(panGestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        var velocityInView = panGestureRecognizer.velocityInView(panGestureRecognizer.view?.window)
        var xVelocity : CGFloat = velocityInView.x
        if (initialDirection == GestureDirection.Left) {
            xVelocity = -xVelocity
        }
        return xVelocity
    }
    
    func realVelocityWithGestureRecognizer(panGestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        var velocityInView = panGestureRecognizer.velocityInView(panGestureRecognizer.view?.window)
        return velocityInView.x
    }

}


protocol RMSidebarInteractiveTransitionDelegate : NSObjectProtocol {
    func interactiveTransitionStarted(interactiveTransitioning: RMSidebarInteractiveTransition, direction: GestureDirection)
    func canInteractiveTransition(interactiveTransitioning: RMSidebarInteractiveTransition, direction: GestureDirection) -> Bool
}