import UIKit

class GridCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let squares = ["Solve", "Times", "Settings", "aa", "bb"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(NavCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    let identifier = "identifier"
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! NavCell
        
        cell.nameLabel.text = squares[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
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
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


