//
//  PageView.swift
//  HouseKeeping
//
//  Created by Apple-1 on 6/8/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class PageView: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PageView")
        self.delegate = self
        self.dataSource = self
        //let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "All")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Completed")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "OnProgress")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Pending")
        let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "DND")
        pages.append(page2)
        //pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        pages.append(page5)
        setViewControllers([page2], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //OperationQueue.main.addOperation{
        NotificationCenter.default.addObserver(self, selector: #selector(self.clickedAll), name: NSNotification.Name(rawValue: "clickedAll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clickedCompleted), name: NSNotification.Name(rawValue: "clickedCompleted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clickedOnProgress), name: NSNotification.Name(rawValue: "clickedOnProgress"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clickedPending), name: NSNotification.Name(rawValue: "clickedPending"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clickedDND), name: NSNotification.Name(rawValue: "clickedDND"), object: nil)
        //}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //print("viewWillDisappear")
        NotificationCenter.default.removeObserver(self)
        // NotificationCenter.default.removeObserver(self, name: Notification.Name("clickedAll"), object: nil)
        // NotificationCenter.default.removeObserver(self, name: Notification.Name("clickedCompleted"), object: nil)
        
        //NotificationCenter.default.removeObserver(name: NSNotification.Name(rawValue: "clickedAll"), object: nil)
        //NotificationCenter.default.removeObserver(name: NSNotification.Name(rawValue: "clickedCompleted"), object: nil)
    }
    
    func clickedAll() {
            //let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "All")
            let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Completed")
            let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "OnProgress")
            let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Pending")
            let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "DND")
            pages.append(page2)
            //pages.append(page2)
            pages.append(page3)
            pages.append(page4)
            pages.append(page5)
            print("Clicked All")
            setViewControllers([page2], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
            
            //do{
            //  try NotificationCenter.default.removeObserver(self)
            //} catch{}
    }
    
    func clickedCompleted() {
            //let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "All")
            let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Completed")
            let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "OnProgress")
            let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Pending")
            let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "DND")
            //pages.append(page1)
            pages.append(page2)
            pages.append(page3)
            pages.append(page4)
            pages.append(page5)
            print("Clicked Completed")
            setViewControllers([page2], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
            
            //do{
            //  try NotificationCenter.default.removeObserver(self)
            //} catch{}
    }
    
    func clickedOnProgress() {
        print("Clicked progress")
        //count = true
        //print("onprog ", count! )
        //if count! == true {
        //let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "All")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Completed")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "OnProgress")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Pending")
        let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "DND")
        //pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        pages.append(page5)
        setViewControllers([page3], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        // count = false
        //}
    }
    func clickedPending() {
        print("Clicked pending")
        //count = true
        //print("pending ", count! )
        //if count! == true {
        //let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "All")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Completed")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "OnProgress")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Pending")
        let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "DND")
        //pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        pages.append(page5)
        setViewControllers([page4], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        //  count = false
        //}
    }
    
    func clickedDND() {
        print("Clicked dnd")
        //count = true
        // print("dnd ", count! )
        //if count! == true {
        //let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "All")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Completed")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "OnProgress")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Pending")
        let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "DND")
        //pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        pages.append(page5)
        setViewControllers([page5], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        // count = false
        //}
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let previousIndex = abs((currentIndex - 1) % pages.count)
        //print("previousIndex  " , previousIndex)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        //print("nextIndex  " , nextIndex)
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let viewTag = pageViewController.viewControllers!.first!.view.tag
        if viewTag == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ArefreshAll"), object: nil)
        }
        if viewTag == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ArefreshCompleted"), object: nil)
        }
        if viewTag == 2 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ArefreshOnprogress"), object: nil)
        }
        if viewTag == 3 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ArefreshPending"), object: nil)
        }
        if viewTag == 4 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ArefreshDND"), object: nil)
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
