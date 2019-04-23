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

class SidePanelViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    var delegate: TodokeTableViewControllerDelegate?
    var menuItems = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuItems.append(MenuItem(name: "Reorder Tasks", iconName: "reorder", detail: "You're a mess."))
        menuItems.append(MenuItem(name: "Clear All", iconName: "clearall", detail: "A clean start, maybe?"))
        menuItems.append(MenuItem(name: "Change Theme", iconName: "rgb", detail: "Afraid of the dark? BAH!"))
        menuItems.append(MenuItem(name: "Settings", iconName: "settings", detail: "To be implemented."))
        menuItems.append(MenuItem(name: "Help", iconName: "sloth", detail: "Send help!"))
        
        // So lines won't be pushed right by menu icons
        tableView.separatorInset.left = 10
        
        tableView.reloadData()
    }
    
}

// MARK: Table View Data Source
extension SidePanelViewController: UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = MenuCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "MenuItem")
        cell.imageView!.clipsToBounds = true
        
        cell.textLabel?.text = menuItems[indexPath.row].name
        cell.detailTextLabel?.text = menuItems[indexPath.row].detail
        cell.imageView?.image = UIImage(named: menuItems[indexPath.row].iconName)
        
        return cell
    }
}
// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // Reorder Items was selected
            delegate?.enableReordering?()
        case 1:
            delegate?.clearAll?()
        case 2:
            delegate?.showThemes?()
        case 3:
            print("'Settings' was selected")
        case 4:
            delegate?.toggleLeftPanel?()
            delegate?.pressHelp?()
        default:
            print("Nothing was selected")
        }
    }
}
