//
//  ExerciseVideoViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 10/07/2023.
//

import Foundation
import UIKit
import WebKit

class ExerciseVideoViewController: UIViewController {
    
    var webView: WKWebView!
    var youtubeSearchQuery: String = ""
    
    var loadingView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationTitle()
        
        let youtubeQuery = "https://www.youtube.com/results?search_query=\(youtubeSearchQuery)"
        let url = URL(string: youtubeQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        let request = URLRequest(url: url!)
        
        webView.load(request)
        
        // setupLoadingIndicator()
    }
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    //    func setupLoadingIndicator() {
    //        loadingView = UIStackView()
    //
    //        let loadingIndicator = UIActivityIndicatorView()
    //        let loadingLabel = UILabel()
    //
    //        loadingIndicator.hidesWhenStopped = true
    //        loadingIndicator.startAnimating()
    //        loadingIndicator.center = view.center
    //
    //        loadingLabel.text = "Loading..."
    //
    //        loadingView.addArrangedSubview(loadingIndicator)
    //        loadingView.addArrangedSubview(loadingLabel)
    //
    //        loadingView.axis = .vertical
    //        loadingView.spacing = 12
    //        loadingView.distribution = .fillEqually
    //        loadingView.center = view.center
    //
    //        loadingView.translatesAutoresizingMaskIntoConstraints = false
    //
    //        view.addSubview(loadingView)
    //    }
    
    private func setupNavigationTitle() {
        let text = youtubeSearchQuery.capitalized
        
        let titleRange = text.range(of: text)!
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)], range: NSRange(titleRange, in: text))
        
        let textLabel = UILabel()
        textLabel.attributedText  = attributedString
        textLabel.textAlignment = .center
        
        //Stack View
        let stackView   = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 12.0
        stackView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        stackView.addArrangedSubview(textLabel)
        
        navigationItem.titleView = stackView
        
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}

extension ExerciseVideoViewController: WKUIDelegate, WKNavigationDelegate {
    //    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    //        loadingView.isHidden = false
    //    }
    //
    //    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    //        loadingView.isHidden = true
    //    }
    //
    //    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    //        loadingView.isHidden = true
    //    }
}
