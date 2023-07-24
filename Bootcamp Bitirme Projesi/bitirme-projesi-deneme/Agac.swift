//
//  Agac.swift
//  bitirme-projesi-deneme
//
//  Created by Kubilay Kömürcüoğlu on 22.07.2023.
//

import Foundation

struct AgacContainer: Decodable {
    let Agac: Agac
}

struct Agac: Decodable {
    let id: String
    let baslikTurkce: String
    let baslikLatince: String
    let agacAciklama: String
    let agacResim: String
    let agacSeslendirme: String
}
