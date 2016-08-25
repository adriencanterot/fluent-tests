import Fluent
import XCTest

protocol Testable {
    var driver:Driver! { get set }
    var database:Database! { get set }
    
    func testSaveAndFind() throws
}

extension Fluent.Driver where Self:Testable {
    
    static func makeTestConnection() throws {
        fatalError("makeTestConnection() not implemented")
    }
}

extension Testable {
    func testSaveAndFind() throws {
        try driver.raw("DROP TABLE IF EXISTS `posts`")
        try driver.raw("CREATE TABLE IF NOT EXISTS `posts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` CHAR(255), `text` CHAR(255))")

        //        try! database.create("posts") { creator in
        //            creator.id()
        //            creator.string("title")
        //            creator.string("text")
        //        }
        
        var post = Post(id: nil, title: "Vapor & Tests", text: "Lorem ipsum etc...")
        Post.database = database
        
        do {
            try post.save()
            print("Just saved")
        } catch {
            XCTFail("Could not save : \(error)")
        }
        
        do {
            let fetched = try Post.find(1)
            XCTAssertEqual(fetched?.title, post.title)
            XCTAssertEqual(fetched?.text, post.text)
        } catch {
            XCTFail("Could not fetch user : \(error)")
        }
        
        do {
            let post  = try Post.find(2)
            XCTAssertNil(post)
        } catch {
            XCTFail("Could not find post: \(error)")
        }
    }
}
