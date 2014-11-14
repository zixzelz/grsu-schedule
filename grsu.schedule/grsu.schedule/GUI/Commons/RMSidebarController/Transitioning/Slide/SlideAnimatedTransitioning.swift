//
//  SlideAnimatedTransitioning.swift
//  SubPage
//
//  Created by Ruslan Maslouski on 9/15/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class SlideAnimatedTransitioning: NSObject, RMSidebarControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: RMSidebarControllerContextTransitioning) -> NSTimeInterval {
        if (transitionContext.newRootView() == nil) {
            return 0.25
        }
        return 0.45
    }
    
    func animateTransition(transitionContext: RMSidebarControllerContextTransitioning) {
        
        var containerView = transitionContext.containerView()
        var rootСontainerView = transitionContext.rootСontainerView()
        var sidebarView = transitionContext.sidebarView()
        
        var offset = transitionContext.offset()
        var width = CGRectGetWidth(transitionContext.containerView().bounds)
        
        var rootStartFrame = CGRectZero
        var rootEndFrame = CGRectZero
        var sidebarStartFrame = CGRectZero
        var sidebarEndFrame = CGRectZero
        
        if (transitionContext.direction() == AnimatedTransitioningDirection.Right) {
            rootStartFrame = rootСontainerView.frame;
            rootEndFrame = rootStartFrame;
            rootEndFrame.origin.x = offset;
            
            sidebarStartFrame = rootStartFrame;
            sidebarStartFrame.origin.x = -offset;
            sidebarStartFrame.size.width = offset;
            sidebarEndFrame = sidebarStartFrame;
            sidebarEndFrame.origin.x = 0;
        } else {
            rootStartFrame = rootСontainerView.frame;
            rootEndFrame = rootStartFrame;
            rootEndFrame.origin.x = 0;
            
            sidebarStartFrame = sidebarView.frame;
            sidebarEndFrame = sidebarStartFrame;
            sidebarEndFrame.origin.x = -CGRectGetWidth(sidebarStartFrame);
        }
        
        containerView.addSubview(rootСontainerView)
        containerView.addSubview(sidebarView)
        
        rootСontainerView.frame = rootStartFrame;
        sidebarView.frame = sidebarStartFrame;

        var duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0, options:.CurveLinear, animations: { () -> Void in
            
            rootСontainerView.frame = rootEndFrame;
            sidebarView.frame = sidebarEndFrame;
            
        }, completion: { (completed: Bool) -> Void in
            NSLog("completion")
            
            var transitionWasCancelled = transitionContext.transitionWasCancelled()
            if (transitionWasCancelled) {
                transitionContext.containerView().superview!.addSubview(rootСontainerView)
            }
            if (transitionContext.direction() == AnimatedTransitioningDirection.Left && !transitionWasCancelled) {
                transitionContext.containerView().superview!.addSubview(rootСontainerView)
            }
            transitionContext.completeTransition(!transitionWasCancelled)
        })
    }
    
    func replaceAnimateTransition(transitionContext: RMSidebarControllerContextTransitioning) {
        var containerView = transitionContext.containerView()
        var rootСontainerView = transitionContext.rootСontainerView()
        var sidebarView = transitionContext.sidebarView()
        var rootView = transitionContext.rootView()
        var newRootView = transitionContext.newRootView()!
        
        var offset = transitionContext.offset()
        var width = CGRectGetWidth(transitionContext.containerView().bounds)
        
        
        var rootEndFrame = containerView.bounds;
        
        var sidebarEndFrame = containerView.bounds;
        sidebarEndFrame.origin.x = -CGRectGetWidth(sidebarEndFrame);
        
        
        newRootView.frame = rootСontainerView.bounds;
        rootСontainerView.insertSubview(newRootView, atIndex: 0)

        
        var duration = transitionDuration(transitionContext)
        UIView.animateKeyframesWithDuration(duration, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModeLinear, animations: { () -> Void in
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.3, animations: { () -> Void in
                var sFrame = sidebarView.frame
                sFrame.size.width = width
                sidebarView.frame = sFrame
                
                var rFrame = rootСontainerView.frame
                rFrame.origin.x = width
                rootСontainerView.frame = rFrame
                
                sidebarView.layoutIfNeeded()
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.01, animations: { () -> Void in
                rootView!.alpha = 0
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.75, animations: { () -> Void in
                rootСontainerView.frame = rootEndFrame;
                sidebarView.frame = sidebarEndFrame;
            })
            
        }, completion: { (completed: Bool) -> Void in
            
            rootView!.removeFromSuperview()
            
            var transitionWasCancelled = transitionContext.transitionWasCancelled()
            if (transitionWasCancelled) {
                transitionContext.containerView().superview!.addSubview(rootСontainerView)
            }
            if (transitionContext.direction() == AnimatedTransitioningDirection.Left && !transitionWasCancelled) {
                transitionContext.containerView().superview!.addSubview(rootСontainerView)
            }
            transitionContext.completeTransition(!transitionWasCancelled)
        })
    }
    
    func animationEnded(transitionCompleted: Bool) {
    }
}
