import Foundation

class Animal {
    var legs: Int
    init(legs: Int) {
        self.legs = legs
    }
}

class Dog: Animal {
    func speak() {
        print("Woof!")
    }
}

class Corgi: Dog {
    override func speak() {
        print("Yip!")
    }
}

class Poodle: Dog {
    override func speak() {
        print("Bark!")
    }
}

class Cat: Animal {
    var isTame: Bool
    
    init(isTame: Bool) {
        self.isTame = isTame
        super.init(legs: 4)
    }
    func speak() {
        print("Meow!")
    }
}

class Persian: Cat {
   
    override func speak() {
        print("Prrr!")
    }
}

class Lion: Cat {

    override func speak() {
        print("Roar!")
    }
}

