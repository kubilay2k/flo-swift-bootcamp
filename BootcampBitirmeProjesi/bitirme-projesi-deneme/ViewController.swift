//
//  ViewController.swift
//  bitirme-projesi-deneme
//
//  Created by Kubilay Kömürcüoğlu on 22.07.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    // ...
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detaySegue", sender: data[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detaySegue" {
            if let detailViewController = segue.destination as? DetayViewController,
               let selectedAgac = sender as? Agac {
                detailViewController.selectedAgac = selectedAgac
            }
        }
    }
   
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var data = [Agac]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let bgImageView = UIImageView(frame: UIScreen.main.bounds)
        bgImageView.image = UIImage(named: "background")
        bgImageView.contentMode = .scaleAspectFill // or .scaleToFill
        self.view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
        
        let tasarim: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let genislik = self.collectionView.frame.size.width
        let yukseklik = self.collectionView.frame.size.height
        
        tasarim.minimumInteritemSpacing = 20
        tasarim.minimumLineSpacing = 10
        tasarim.sectionInset = UIEdgeInsets(top:20, left:20, bottom: 20, right: 20)
        tasarim.itemSize = CGSize(width: (genislik-60)/2, height: (yukseklik-50)/4)
        
        collectionView.collectionViewLayout = tasarim
        collectionView.backgroundColor = UIColor.clear
        
        agacListele() { sonuc in
            self.data = sonuc
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }


    }

    func agacListele(completion: @escaping ([Agac]) -> Void) {
        let url = URL(string: "https://www.tekinder.org.tr/bootapp/agac/servis.php?tur=liste")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!){data,response,error in
            
            if let error = error {
                print("Bağlantı Hatası: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    let veriler = try JSONDecoder().decode([AgacContainer].self, from: data)
                    let agaclar = veriler.map { $0.Agac }
                    completion(agaclar)
                } catch {
                    print("Dönüştürme hatası: \(error.localizedDescription)")
                }
            }
            
        }
        dataTask.resume()
    }



}

extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AgacCollectionViewCell
        
        let apiData:Agac
        apiData = data[indexPath.row]
        let string = "\(apiData.agacResim)"
        let url = URL(string: string)
        cell.lblAgac.text = "\(apiData.baslikTurkce)"
        cell.lblSubAgac.text = "\(apiData.baslikLatince)"
        cell.apiImage.downloaded(from: url!,contentMode: .scaleToFill)
        
        return cell
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

