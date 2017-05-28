//
//  FilePickerViewController.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/27/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit
import SnapKit

class File {
    
    static var dateFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        
        return formatter
    }()
    
    let url: URL
    let attributes: [FileAttributeKey : Any]
    
    var attributesDescription: String {
        
        if let modifiedDate = attributes[FileAttributeKey.modificationDate] as? Date {
            return "Modified: " + File.dateFormatter.string(from: modifiedDate)
        }
        
        return ""
    }
    
    init(url: URL) {
        self.url = url
        if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
            self.attributes = attributes
        }
        else {
            attributes = [FileAttributeKey : Any]()
        }
    }
    
    static func from(_ urls:[URL]) -> [File] {
        return urls.map{ File(url: $0) }
    }
    
}

protocol FilePickerViewControllerDelegate: class {
    func filePickerViewController(_ filePickerViewController: FilePickerViewController, didSelectFile file: URL)
}

class FilePickerViewController: UITableViewController {
    
    var identifier: String = ""
    weak var delegate: FilePickerViewControllerDelegate?    
    
    var fileExtensions = [String]() {
        didSet {
            let urls = FilePickerViewController.findFiles(withExtensions: fileExtensions)
            self.files = File.from(urls)
            self.tableView.reloadData()
            
            self.noFilesLabel.isHidden = (self.files.count > 0)
        }
    }
    
    var files = [File]()
    
    var noFilesLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.noFilesLabel)
        self.noFilesLabel.text = "No files found matching \(fileExtensions.map({ "*.\($0)" }).joined(separator: "/"))"
        self.noFilesLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)
        self.noFilesLabel.textAlignment = .center
        
        self.noFilesLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(-44)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).offset(-40)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileCell.reuseIdentifier, for: indexPath) as! FileCell
        
        let file = files[indexPath.row]
        cell.textLabel?.text = file.url.lastPathComponent
        cell.detailTextLabel?.text = file.attributesDescription

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let file = files[indexPath.row]
        delegate?.filePickerViewController(self, didSelectFile: file.url)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension FilePickerViewController {
    
    static func fileExists(filename: String) -> Bool {
        let files = findFiles(withExtensions: nil)
        let filenames = files.map({ $0.lastPathComponent })
        return filenames.contains(filename)
    }
    
    static func findFiles(withExtensions ext: [String]?) -> [URL] {
        
        let documentsURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
            if let ext = ext {
                return directoryContents.filter{ ext.contains($0.pathExtension) }
            }
            else {
                return directoryContents
            }
            
        } catch {
            return []
        }
    }
    
    static func install(filePaths: [String]) {
        
        let documentsURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileManager = FileManager.default
        
        do {
            for filePath in filePaths {
                let sourceURL = URL(fileURLWithPath: filePath)
                let destURL = documentsURL.appendingPathComponent(sourceURL.lastPathComponent)
                try fileManager.copyItem(at: sourceURL, to: destURL)
            }
        } catch {
            print(error)
        }
    }
    
    static func save(jsonObject: Any, asFilename filename: String) {
     
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                save(jsonString: jsonString, asFilename: filename)
            }
        }
        catch {
            print("Error while decoding json \(filename)")
        }
    }
    
    static func load(jsonObjectNamed filename: String) -> Any? {
     
        if let jsonString = load(jsonStringNamed: filename), let data = jsonString.data(using: .utf8) {
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                return jsonObject
            }
            catch {
                print("Error while encoding json \(filename)")
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    static func save(jsonString: String, asFilename filename: String) {
        
        let documentsURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        do {
            try jsonString.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {
            print("Error while saving json \(filename)")
        }
    }
    
    static func load(jsonStringNamed filename: String) -> String? {
        
        let documentsURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        do {
            let json = try String(contentsOf: fileURL, encoding: .utf8)
            return json
        }
        catch {
            print("Error while loading json \(filename)")
            return nil
        }
    }
}
