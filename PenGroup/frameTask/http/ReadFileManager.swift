//
//  RelationManager.swift
//  CathAssist
//


import UIKit


class RelationManager: NSObject {
    
    static let playListeningKey = "play_listening_index_key";

    fileprivate static let instance = RelationManager();
    fileprivate let paramter = NSMutableDictionary();


    
    override init() {
        super.init();
        NotificationCenter.default.addObserver(self, selector: #selector(RelationManager.clearMemery), name: UIApplication.didReceiveMemoryWarningNotification, object: nil);
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self);
    }
    
    
    
    @objc func clearMemery(){
        paramter.removeAllObjects();
    }
    
   class  func setKey(key: RelationFileKey,value: Any?) {
        instance.paramter[key.rawValue] = value;
    }
    class func value(key: RelationFileKey) -> Any? {
        return instance.paramter[key.rawValue];
    }
    class func setKey(key: String,value: Any?) {
        instance.paramter[key] = value;
    }
    class func value(key: String) -> Any? {
        return instance.paramter[key];
    }
    

 
   
    
}



// MARK: -- filemanager

class ReadFileManager: NSObject {
    
    
    fileprivate static let shareManager = ReadFileManager(name:"audio");
    fileprivate var memeryDict = NSMutableDictionary();
    fileprivate var dispatch = DispatchQueue(label: "saveData", attributes: []);
    fileprivate var path : String!
    fileprivate var pathMemery = [String:String]();
    fileprivate let queue: OperationQueue = {
        let queue = OperationQueue();
        queue.maxConcurrentOperationCount = 4;
        return queue;
    }()
    
    public var isExpCheck = false;
    
    fileprivate override init() {
        super.init();
        
    }
    
    fileprivate func setPathName(_ name: String,absPath: String) {
        
        let libray = NSString(string:absPath);

        let rootPath = libray.appendingPathComponent(name);
        let file = FileManager.default;
        do {
            if !file.fileExists(atPath: rootPath) {
                try file.createDirectory(atPath: rootPath, withIntermediateDirectories: true, attributes: nil);
            }
            
        }catch {
            
        }
        self.path = rootPath;
        NotificationCenter.default.addObserver(self, selector: #selector(clearMemery), name: UIApplication.didReceiveMemoryWarningNotification, object: nil);
        
    }
    
    @objc func clearMemery()  {
        memeryDict.removeAllObjects();
        pathMemery.removeAll();
    }
    
    convenience init(name: String,path:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/") {
    
        self.init();
        setPathName(name, absPath: path);
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
}


extension ReadFileManager {
    
    // MARK: - image manager
    class func readImage(_ name: String) -> UIImage? {
        let data = readFileData(name);
        if data != nil {
            return UIImage(data: data!);
        }
        return nil;
    }
    class func saveImage(_ name: String,image: UIImage){
        let data = image.pngData()
        if data != nil {
            writeFile(data!, name: name);
        }
        
    }
    
    // MARK: - data mangare 保存到默认路径 name:文件的名字
    class func  writeFile(_ data : Data , name : String)  {
        ReadFileManager.shareManager.writeFile(data, name: name);
    }
    // 文件的绝对路径
    class func writeFilePath(_ data: Data,path: String) {
        ReadFileManager.shareManager.writeFilePath(data, rootPath: path);
    }
    
    //
    
    class func readFileData(_ name : String) -> Data? {
        return ReadFileManager.shareManager.readFileData(name);
    }

    // 移除文件
    class func moveToFileBy(name: String) {
        let path = readFilePath(name);
        let file = FileManager.default;
        if file.fileExists(atPath: path) {
            try? file.removeItem(atPath: path);
        }
    }
    
    class func readFilePath(_ name : String) ->String {
        
        return ReadFileManager.shareManager.readFilePath(name);
    }
    
    // MARK: 实例方法
    
    func  writeFile(_ data : Data , name : String)  {

        let rootPath = readFilePath(name);
        addMemery(data, key: name as NSString);
        writeFilePath(data, rootPath: rootPath);
        
    }
    
    func isHasFile(_ name: String) -> (has:Bool,path:String) {
        let file = FileManager();
        let rootPath = readFilePath(name);
        let has = file.fileExists(atPath: rootPath);
        return (has,rootPath);
        
    }
    
    func writeFilePath(_ data: Data, rootPath: String){
        
        if data.count < 2 {
            return;
        }
        print("login =\(rootPath)");
        
        let block = BlockOperation { 
            do {
                try data.write(to: URL(fileURLWithPath: rootPath), options: NSData.WritingOptions.fileProtectionMask);
            }catch {
            }
        }
        queue.addOperation(block);
    }
    
    func readFileData(_ name : String) -> Data? {
        
        var data = memeryDict[name] as? Data;
        if data != nil {
            return data;
        }
        let key = readFilePath(name);
        data = try? Data(contentsOf: URL(fileURLWithPath: key));
        
        var keyPath = "";
        
        
        if data != nil {
            addMemery(data!, key: name as NSString);
            keyPath = key;
        }else {
            data = try? Data(contentsOf: URL(fileURLWithPath: name));
            if data != nil {
                addMemery(data!, key: name as NSString);
                keyPath = name;
            }
        }
        
        let exp = checkFileDate(path: keyPath);
        
        return exp ? nil : data;
    }
    
    func checkFileDate(path: String)  -> Bool{
        
        if !isExpCheck {
            return false;
        }
        
        let file = FileManager.default;
        let attibutes = try? file.attributesOfItem(atPath: path);
        
        
        
        guard let createDate = attibutes?[.modificationDate] as? NSDate else{
            return false;
        }

        let timeInter = createDate.timeIntervalSinceNow;
        
        if -timeInter > 1*24*60*60 {
            return true;
        }
        return false;
        


        
    }
    
    
   fileprivate func readFilePath(_ name : String) ->String {
        
        let value = pathMemery[name];
        if value != nil {
            return value!;
        }
        var exten = NSString(string: name).pathExtension.lowercased();
        if exten == "mp3" || exten == "aac" || exten == "wav" || exten == "amr" {
            exten = "." + exten;
        }else {
            exten = ".plist";
        }
    let rootPath = NSString(string: path).appendingPathComponent("\(name.MD5String)\(exten)");
        pathMemery[name] = rootPath;
        return rootPath;
    }
    
    fileprivate func addMemery(_ data: Data,key: NSString){

        if data.count < 10 {
            return;
        }
        
        if memeryDict.count > 40 {
            memeryDict.removeAllObjects();
        }
        memeryDict[key] = data;
    }
    
    
    
}





