import UIKit
import CoreData

class GridCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let squares = ["Solve", "Times", "Settings", "aa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        if getSettings()["doesInspect"]! {
            Setting.current.doesUseInspectionTime = true
        } else {
            Setting.current.doesUseInspectionTime = false
        }
        collectionView?.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        collectionView?.register(NavCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return (appDelegate.managedObjectContext)!
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    let identifier = "identifier"
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! NavCell
        
        cell.nameLabel.text = squares[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: UIScreen.main.bounds.height / 2 - 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func getSettings() -> [String : Bool]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        do{
            let results = try getContext().fetch(request)
            var dict : [String : Bool] = [:]
            if(results.count > 0){
                dict["doesInspect"] = (results[0] as AnyObject).value(forKey: "doesInspect") as! Bool
            } else {
                return ["doesInspect" : false]
            }
            return dict
        } catch{
            print("Error Fetching")
        }
        return ["doesInspect" : false]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        switch indexPath.row {
        case 0:
            let vc = TimerViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = PreviousTimesViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = SettingsController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
            //Never happens
        }
    }
    
    
    
}

class NavCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView = UIImageView()
    
    func setupViews() {
        backgroundColor = UIColor.red
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(nameLabel)
        nameLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


