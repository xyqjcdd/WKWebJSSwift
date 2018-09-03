//
//  ViewController.swift
//  WKWebView-Swift
//
//  Created by CCX on 2018/9/3.
//  Copyright © 2018年 xyq. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class ViewController: UIViewController,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate {

    lazy var loginWebView: WKWebView = {
        let config = WKWebViewConfiguration();
        config.userContentController.add(self, name: "loginApp");
        config.userContentController.add(self, name: "logintest");
        let webView = WKWebView(frame: .zero, configuration: config);
        webView.navigationDelegate = self;
        webView.uiDelegate = self;
        return webView
    }()
    
    lazy var btn: UIButton = {
        let btn = UIButton(type: .custom);
        btn.setTitle("test", for: .normal);
        btn.backgroundColor = .blue;
        btn.addTarget(self, action:#selector(testAction) , for: .touchUpInside);
        return btn;
    }()
    
    //"showName("+"'test'"+","+"'123'"+")"  test 要加单引号，否则js不识别
    @objc func testAction() {
        let jsStr = "showName("+"'test'"+","+"'123'"+")"
        self.loginWebView.evaluateJavaScript(jsStr) { (result, error) in
            print("error == \(error.debugDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.loginWebView);
        self.view.addSubview(self.btn);
        
        let path = Bundle.main.url(forResource: "login", withExtension: "html")
        self.loginWebView.load(NSURLRequest(url: path!) as URLRequest)
        
        
        self.loginWebView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(20);
            make.left.right.equalTo(self.view);
            make.height.equalTo(200);
        }
        
        self.btn.snp.makeConstraints { (make) in
            make.top.equalTo(self.loginWebView.snp.bottom).offset(20);
            make.centerX.equalTo(self.view.snp.centerX);
            make.size.equalTo(CGSize(width: 100, height: 50));
        }
    }
    
    //js -> swift
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let dic = message.body as! NSDictionary
        if message.name == "loginApp" {
            print("name === \(dic["name"] ?? "")")
        }else if message.name == "logintest" {
            print("name ===  \(dic["name"] ?? "") , password ===  \(dic["password"] ?? "")")
        }
    }

    //alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "alert", message: "js -> alert", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil);
    }
    
    //confirm
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let confirm = UIAlertController(title: "confirm", message: "js -> confirm", preferredStyle: .alert);
        confirm.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        confirm.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            completionHandler(false)
        }))
        self.present(confirm, animated: true, completion: nil);
    }
    
    //prompt
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let prompt = UIAlertController(title: "prompt", message: "js -> prompt", preferredStyle: .alert);
        prompt.addTextField { (textfield) in
            textfield.text = "输入框";
        }
        prompt.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler(prompt.textFields?.last?.text)
        }))
        self.present(prompt, animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

