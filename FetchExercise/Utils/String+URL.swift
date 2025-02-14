//
//  String+URL.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/12/25.
//

import Foundation

extension String {
    var url: URL? {
        guard !isEmpty else {
            return nil
        }
        return URL(string: self)
    }
}
