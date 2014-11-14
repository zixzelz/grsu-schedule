//
//  RMSidebarControllerAnimatedTransitioning.swift
//  SubPage
//
//  Created by Ruslan Maslouski on 9/19/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

enum AnimatedTransitioningDirection : Int {
    case Left
    case Right
}

enum AnimatedTransitioningAction : Int {
    case Present
    case Dismiss
}

protocol RMSidebarControllerAnimatedTransitioning : NSObjectProtocol {

    func transitionDuration(transitionContext: RMSidebarControllerContextTransitioning) -> NSTimeInterval
    func animateTransition(transitionContext: RMSidebarControllerContextTransitioning)
    func replaceAnimateTransition(transitionContext: RMSidebarControllerContextTransitioning)
    func animationEnded(transitionCompleted: Bool)
}

protocol RMSidebarControllerContextTransitioning : NSObjectProtocol {
    
    func containerView() -> UIView
    func sidebarView() -> UIView
    func rootСontainerView() -> UIView
    func rootView() -> UIView?
    func newRootView() -> UIView?

    func direction() -> AnimatedTransitioningDirection
    func action() -> AnimatedTransitioningAction
    func offset() -> CGFloat
   
    func transitionWasCancelled() -> Bool

    func completeTransition(didComplete: Bool)
}