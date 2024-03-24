//
//  PhotoModel.swift
//  CachingAPIResponses
//
//  Created by Etienne Grey on 3/23/24 @ 8:11 PM.
//  Copyright (c) 2024 Etienne Grey. All rights reserved.
//
//  Github: https://github.com/etiennegrey
//  BuyMeACoffee: https://buymeacoffee.com/etiennegrey
//


import Foundation
import SwiftData


@Model
class Photo: Codable {
    
    @Attribute(.unique)
    var id: Int?
    var albumId: Int
    var title: String
    var url: String
    var thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case albumId
        case id
        case title
        case url
        case thumbnailUrl
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.albumId = try container.decode(Int.self, forKey: .albumId)
        self.id = try container.decode(Int?.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
        self.thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        //MARK: Handle encoding
    }
    
}


