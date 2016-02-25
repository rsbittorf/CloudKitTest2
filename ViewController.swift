//
//  ViewController.swift
//  CloudKitTest2
//
//  Created by Ryan's MacBook Pro on 2/19/16.
//  Copyright © 2016 bittorf. All rights reserved.
//

import UIKit
import CloudKit
import MobileCoreServices

class ViewController: UIViewController {
    
    var publicDatabase: CKDatabase?
    let container = CKContainer.defaultContainer()
    var currentRecord: CKRecord?
    
    var bool1 = false
    

    @IBOutlet weak var labelShowingWelcomeField: UILabel!
    @IBOutlet weak var labelBOOLvalue: UILabel!
    
    @IBOutlet weak var textForNewString: UITextField!
    @IBOutlet weak var textForNewNumber: UITextField!
    
    
    @IBOutlet weak var a1: UIButton!
    
    @IBOutlet weak var a2: UIButton!
    
    @IBOutlet weak var a3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Notice I never created the database in code.  I did all that in the Cloud Kit dashboard
        
        goFetchCurrentDataFromCloudKit()
 
    }
    
    func showBoolLableText()
    {
        if(bool1 == true)
        {
            labelBOOLvalue.text = "BOOL is True"
        } else
        {
            labelBOOLvalue.text = "BOOL is False"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressUpdateData(sender: AnyObject) {
        
        goFetchCurrentDataFromCloudKit()
    }
    
    
    
    func goFetchCurrentDataFromCloudKit()
    {
        
        thisRecordType("Intro", andThisDispatchID: 1)
      //  thisRecordType("BoolData", andThisDispatchID: 2)
        
    }
    
    func thisRecordType(recordString: String, andThisDispatchID: Int)
    {
       
        publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: recordString, predicate: predicate)
        publicDatabase?.performQuery(query, inZoneWithID: nil, completionHandler: {(results, error) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print("got yah!!! ")
                print("yikes  = \(results![0])")
                
                let record = results![0]
                self.currentRecord = record
                
                if(andThisDispatchID == 1)
                {
                self.labelShowingWelcomeField.text = record.objectForKey("welcomeMessage") as? String
                    
                    let myButtonA1Text = record.objectForKey("a1Text") as? String
                    self.a1.setTitle(myButtonA1Text, forState: UIControlState.Normal)
                    
                    let myButtonA2Text = record.objectForKey("a2Text") as? String
                    self.a2.setTitle(myButtonA2Text, forState: UIControlState.Normal)
                }
                
                if(andThisDispatchID == 2)
                {
                    let whichInt = record.objectForKey("bool1IsOFF") as! Int
                    print("whichInt = \(whichInt)")
                    if(whichInt == 1)
                    {
                        self.bool1 = true
                    }
                    else
                    {
                        self.bool1 = false
                    }

                    self.showBoolLableText()

                }
                
            }
        })

        }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // this method simply hides the keyboard
        textForNewString.endEditing(true)
        textForNewNumber.endEditing(true)
    }

    @IBAction func pressWriteNewData(sender: AnyObject) {
        
        if let record = currentRecord{
            
            record.setObject(textForNewString.text, forKey: "welcomeMessage")
            saveRecord(record)

       
        }
    }
    
    func saveRecord(thisRecord: CKRecord)
    {
        
        publicDatabase?.saveRecord(thisRecord, completionHandler:
            ({returnRecord, error in
                if let err = error {
                    dispatch_async(dispatch_get_main_queue()) {
                        print("error = \(err.localizedDescription)")
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        print("Record updated successfully")
                    }
                }
            }))
        
        }
    
    @IBAction func pressA1(sender: AnyObject) {
        
        a1.setTitle("X", forState: UIControlState.Normal)
        if let record = currentRecord{
            
            record.setObject("X", forKey: "a1Text")
            saveRecord(record)
  
        }
    
        
    }
    @IBAction func pressA2(sender: AnyObject) {
        
        a2.setTitle("O", forState: UIControlState.Normal)
        if let record = currentRecord{
            
            record.setObject("O", forKey: "a2Text")
            saveRecord(record)
            
        }
    }
    @IBAction func pressA3(sender: AnyObject) {
    }
    

}

