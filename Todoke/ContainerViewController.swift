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
    
    // To help keep track of the current state of the side panels
    enum SlideOutState {
        case leftPanelCollapsed
        case leftPanelExpanded
    }
    
    var currentState: SlideOutState = .leftPanelCollapsed {
        didSet {
            if (currentState == .leftPanelExpanded) {
                showShadowBelowCenterViewController(true)
            }
        }
    }
    // Since the side menu view controller will be added and removed at various times, it might not always have a value
    var leftViewController: SidePanelViewController?
    
    // The width in points that the original center view will be left visible after swipe
    let centerPanelExpandedOffset: CGFloat = 60
    var themeViewController: UIViewController!
    
    var helpViewController: UIViewController!
    var helpButton: UIButton!
    
    var centerViewController: TodokeTableViewController!
    var centerNavigationController: UINavigationController!
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    let firstRun = UserDefaults.standard.bool(forKey: "firstRun") as Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !firstRun { //If it's the first run
            UserDefaults.standard.set(true, forKey: "firstRun")
            UserDefaults.standard.set(0, forKey: "theme")
        }
        
        // Create centerViewController
        centerViewController = UIStoryboard.centerViewController()
        // Set it's delegate to be containerViewController
        // This way, it can tell containerViewController when to show and hide the side panels
        centerViewController.delegate = self
        // Wrap centerViewController into a navigationController
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        // Push the navigationControllerView onto containerViewController's view
        view.addSubview(centerNavigationController.view)
        // Set centerNavigationController to be containerViewController's child
        addChild(centerNavigationController)
        centerNavigationController.didMove(toParent: self)
        
        // Create pan gesture to open and close the side menu
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        // Make it so it doesnt interfere with moving of cells
        panGesture.cancelsTouchesInView = false
        // Add it to centerViewController (which is the main table view)
        centerNavigationController.view.addGestureRecognizer(panGesture)
        
        tooltipSetup()
    }
    
    
    func tooltipSetup() {
        helpButton = UIButton(type: .custom)
        helpButton.frame = CGRect(x: view.frame.width - 100, y: view.frame.height - 100 , width: 70, height: 70)
        helpButton.layer.cornerRadius = 0.5 * helpButton.bounds.size.width
        helpButton.clipsToBounds = true
        let color = UIColor.init(red: 33/255, green: 203/255, blue: 156/255, alpha: 1)
        
        helpButton.backgroundColor = color
        helpButton.setTitleColor(color, for: .selected)
        helpButton.setTitle("?", for: .normal)
        helpButton.titleLabel?.font = .boldSystemFont(ofSize: 32)

        helpButton.addTarget(self, action: #selector(helpButton(sender:)), for: .touchUpInside)

        
        helpButton.layer.shadowColor = UIColor.black.cgColor
        helpButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        helpButton.layer.masksToBounds = false
        helpButton.layer.shadowRadius = 3.0
        helpButton.layer.shadowOpacity = 0.25
        
        centerNavigationController.view.addSubview(helpButton)
    }
    
    @objc func helpButton(sender: UIButton) {
        
        if sender.isSelected == false {
            sender.isSelected = true
            UIView.animate(withDuration: 0.5, animations: {
                sender.transform = CGAffineTransform(scaleX: 24, y: 24)
            }) { (true) in
                print("Finished enlarging uiButton, now need to create a new view")
                sender.transform = CGAffineTransform.identity
                sender.isSelected = false
                self.helpViewController = UIStoryboard.helpViewController()
                self.view.addSubview(self.helpViewController.view)
                
            }
        }
    }
    
}

private extension UIStoryboard {
  
    static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
  
    static func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? SidePanelViewController
    }
  
    static func centerViewController() -> TodokeTableViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "CenterViewController") as? TodokeTableViewController
    }
    
    static func themeViewController() -> ThemeViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "ThemeViewController") as? ThemeViewController
    }
    
    static func helpViewController() -> HelpViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController
    }
}

// MARK: CenterViewController delegate

extension ContainerViewController: TodokeTableViewControllerDelegate {
    
    func clearAll() {
        print("Clear All button was pressed")
        toggleLeftPanel()
        
        UIApplication.shared.sendAction(centerViewController.navigationItem.leftBarButtonItem!.action!, to: centerViewController.navigationItem.leftBarButtonItem!.target, from: self, for: nil)
    }
    
    func enableReordering() {
        print("Reorder Items button was pressed")
        toggleLeftPanel()
        centerViewController.activateEditMode()
    }
    
    func pressHelp() {
        print(#function)
        helpButton.sendActions(for: .touchUpInside)
    }
    
    func showThemes() {
        print("Change Theme button was pressed")
        toggleLeftPanel()
        themeViewController = UIStoryboard.themeViewController()
        
        centerNavigationController.pushViewController(themeViewController, animated: true)
    }
    
    func toggleLeftPanel() {
        print(#function)
        if (currentState == .leftPanelCollapsed) {
            // Add side panel view controller and expand
            addLeftPanelViewController()
            animateLeftPanel(shouldExpand: true)
        } else {
            // Re-hide mentu
            animateLeftPanel(shouldExpand: false)
        }
    }
    
    func addLeftPanelViewController() {
        // Make sure left panel VC hasn't been made yet
        guard leftViewController == nil else { return }
        
        //Then make it and add it as a child
        if let vc = UIStoryboard.leftViewController() {
            vc.delegate = self
            addChildSidePanelController(vc)
            leftViewController = vc
        }
    }
    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        // Insert side panel view under center view controller's view (z-index = 0)
        view.insertSubview(sidePanelController.view, at: 0)
        // Set it to be child of container view controller
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            // Set state to open
            currentState = .leftPanelExpanded
            // Animate opening
            animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                // Set state to closed
                self.currentState = .leftPanelCollapsed
                // Remove view and delete previous instance of the view controller
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut, animations: {
                        self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func showShadowBelowCenterViewController(_ shouldShowShadow: Bool) {
        
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 1.5
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }

}

extension UINavigationController {
    // Ask top controller for its status bar style and update accordingly
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        switch recognizer.state {
        case .began: // When the panning begins
            if currentState == .leftPanelCollapsed {
                if gestureIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                    showShadowBelowCenterViewController(true)
                } else {
                    // Cancel gesture if trying to swift left
                    recognizer.state = .cancelled
                }
            }
            
        case .changed: // As it's moving, move the view it was used on along with it
            if let rview = recognizer.view {
                rview.center.x = rview.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)

            }
            
        case .ended: // When panning ends
            if let _ = leftViewController,
                let rview = recognizer.view {
                // Animate side panel fully open or closed depending on whether finger
                // has moved more or less than halfway
                let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            
        default:
            break
        }

    }
}

