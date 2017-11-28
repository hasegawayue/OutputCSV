//
//  ViewController.swift
//  OutputCSV
//
//  Created by User on 2017/11/28.
//  Copyright © 2017年 User. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    //csvファイル名
    let textFileName = "test.csv"
    
    // csvの中身を格納する変数
    let initialText = "a,b,c¥n d,e,f¥n g, h i¥n"
    
    //csv送信先
    let recipients = ["hasegawayue@nttdata.co.jp"]
    var fileUrl = ""
    
    @IBAction func sendCSV(_ sender: Any) {
        print("hello2")
        saveCSV()
        sendEmail()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func saveCSV() {
        print("Saving CSV")
        //改行区切りで部活配列を連結する。
       // let outputStr = dataList.joined(separator: "\n")

        // DocumentディレクトリのfileURLを取得
        if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            
            // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
            let targetTextFilePath = documentDirectoryFileURL.appendingPathComponent(textFileName)
            
            fileUrl = try! String(contentsOf:targetTextFilePath)
           
            print("書き込むファイルのパス: \(targetTextFilePath)")
            
            do {
                try initialText.write(to: targetTextFilePath, atomically: true, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print("failed to write: \(error)")
            }
            
            do {
                let text2 = try String(contentsOf: targetTextFilePath, encoding: .utf8)
                print(text2)
            }
            catch {/* error handling here */}
 
            
            
        }

        1
    }
    
    func sendEmail() {
        //Check to see the device can send email.
        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setToRecipients(recipients)
            mailComposer.setSubject("Clarifai CSV output")
            mailComposer.setMessageBody("Clarifai CSV output", isHTML: false)
            

            if let fileData = NSData(contentsOfFile: fileUrl) {
                print("File data loaded.")
                mailComposer.addAttachmentData(fileData as Data, mimeType: "text/plain", fileName: "swifts")
            }
            self.present(mailComposer, animated: true, completion: nil)

        }else{
            print("no e-mail")
        }
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: Error!,_: Error!) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

