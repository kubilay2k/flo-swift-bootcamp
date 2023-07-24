//
//  DetayViewController.swift
//  bitirme-projesi-deneme
//
//  Created by Kubilay Kömürcüoğlu on 22.07.2023.
//

import UIKit
import AVFoundation

class DetayViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var imageDetay: UIImageView!
    @IBOutlet weak var baslikDetay: UILabel!
    @IBOutlet weak var aciklamaDetay: UITextView!
    @IBOutlet weak var lblBaslik: UILabel!
    @IBOutlet weak var btnseslendirme: UIButton!
    @IBOutlet weak var pageTitle: UILabel!
    
    var selectedAgac: Agac?
    
    var agacId: Int? {
        return Int(selectedAgac?.id ?? "1")
    }
    
    var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    //var sesURL: String = ""
  var sesURL: String = "https://www.konusanagac.com/xatfrs/files/sound/agac-9752.mp3"
    
    @IBAction func seslendirme(_ sender: Any) {
        if isPlaying {
            audioPlayer?.stop()
            isPlaying = false
            DispatchQueue.main.async {
                let image = UIImage(named: "play")
                self.btnseslendirme.setImage(image, for: .normal)
            }
        } else {
            guard let sesURL = selectedAgac?.agacSeslendirme, let url = URL.init(string: sesURL) else {
                return
            }
            let downloadTask = URLSession.shared.downloadTask(with: url) { (location, response, error) in
                guard let location = location else {
                    print("Download error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: location)
                    self.audioPlayer?.delegate = self
                    self.audioPlayer?.prepareToPlay()
                    self.audioPlayer?.play()
                    self.isPlaying = true
                    DispatchQueue.main.async {
                        let image = UIImage(named: "pause")
                        self.btnseslendirme.setImage(image, for: .normal)
                    }
                } catch {
                    print("Playback error: \(error.localizedDescription)")
                }
            }
            downloadTask.resume()
        }
    }

    
    override func viewDidLoad() {
        
        let image = UIImage(named: "play")
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContext(size)
        image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        btnseslendirme.setImage(resizedImage, for: .normal)
        
        super.viewDidLoad()
        imageDetay.layer.cornerRadius = 10
        imageDetay.clipsToBounds = true
        //Arkaplan resmi görseli vs. ayarlama alanı
        aciklamaDetay.backgroundColor = UIColor.clear
        let bgImageView = UIImageView(frame: UIScreen.main.bounds)
        bgImageView.image = UIImage(named: "background")
        bgImageView.contentMode = .scaleAspectFill
        self.view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
        
        //Gelen veri ile apıye istek atıp sayfa içerisini doldurma
        let url = URL(string: "https://www.tekinder.org.tr/bootapp/agac/servis.php?tur=agac&no=\(agacId!)")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("Bağlantı Hatası: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    let agacDizisi = try JSONDecoder().decode([Agac].self, from: data)
                    guard let agac = agacDizisi.first else { return }

                    DispatchQueue.main.async {
                        self.baslikDetay.text = agac.baslikTurkce
                        if let aciklamaData = agac.agacAciklama.data(using: .utf8) {
                            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                                .documentType: NSAttributedString.DocumentType.html,
                                .characterEncoding: String.Encoding.utf8.rawValue
                            ]
                            if let attributedString = try? NSAttributedString(data: aciklamaData, options: options, documentAttributes: nil) {
                                self.aciklamaDetay.attributedText = attributedString
                            }
                        }
                        if let imageURL = URL(string: agac.agacResim) {
                            let dataTask = URLSession.shared.dataTask(with: imageURL) { data, _, _ in
                                guard let data = data else {
                                    return
                                }
                                DispatchQueue.main.async {
                                    self.imageDetay.image = UIImage(data: data)
                                }
                            }
                            dataTask.resume()
                        }
                    }

                } catch {
                    print("Dönüştürme hatası: \(error.localizedDescription)")
                }
            }


        }
        dataTask.resume()

    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            isPlaying = false
        }

}
