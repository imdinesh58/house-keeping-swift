//
//  PageView.swift
//  HouseKeeping
//
//  Created by Apple-1 on 6/8/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class PageView2: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages2 = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "EPendingTasks")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "ECompletedTasks")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "EDNDTasks")
        pages2.append(page1)
        pages2.append(page2)
        pages2.append(page3)
        setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //OperationQueue.main.addOperation{
            NotificationCenter.default.addObserver(self, selector: #selector(self.EclickedPending), name: NSNotification.Name(rawValue: "EclickedPending"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.EclickedCompleted), name: NSNotification.Name(rawValue: "EclickedCompleted"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.EclickedDND), name: NSNotification.Name(rawValue: "EclickedDND"), object: nil)
        //}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //print("viewWillDisappear 2 ")
        NotificationCenter.default.removeObserver(self)
    }

    func EclickedPending() {
        print("Clicked Pending")
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "EPendingTasks")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "ECompletedTasks")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "EDNDTasks")
        pages2.append(page1)
        pages2.append(page2)
        pages2.append(page3)
        setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func EclickedCompleted() {
         print("Clicked Completed")
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "EPendingTasks")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "ECompletedTasks")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "EDNDTasks")
        pages2.append(page1)
        pages2.append(page2)
        pages2.append(page3)
        setViewControllers([page2], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func EclickedDND() {
         print("Clicked DND")
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "EPendingTasks")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "ECompletedTasks")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "EDNDTasks")
        pages2.append(page1)
        pages2.append(page2)
        pages2.append(page3)
        setViewControllers([page3], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages2.index(of: viewController)!
        let previousIndex = abs((currentIndex - 1) % pages2.count)
        return pages2[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages2.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages2.count)
        return pages2[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let viewTag = pageViewController.viewControllers!.first!.view.tag
        if viewTag == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ErefreshPending"), object: nil)
        }
        if viewTag == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ErefreshCompleted"), object: nil)
        }
        if viewTag == 2 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ErefreshDND"), object: nil)
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages2.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
