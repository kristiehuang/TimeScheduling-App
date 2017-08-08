//import UIKit
//import Contacts
//import Foundation
//
//class ContactsViewController: UITableViewController {
//    
//    var objects = [CNContact]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        let addExisting = UIBarButtonItem(title: "Add Existing", style: .plain, target: self, action: #selector(ContactsViewController.addExistingContact))
//        self.navigationItem.leftBarButtonItem = addExisting
////        
////        if let split = self.splitViewController {
////            let controllers = split.viewControllers
////            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
////        }
////        
//        NotificationCenter.default.addObserver(self, selector: Selector(("insertNewObject:")), name: NSNotification.Name(rawValue: "addNewContact"), object: nil)
//        self.getContacts()
//    }
//    
//    func getContacts() {
//        let store = CNContactStore()
//        
//        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
//            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
//                if authorized {
//                    self.retrieveContactsWithStore(store: store)
//                }
//                } as! (Bool, Error?) -> Void)
//        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
//            self.retrieveContactsWithStore(store: store)
//        }
//    }
//    
//    
//    func retrieveContactsWithStore(store: CNContactStore) {
//        do {
//            let groups = try store.groups(matching: nil)
//            let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groups[0].identifier)
//            //let predicate = CNContact.predicateForContactsMatchingName("John")
//            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey] as [Any]
//            
//            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
//            self.objects = contacts
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.tableView.reloadData()
//            })
//        } catch {
//            print(error)
//        }
//    }
//    
//    func addExistingContact() {
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
//        super.viewWillAppear(animated)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func insertNewObject(sender: NSNotification) {
//        if let contact = sender.userInfo?["contactToAdd"] as? CNContact {
//            objects.insert(contact, at: 0)
//            let indexPath = NSIndexPath(row: 0, section: 0)
//            self.tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
//        }
//    }
//    
//    // MARK: - Segues
//
//    
//    // MARK: - Table View
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return objects.count
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FindFriendsCell") as! FindFriendsCell
//        cell.delegate = self as? FindFriendsCellDelegate
//
//        let contact = self.objects[indexPath.row]
//        let formatter = CNContactFormatter()
//        
//        cell.textLabel?.text = formatter.string(from: contact)
//        cell.detailTextLabel?.text = contact.emailAddresses.first?.value as String?
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return false
//    }
//}
