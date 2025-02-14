//
//  Item.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/12/25.
//

import Foundation
import SwiftData

@Model
final class Recipe: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case uuid
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
    
    var cuisine: String
    var name: String
    var photoUrlLarge: String? = nil
    var photoUrlSmall: String? = nil
    var uuid: String
    var sourceUrl: String? = nil
    var youtubeUrl: String? = nil
    
    @Attribute(.externalStorage) var photoUrlSmallDataURL: URL? = nil
    @Attribute(.externalStorage) var photoUrlLargeDataURL: URL? = nil

    init(cuisine: String, name: String, photoUrlLarge: String? = nil, photoUrlSmall: String? = nil, uuid: String, sourceUrl: String? = nil, youtubeUrl: String? = nil) {
        self.cuisine = cuisine
        self.name = name
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.uuid = uuid
        self.sourceUrl = sourceUrl
        self.youtubeUrl = youtubeUrl
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cuisine = try container.decode(String.self, forKey: .cuisine)
        name = try container.decode(String.self, forKey: .name)
        photoUrlLarge = try container.decodeIfPresent(String.self, forKey: .photoUrlLarge)
        photoUrlSmall = try container.decodeIfPresent(String.self, forKey: .photoUrlSmall)
        uuid = try container.decode(String.self, forKey: .uuid)
        sourceUrl = try container.decodeIfPresent(String.self, forKey: .sourceUrl)
        youtubeUrl = try container.decodeIfPresent(String.self, forKey: .youtubeUrl)
    }
}

