/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
    
    var centerViewController: TodokeTableViewController!
    var centerNavigationController: UINavigationController!
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create centerViewController
        centerViewController = UIStoryboard.centerViewController()
        // Set it's delegate to be containerViewController
        // This way, it can tell containerViewController when to show and hide the side panels
        centerViewController.delegate = self
        
        // Wrap centerViewController into a navigationController so views can be pushed to it
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        // Push the navigationControllerView onto containerViewController's view
        view.addSubview(centerNavigationController.view)
        // Set centerNavigationController to be containerViewController's child
        // This means that it'll be responsible for handling events when containerviewController tells it to
        addChild(centerNavigationController)
        centerNavigationController.didMove(toParent: self)
        
    }
}

private extension UIStoryboard {
  
    static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
  
//    static func leftViewController() -> SidePanelViewController? {
//        return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? SidePanelViewController
//    }
//
//    static func rightViewController() -> SidePanelViewController? {
//        return mainStoryboard().instantiateViewController(withIdentifier: "RightViewController") as? SidePanelViewController
//    }
  
    static func centerViewController() -> TodokeTableViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "CenterViewController") as? TodokeTableViewController
    }
}

// MARK: CenterViewController delegate

extension ContainerViewController: TodokeTableViewControllerDelegate {
    
    func toggleLeftPanel() {
    }
    
    func toggleRightPanel() {
    }
    
    func addLeftPanelViewController() {
    }
    
    func addRightPanelViewController() {
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
    }
    
    func animateRightPanel(shouldExpand: Bool) {
    }
}

extension UINavigationController {
    // Ask top controller for its status bar style and update accordingly
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
