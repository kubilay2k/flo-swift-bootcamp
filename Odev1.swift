//  main.swift
//  Kubilay Kömürcüoğlu Bootcamp İlk Ödev
//
//  Created by Kubilay Kömürcüoğlu on 25.05.2023.

import Foundation

var otFiyatlari: [String: Double] = [
    "Kekik": 1.0,
    "Nane": 1.0,
    "Fesleğen": 1.0,
    "Reyhan": 1.0
]

func fiyatiDusur(otFiyatlari: inout [String: Double], tazelik: String) {
    if tazelik == "hayır" {
        otFiyatlari["Kekik"] = otFiyatlari["Kekik"]! * 0.9
        otFiyatlari["Nane"] = otFiyatlari["Nane"]! * 0.8
        otFiyatlari["Fesleğen"] = otFiyatlari["Fesleğen"]! * 0.9
        otFiyatlari["Reyhan"] = otFiyatlari["Reyhan"]! * 0.9
    }
}

print("Kilo Başı Ot Fiyatları Giriniz")
print("Kekik:")
var kekikFiyati = Double(readLine() ?? "") ?? 0.0

print("Nane:")
var naneFiyati = Double(readLine() ?? "") ?? 0.0

print("Fesleğen:")
var feslegenFiyati = Double(readLine() ?? "") ?? 0.0

print("Reyhan:")
var reyhanFiyati = Double(readLine() ?? "") ?? 0.0

otFiyatlari["Kekik"] = kekikFiyati
otFiyatlari["Nane"] = naneFiyati
otFiyatlari["Fesleğen"] = feslegenFiyati
otFiyatlari["Reyhan"] = reyhanFiyati

print("Satın Alacağınız Otun Adını Giriniz")
var secili_ot = readLine() ?? ""

print("Miktar(Kg) Giriniz")
var kg = Double(readLine() ?? "") ?? 0.0

print("Taze Mi (Evet/Hayır)")
var taze = readLine()?.lowercased() ?? ""

if let otFiyati = otFiyatlari[secili_ot] {
    var islemTutari = otFiyati * kg
    var ilkFiyat = islemTutari
    print("İşlem Tutarı: \(ilkFiyat)")
    
    fiyatiDusur(otFiyatlari: &otFiyatlari, tazelik: taze)
    
    var ikinciFiyat = (otFiyatlari[secili_ot] ?? 0.0) * kg
    
    print("Tazelik Etkisi \(ilkFiyat - ikinciFiyat)")
    
    print("Tutar: \(ikinciFiyat)")
    
    var kdv = ikinciFiyat * 0.18
    print("KDV:(%18) \(kdv)")
    
    print("Fatura:--------------------------------------")
    print("\(secili_ot) : \(kg)kg X \(otFiyatlari["Kekik"] ?? 0.0)Tl = \(ikinciFiyat)")
    
    if taze == "Hayır" {
        print("Taze Değil")
    }else{
        print("Taze")
    }
    
    print("KDV:(%18) \(kdv)TL")
    print("Genel Toplam: \(ikinciFiyat + kdv)TL")
} else {
    print("Geçersiz ot seçimi")
}



