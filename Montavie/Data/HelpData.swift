//
//  HelpData.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 12/12/22.
//

import SwiftUI
class HelpData: ObservableObject {
    
    @Published var entries: [Help] = [
        Help(
            title: "Angry",
            text: "Hi love, if you are opening this note, that means you are angry. While I don’t know what exactly you are angry about, I do know that it may be about me and I want to apologize for my future self. I know the distance will be hard and there will be long days where we may snap at each other or I am not doing something that you wish I was or doing something you wish I wasn’t, so being angry is 100% justified and I wish I could fix it in this note. Just remember that I love you so much and that we will get through absolutely anything during this time. It may take longer because the communication is harder online, but I know we will get through anything. I love you and you are so loved by everyone. This note was harder to write because of the unknowns, I just hope it doesn’t make you more mad at me <3",
            unlocked: false,
            imageName: "RelaxingBackground1"
        ),
        Help(
            title: "Bored",
            text: "Hi love, if you are opening this note, that means you are bored. I wanted to write a list of possible fun things you can do ;) they may not be all that fun in hindsight! Some ideas: go on a walk, read a new book, go to Phipps, go look at dogs at the rescue, watch a new show, call me, play rummikub online, set up the projector and watch a movie, hang out with sean and/or seaver, call your parents, do a jump rope workout, go to Michaels and get some crafts for painting or building, get yard to make a giant blanket, go to a coffee shop, write in your journal, meditate, find a new fun game on your phone, call Jaden, see what Allie is up to, bake something, get high, go through the posts on this app, rearrange your room, make tea, make a bracelet, try something new, or just go on social media. I know you will find something to do, if anything, just text me or call me, I will always be able to give you lovin.",
            unlocked: false,
            imageName: "RelaxingBackground3"
        ),
        Help(
            title: "Happy",
            text: "Hi love, if you are opening this note, that means you are happy. That makes ME happy. If you are happy, I don't know what else I could ask for. Keep being you, keep being happy. I don’t know what exactly I wanted to write in this one haha, but it just makes me happy writing this one, knowing that you are happy and opening this sometime in the future :)",
            unlocked: false,
            imageName: "RelaxingBackground4"
        ),
        Help(
            title: "Lonely",
            text: "Hi love, if you are opening this note, that means you are lonely. This one is the hardest to write, because I don’t want to think about it, however, I know there are going to be many lonely nights while I am away. I know it will be hard and that you might be really sad in the moment, but you truly are so loved and have so much support from my family, Sean and Seaver, your family and friends and even your roomates (even though they suck as support or anything close to that, they do *sometimes* try). Despite all of that support, that probably won’t help take the feelings away. I just want you to remember who you are and the person you are. You are amazing and I want to be like you when I grow up, and so does everyone else. When we live together, I can’t wait to go out and make friends or go on double dates with your classmates! That is just a little bit of time away. We can get through this, I love you so much.",
            unlocked: false,
            imageName: "RelaxingBackground5"
        ),
        Help(
            title: "Overwhelmed",
            text: "Hi love, if you are opening this note, that means you are overwhelmed. I know being overwhelmed can happen from different things but just remember all of the things that you can do. It may depend on your environment but it all comes down to grounding yourself into the moment and remembering that you are capable, strong, and will get through this - just like all the times before. If you are in public, remember tapping on your arms or just putting your hands into your palms. You can also play the eye spy game with shapes or colors in your area. Or if you need a moment, go get a drink of water and take some time to yourself. If you are alone you can try box breathing, meditating, or a sound grounding technique. Also remember that I am always here for you and you can text me or call me. You are so so strong and loved. I know you will get through this love <3",
            unlocked: false,
            imageName: "RelaxingBackground6"
        ),
        Help(
            title: "Sad",
            text: "Hi love, if you are opening this note, that means you are sad. I hate to see you sad, ugh :( you will get through this, I know you will. But that does not help the current sadness. Try to remember certain stories of happiness. Remember this winter break when we were laying in bed doing our icks and we kept “phibbing” eachother. Or when we got so high together and we were dying laughing. Or stories of dinner dates we went on, the first time we hung out, what the future holds. Go through all your old tiktoks and look forward to the hundred more we will make! I love you so much and I can’t believe I get to call you my girl. You are my rock, you are everything I want. Thank you for being you, you will get through this <3",
            unlocked: false,
            imageName: "RelaxingBackground7"
        ),
        Help(
            title: "Scared",
            text: "Hi love, if you are opening this note, that means you are scared. That also means you might be overwhelmed, so also maybe go read that one. If you are scared, call me or text me right away. I will be there for you. If I am not available, try to get warmth and weight. Compression helps me when I am stressed/scared. Just remember that you are capable and strong. You are able to take care of yourself and I know that you will be so so okay. Just breathe <3",
            unlocked: false,
            imageName: "RelaxingBackground8"
        ),
        Help(
            title: "Stressed",
            text: "Hi love, if you are opening this note, that means you are stressed. I wish I was able to lay down in bed and hold you in my arms right now. However, I absolutely KNOW that everything will be okay. Everything will work out in the end as long as we are together. Literally everything. There has not been one time that something has not worked out and no matter what it is, if it's where we are going to end up, your future, or just small daily things, it will all be okay. Remember to take a deep breath <3 or try meditation, taking a warm bath, making tea, reading or grounding yourself. I love you so much and know that we can get through anything together!",
            unlocked: false,
            imageName: "RelaxingBackground9"
        ),
    ]
    
    init() {
        setup()
    }
        
    private static func getDataFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("help.data")
    }
    
    func load() {
        do {
            let fileURL = try HelpData.getDataFileURL()
            let data = try Data(contentsOf: fileURL)
            entries = try JSONDecoder().decode([Help].self, from: data)
        } catch {
            print("Failed to load from file. Backup data used")
        }
    }
    
    func save() {
        do {
            let fileURL = try HelpData.getDataFileURL()
            let data = try JSONEncoder().encode(entries)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save")
        }
    }
    
    func setup() {
        do {
            let fileURL = try HelpData.getDataFileURL()
            let data = try Data(contentsOf: fileURL)
            entries = try JSONDecoder().decode([Help].self, from: data)
        } catch {
            save()
        }
    }
}
