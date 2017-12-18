//
//  PageView.swift
//  HouseKeeping
//
//  Created by Apple-1 on 6/8/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class PageView3: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages3 = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryAll")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryCompleted")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryOnprogress")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryPending")
        let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryDND")
        pages3.append(page1)
        pages3.append(page2)
        pages3.append(page3)
        pages3.append(page4)
        pages3.append(page5)
        setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //OperationQueue.main.addOperation{
            NotificationCenter.default.addObserver(self, selector: #selector(self.HclickedAll), name: NSNotification.Name(rawValue: "HclickedAll"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HclickedCompleted), name: NSNotification.Name(rawValue: "HclickedCompleted"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HclickedOnProgress), name: NSNotification.Name(rawValue: "HclickedOnProgress"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HclickedPending), name: NSNotification.Name(rawValue: "HclickedPending"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HclickedDND), name: NSNotification.Name(rawValue: "HclickedDND"), object: nil)
        //}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // print("viewWillDisappear 3 ")
        NotificationCenter.default.removeObserver(self)
    }
    
    func HclickedAll() {
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryAll")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryCompleted")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryOnprogress")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryPending")
        let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryDND")
        pages3.append(page1)
        pages3.append(page2)
        pages3.append(page3)
        pages3.append(page4)
        pages3.append(page5)
        setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    func HclickedCompleted() {
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryAll")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryCompleted")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryOnprogress")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryPending")
        let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryDND")
        pages3.append(page1)
        pages3.append(page2)
        pages3.append(page3)
        pages3.append(page4)
        pages3.append(page5)
        setViewControllers([page2], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    func HclickedOnProgress() {
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryAll")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryCompleted")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryOnprogress")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryPending")
        let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryDND")
        pages3.append(page1)
        pages3.append(page2)
        pages3.append(page3)
        pages3.append(page4)
        pages3.append(page5)
        setViewControllers([page3], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    func HclickedPending() {
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryAll")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryCompleted")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryOnprogress")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryPending")
        let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryDND")
        pages3.append(page1)
        pages3.append(page2)
        pages3.append(page3)
        pages3.append(page4)
        pages3.append(page5)
        setViewControllers([page4], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func HclickedDND() {
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryAll")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryCompleted")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryOnprogress")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryPending")
        let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "tblHistoryDND")
        pages3.append(page1)
        pages3.append(page2)
        pages3.append(page3)
        pages3.append(page4)
        pages3.append(page5)
        setViewControllers([page5], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages3.index(of: viewController)!
        let previousIndex = abs((currentIndex - 1) % pages3.count)
        //print("previousIndex  " , previousIndex)
        return pages3[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages3.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages3.count)
        //print("nextIndex  " , nextIndex)
        return pages3[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let viewTag = pageViewController.viewControllers!.first!.view.tag
        if viewTag == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HrefreshAll"), object: nil)
        }
        if viewTag == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HrefreshCompleted"), object: nil)
        }
        if viewTag == 2 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HrefreshOnprogress"), object: nil)
        }
        if viewTag == 3 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HrefreshPending"), object: nil)
        }
        if viewTag == 4 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HrefreshDND"), object: nil)
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages3.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
