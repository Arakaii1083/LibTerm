//
//  SettingsTableViewController.swift
//  LibTerm
//
//  Created by Adrian Labbe on 10/16/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

import UIKit
import ObjectUserDefaults
import SafariServices
import StoreKit

/// A View controller with info about the app and some settings.
class SettingsTableViewController: UITableViewController, SKStoreProductViewControllerDelegate {
    
    /// The object representing the terminal font size.
    static let fontSize = ObjectUserDefaults.standard.item(forKey: "fontSize")
    
    /// The object representig the terminal caret style.
    static let caretStyle = ObjectUserDefaults.standard.item(forKey: "caretStyle")
    
    private struct ProjectsIndexPaths {
        private init() {}
        
        static let ios_system = IndexPath(row: 0, section: 1)
        static let openTerm = IndexPath(row: 1, section: 1)
        static let inputAssistant = IndexPath(row: 2, section: 1)
        static let tabView = IndexPath(row: 3, section: 1)
        static let highlightr = IndexPath(row: 4, section: 1)
        static let objectUserDefaults = IndexPath(row: 5, section: 1)
        static let python3_ios = IndexPath(row: 6, section: 1)
        static let other = IndexPath(row: 7, section: 1)
        
        static let libTerm = IndexPath(row: 0, section: 2)
        
        static let pisth = IndexPath(row: 0, section: 3)
        static let pyto = IndexPath(row: 1, section: 3)
        static let edidown = IndexPath(row: 2, section: 3)
    }
    
    /// Closes this View controller.
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: {
            if let term = (UIApplication.shared.keyWindow?.rootViewController as? TerminalTabViewController)?.visibleViewController as? LTTerminalViewController {
                term.terminalTextView.attributedText = NSAttributedString(string: "")
                term.tprint(term.attributedConsole.string)
            }
        })
    }
    
    /// The label containing the current font size.
    @IBOutlet weak var fontSizeLabel: UILabel!
    
    /// The stepper for changing the font size.
    @IBOutlet weak var fontSizeStepper: UIStepper!
    
    /// The segmented control for changing 
    @IBOutlet weak var caretStyleSegmentedControl: UISegmentedControl!
    
    /// Called for changing the font size.
    @IBAction func fontSizeChanged(_ sender: UIStepper) {
        SettingsTableViewController.fontSize.doubleValue = sender.value
        fontSizeLabel.text = "\(sender.value)"
    }
    
    /// Called for changing the caret style.
    @IBAction func caretStyleChangedChanged(_ sender: UISegmentedControl) {
        SettingsTableViewController.caretStyle.integerValue = sender.selectedSegmentIndex
    }
    
    // MARK: - Table view controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caretStyleSegmentedControl.selectedSegmentIndex = SettingsTableViewController.caretStyle.integerValue
        fontSizeStepper.value = SettingsTableViewController.fontSize.doubleValue
        fontSizeLabel.text = "\(SettingsTableViewController.fontSize.doubleValue)"
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        func present(appWithID id: String) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let appStore = SKStoreProductViewController()
            appStore.delegate = self
            appStore.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:id], completionBlock: nil)
            self.present(appStore, animated: true, completion: nil)
        }
        
        var projectPath: String?
        switch indexPath {
        case ProjectsIndexPaths.ios_system:
            projectPath = "holzschu/ios_system"
        case ProjectsIndexPaths.openTerm:
            projectPath = "louisdh/openterm"
        case ProjectsIndexPaths.inputAssistant:
            projectPath = "IMcD23/InputAssistant"
        case ProjectsIndexPaths.tabView:
            projectPath = "IMcD23/TabView"
        case ProjectsIndexPaths.highlightr:
            projectPath = "raspu/Highlightr"
        case ProjectsIndexPaths.objectUserDefaults:
            projectPath = "ColdGrub1384/ObjectUserDefaults"
        case ProjectsIndexPaths.python3_ios:
            projectPath = "holzschu/Python3_ios"
        case ProjectsIndexPaths.other:
            projectPath = "ColdGrub1384/LibTerm/blob/master/PYTHON_ACKNOWLEDGMENTS.md"
        case ProjectsIndexPaths.libTerm:
            projectPath = "ColdGrub1384/LibTerm"
        case ProjectsIndexPaths.pisth:
            present(appWithID: "1331070425")
        case ProjectsIndexPaths.pyto:
            present(appWithID: "1436650069")
        case ProjectsIndexPaths.edidown:
            present(appWithID: "1439139639")
        default:
            break
        }
        if let path = projectPath, let url = URL(string: "https://github.com/\(path)") {
            self.present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
    
    // MARK: - Store product view controller delegate
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
