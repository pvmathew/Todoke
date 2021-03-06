//
//  HelpViewController.swift
//  Todoke
//
//  Created by Pavin Mathew on 4/18/19.
//  Copyright © 2019 Pavin Mathew. All rights reserved.
//

import UIKit

class HelpViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "helpPage1"),
                self.newVc(viewController: "helpPage2"),
                self.newVc(viewController: "helpPageEnd")]
    }()
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            //return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        
        
        guard orderedViewControllersCount != nextIndex else {
            //return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
            //navigationController?.popViewController(animated: true)
            //view.removeFromSuperview()
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            //navigationController?.popViewController(animated: true)
            //view.removeFromSuperview()
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
    
    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderedViewControllers[0].view.backgroundColor = UIColor.init(red: 33/255, green: 203/255, blue: 156/255, alpha: 1)
        orderedViewControllers[1].view.backgroundColor = UIColor.init(red: 33/255, green: 203/255, blue: 156/255, alpha: 1)
        
        self.dataSource = self
        self.delegate = self
        
        configurePageControl()
        
        
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }

        // Do any additional setup after loading the view.
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = 2
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    // MARK: Delegate functions
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: pageContentViewController)!
        if finished == true && self.pageControl.currentPage == 1 && previousViewControllers[0] == orderedViewControllers[1] {
            //if the animation completes on the last page, remove the pageviewcontroller's view
            view.removeFromSuperview()
        }
    
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
