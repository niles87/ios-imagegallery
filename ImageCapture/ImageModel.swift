//
//  ImageModel.swift
//  ImageCapture
//
//  Created by Niles Bingham on 12/7/20.
//

import Foundation
import SQLite3

struct Image {
    var id: Int
    var image: Data
    var date: Date
}

class ImageManager {
    var database: OpaquePointer!
    
    static let main = ImageManager()
    
    private init(){}
    
    func connect() {
        if database != nil {
            return
        }
        do {
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("image_capture.sqlite3")
            
            if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
                print("could not connect to database")
            }
            
            if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS images (image TEXT, date TEXT)", nil, nil, nil) != SQLITE_OK {
                print("could not create images table")
            }
        } catch let error {
            print("Could not connect to database\n",error)
        }
    }
    
    func create(image: Image) -> Int {
        connect()
        var statement: OpaquePointer!
        let imgStr = image.image.base64EncodedString()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss.sss"
        
        if sqlite3_prepare_v2(database, "INSERT INTO images (image, date) VALUES (?, ?)", -1, &statement, nil) != SQLITE_OK {
            print("could not prepare insert statement")
            return -1
        }
        
        sqlite3_bind_text(statement, 1, NSString(string: imgStr).utf8String, -1, nil)
        
        sqlite3_bind_text(statement, 2, NSString(string: dateFormatter.string(from: image.date)).utf8String, -1, nil)
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("could not insert image")
            return -1
        }
        
        sqlite3_finalize(statement)
        
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    
    func getAllImages() -> [Image] {
        connect()
        
        var result: [Image] = []
        var statement: OpaquePointer!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss.sss"
        
        if sqlite3_prepare_v2(database, "SELECT rowid, image, date FROM images", -1, &statement, nil) != SQLITE_OK {
            print("Error returning data")
            return result
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Image(id: Int(sqlite3_column_int(statement, 0)), image: Data(base64Encoded: String(cString: sqlite3_column_text(statement, 1)), options: .ignoreUnknownCharacters)!, date: dateFormatter.date(from: String(cString: sqlite3_column_text(statement, 2)))!))
        }
        
        sqlite3_finalize(statement)
        
        return result
    }
    
    func update(image: Image) -> Int {
        connect()
        var statement: OpaquePointer!
        let imgStr = image.image.base64EncodedString()
        
        if sqlite3_prepare_v2(database, "UPDATE images SET image = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("could not prepare update statement")
            return -1
        }
        
        sqlite3_bind_text(statement, 1, NSString(string: imgStr).utf8String, -1, nil)
        
        sqlite3_bind_int(statement, 2, Int32(image.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("could not update image")
            return -1
        }
        
        sqlite3_finalize(statement)
        
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func delete(image: Image) -> Bool {
        connect()
        
        var statement: OpaquePointer!
        
        if sqlite3_prepare(database, "DELETE FROM images WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("could not create delete statement")
            return false
        }
        
        sqlite3_bind_int(statement, 1, Int32(image.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error deleting from db")
            return false
        }
        
        sqlite3_finalize(statement)
        
        return true
    }
}
