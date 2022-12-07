//  INFO49635 - CAPSTONE FALL 2022
//  ChaptersViewModel.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import SwiftUI
import Firebase

final class ChaptersViewModel: ObservableObject {
    
    /// Published variables
    @Published var didStartChapter = false
    @Published var didSelectLeaderboard  = false
    @Published var isShowingChapterDetailView = false
    @Published var isShowingAccountView = false
    @Published var chaptersArr = [Chapter]()
    @Published var isUserLoggedIn = false
    @Published var classroomCode: String = ""
    @Published var jumpToPlayground = false
    @Published var loadingInfo = "Processing..."
    @Published var isShowingLeaderboardView = false
    
    var userNeedsUpdate: Bool = false
    var deletePlayground: Bool = false
    
    var chapterCounter = 0
    var lessonCounter = 0
    var playgroundCounter = 0
    
    var chapterCount = 0
    var lessonCount = 0
    var playgroundCount = 0
    
    
    /// Taken from firebase --> used to update UI components and store user entire chapter progress
    @Published var chaptersStatus = [String]()
    
    @Published var userCompletionCount = [Int]()
    
    @Published var totalUserCount = 0
    
    var loggedInAccountType : String = "Student"
    var logoutIntent = false
    var loggedInUser = User(firstName: "",
                            lastName: "",
                            username: "",
                            email: "",
                            password: "",
                            dob : "",
                            country: "",
                            classroom: [])
    
    var willStartNextChapter = false
    
    var startChapterIntent = false
    
    
    var classroomIndex = 0
    var selectedChapterIndex = 0
    var selectedChapter: Chapter? {
        didSet {
            isShowingChapterDetailView = true
        }
    }
    
    /// 2 x 2 chapter columns
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    /// Called when the users starts the chapter
    func startChapter(){
        self.didStartChapter = true
    }
    
    /// Called when the user taps view leaderboard
    func viewLeaderboard(){
        self.didSelectLeaderboard = true
    }
    
    /// Called from views to pop to chapters view model
    func quitChapter(){
        self.didStartChapter = false
    }
    
    func downloadTotalCount(completion: @escaping(Int) -> Void) {
        
        self.chapterCount = 0
        self.chapterCounter = 0
        
        let db = Firestore.firestore()
        
        db.collection("Chapters").getDocuments() { (querySnapshot, err) in
            if err != nil {
                completion(0)
            } else {
                
                self.chapterCount += querySnapshot!.documents.count
        
                for chapterDocument in querySnapshot!.documents {
                    
                    let currentChapter = db.collection("Chapters").document(chapterDocument.documentID)
                    
                    currentChapter.collection("lessons").getDocuments() { (querySnapshot, err) in
                        if err != nil {
                            completion(0)
                        } else {
                            self.chapterCount += querySnapshot!.documents.count
                        }
                    }
                        
                    currentChapter.collection("playground").getDocuments() { (querySnapshot, err) in
                        if err != nil {
                            completion(0)
                        } else {
                            self.chapterCount += querySnapshot!.documents.count
                        }
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                completion(self.chapterCount)
            })
        }
    }
    
    func downloadChapters(completion: @escaping(DownloadStatus) -> Void) {
        
        downloadTotalCount { count in
            if (count == 0){
                completion(.failure)
            } else {
                
                let db = Firestore.firestore()
       
                db.collection("Chapters").getDocuments() { (querySnapshot, err) in
                    if err != nil {
                        completion(.failure)
                    } else {
                        
                        self.chapterCounter += querySnapshot!.documents.count
                        
                        for chapterDocument in querySnapshot!.documents {
                            
                            
                            guard let chapterNum = chapterDocument.data()["chapter_number"]! as? Int,
                                  let chapterName = chapterDocument.data()["chapter_title"]! as? String,
                                  let chapterDifficulty = chapterDocument.data()["chapter_difficulty"]! as? Int,
                                  let chapterSummary = chapterDocument.data()["chapter_desc"]! as? String,
                                  let chapterLength = chapterDocument.data()["chapter_length"]! as? Int,
                                  let iconName = chapterDocument.data()["chapter_icon_name"]! as? String else {
                                      completion(.failure)
                                      return
                                  }
                            
                            var chapter = Chapter(chapterNum: chapterNum,
                                                  name: chapterName,
                                                  difficulty: chapterDifficulty,
                                                  summary: chapterSummary,
                                                  lessons: [ChapterLesson](),
                                                  length: chapterLength,
                                                  iconName: iconName,
                                                  playgroundArr: [Playground](),
                                                  firestoreID: chapterDocument.documentID)
                            
                            self.downloadLessons(chapterID: chapterDocument.documentID) { status, lessons in
                                switch status {
                                case .success:
                                    chapter.lessons = lessons
                                    
                                    self.chapterCounter += lessons.count
                                    
                                    self.downloadPlaygrounds(chapterID: chapterDocument.documentID) { statusTwo, playgrounds in
                                        switch statusTwo {
                                        case .success:
                                            chapter.playgroundArr = playgrounds
                                            self.chaptersArr.append(chapter)
                                            self.chapterCounter += playgrounds.count
                                            
                                            if self.chapterCounter == self.chapterCount {
                                                completion(.success)
                                            }
                                            
                                        case .failure:
                                            completion(.failure)
                                        }
                                    }
                                    
                                case .failure:
                                    completion(.failure)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func downloadLessons(chapterID: String, completion: @escaping(DownloadStatus, [ChapterLesson]) -> Void) {
        
        let db = Firestore.firestore()
        let currentChapter = db.collection("Chapters").document(chapterID)
        
        var lessonCounter = 0
        var lessons = [ChapterLesson]()
        
        currentChapter.collection("lessons").getDocuments() { (querySnapshot, err) in
            if err != nil {
                completion(.failure, [])
            } else {
                
                let lessonCount = querySnapshot?.documents.count
                
                for chapterLessonDocument in querySnapshot!.documents {
                    let lesson_data = chapterLessonDocument.data()["lesson_content"]! as! [String]
                    let newLesson = ChapterLesson(content: lesson_data)
                    lessons.append(newLesson)
                    
                    lessonCounter += 1
                    
                    if lessonCounter == lessonCount {
                        completion(.success, lessons)
                    }
                }
            }
        }
    }
    
    func downloadPlaygrounds(chapterID: String, completion: @escaping(DownloadStatus, [Playground]) -> Void) {
        let db = Firestore.firestore()
        let currentChapter = db.collection("Chapters").document(chapterID)
        
        var playgroundCounter = 0
        var playgrounds = [Playground]()
        
        
        currentChapter.collection("playground").getDocuments() { (querySnapshot, err) in
            
            if err != nil {
                completion(.failure, [])
            } else {
                
                let playgroundCount = querySnapshot?.documents.count
                
                for chapterPlaygroundDocument in querySnapshot!.documents {
                    
                    guard let title = chapterPlaygroundDocument.data()["question_title"]! as? String,
                          let description = chapterPlaygroundDocument.data()["question_description"]! as? String,
                          let type = chapterPlaygroundDocument.data()["question_type"]! as? String,
                          let blocks = chapterPlaygroundDocument.data()["code_blocks"]! as? [String],
                          let id = chapterPlaygroundDocument.data()["id"]! as? String else {
                              completion(.failure, [])
                              return
                      }
                    
                    var newBlocks = blocks
                    
                    for i in 0..<newBlocks.count {
                        newBlocks[i] = newBlocks[i].replacingOccurrences(of: "$n", with: "\n")
                    }
                    
                    if (type == "mcq") {
                        
                        let mcqOptions = chapterPlaygroundDocument.data()["code_blocks"]! as! [String]
                        let mcqAnswers = chapterPlaygroundDocument.data()["mcq_answers"]! as! [String]
                        
                        var playgroundQuestion = Playground(fId: id,
                                                            title: title,
                                                            description: description,
                                                            type: type,
                                                            originalArr: blocks)
                        
                        playgroundQuestion.mcqOptions = mcqOptions
                        playgroundQuestion.mcqAnswers = mcqAnswers
                        
                        playgrounds.append(playgroundQuestion)
                        
                    } else {
                        
                        let playgroundQuestion = Playground(fId: id,
                                                            title: title,
                                                            description: description,
                                                            type: type,
                                                            originalArr: blocks)
                        
                        playgrounds.append(playgroundQuestion)
                    }
                    
                    playgroundCounter += 1
                    
                    if playgroundCounter == playgroundCount {
                        completion(.success, playgrounds)
                    }
                }
            }
        }
    }
    
    func organizeChaptersByNumber(completion: @escaping() -> Void){
        for i in 0..<self.chaptersArr.count {
            for j in 1..<self.chaptersArr.count {
                if self.chaptersArr[j].chapterNum < self.chaptersArr[j-1].chapterNum {
                    let tmp = self.chaptersArr[j-1]
                    self.chaptersArr[j-1] = self.chaptersArr[j]
                    self.chaptersArr[j] = tmp
                }
            }
            
            if i+1 == self.chaptersArr.count {
                completion()
            }
        }
    }
    
    
    func organizeUserProgressViaChapterNumber(completion: @escaping() -> Void){
        for i in 0..<self.loggedInUser.classroom[0].chapterProgress.count {
            for j in 1..<self.loggedInUser.classroom[0].chapterProgress.count {
                if self.loggedInUser.classroom[0].chapterProgress[j].chapterNum < self.loggedInUser.classroom[0].chapterProgress[j-1].chapterNum {
                    let tmp = self.loggedInUser.classroom[0].chapterProgress[j-1].chapterNum
                    self.loggedInUser.classroom[0].chapterProgress[j-1].chapterNum = self.loggedInUser.classroom[0].chapterProgress[j].chapterNum
                    self.loggedInUser.classroom[0].chapterProgress[j].chapterNum = tmp
                }
                
                if i+1 == self.loggedInUser.classroom[0].chapterProgress.count {
                    completion()
                }
            }
        }
    }
    
    func deleteOldChapterFromCloud(completion: @escaping(UploadStatus) -> Void) {
        
        let db = Firestore.firestore()
        let classroom = db.collection(loggedInAccountType).document(loggedInUser.username).collection("Classrooms").document("classroom_1")
        
        classroom.collection("Chapters").getDocuments { snapshot, err in
            if err != nil {
                completion(.failure)
            } else {
                
                var counter = 0
                let count = snapshot!.documents.count
                
                for doc in snapshot!.documents {
                    classroom.collection("Chapters").document(doc.documentID).delete() { err in
                        if err != nil {
                            print("Error removing document")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    
                    counter += 1
                    
                    if counter == count {
                        completion(.success)
                    }
                    
                }
            }
            
            
        }
    }
    
    
    func addNewChapterToCloud(completion: @escaping(UploadStatus) -> Void) {
        
        let db = Firestore.firestore()
        let classroom = db.collection(loggedInAccountType).document(loggedInUser.username).collection("Classrooms").document("classroom_1")
          
        for j in 0..<loggedInUser.classroom[0].chapterProgress.count {
        
            let userChapter = classroom.collection("Chapters").document(loggedInUser.classroom[0].chapterProgress[j].chapterID)
            
            var playgroundIds = [String]()
            
            let chapterQuestionsProgress = loggedInUser.classroom[0].chapterProgress[j].questionAnswers
            
            for i in 0..<chapterQuestionsProgress.count{
                
                let data = chapterQuestionsProgress[i].answers
                
                playgroundIds.append(chapterQuestionsProgress[i].fId)
                
                userChapter.setData(["question_\(i+1)_answer": data]){ err in
                    if err != nil {
                        completion(.failure)
                    }
                }
            }
            
            userChapter.setData([
                "chapter_status": loggedInUser.classroom[0].chapterProgress[j].chapterStatus,
                "chapters_name": loggedInUser.classroom[0].chapterProgress[j].chapterName,
                "chapters_num": loggedInUser.classroom[0].chapterProgress[j].chapterNum,
                "playground_status": loggedInUser.classroom[0].chapterProgress[j].playgroundStatus,
                "theory_status": loggedInUser.classroom[0].chapterProgress[j].theoryStatus,
                "question_scores": loggedInUser.classroom[0].chapterProgress[j].questionScores,
                "question_progress": loggedInUser.classroom[0].chapterProgress[j].questionProgress,
                "question_ids": playgroundIds,
                "total_question_score": loggedInUser.classroom[0].chapterProgress[j].chapterScore,
                "total_questions": loggedInUser.classroom[0].chapterProgress[j].totalQuestions,
                "chapter_id": loggedInUser.classroom[0].chapterProgress[j].chapterID]){ err in
                if err != nil {
                    completion(.failure)
                }
            }
            
            for i in 0..<chapterQuestionsProgress.count{
                let data = chapterQuestionsProgress[i].answers
                userChapter.updateData(["question_\(i+1)_answer": data]){ err in
                    if err != nil {
                        completion(.failure)
                    }
                }
            }
            
            if j+1 == loggedInUser.classroom[0].chapterProgress.count {
                completion(.success)
            }
        }
    }
    func saveUserProgressToCloud(completion: @escaping(UploadStatus) -> Void){
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: loggedInUser.email, password: loggedInUser.password)
        
        user?.reauthenticate(with: credential, completion: {(authResult, error) in
            if error != nil {
                completion(.failure)
            }
        })
        
        // Updating user progress
        for j in 0..<loggedInUser.classroom[0].chapterProgress.count {
            
            let classroom = db.collection(loggedInAccountType).document(loggedInUser.username).collection("Classrooms").document("classroom_1")
            let userChapter = classroom.collection("Chapters").document(loggedInUser.classroom[0].chapterProgress[j].chapterID)
            
            var playgroundIds = [String]()
            
            let chapterQuestionsProgress = loggedInUser.classroom[0].chapterProgress[j].questionAnswers
            
            for i in 0..<chapterQuestionsProgress.count{
                
                let data = chapterQuestionsProgress[i].answers
                
                playgroundIds.append(chapterQuestionsProgress[i].fId)
                
                userChapter.updateData(["question_\(i+1)_answer": data]){ err in
                    if err != nil {
                        completion(.failure)
                    }
                }
            }
            
            userChapter.updateData([
                "chapter_status": loggedInUser.classroom[0].chapterProgress[j].chapterStatus,
                "playground_status": loggedInUser.classroom[0].chapterProgress[j].playgroundStatus,
                "theory_status": loggedInUser.classroom[0].chapterProgress[j].theoryStatus,
                "question_scores": loggedInUser.classroom[0].chapterProgress[j].questionScores,
                "question_progress": loggedInUser.classroom[0].chapterProgress[j].questionProgress,
                "question_ids": playgroundIds,
                "total_question_score": loggedInUser.classroom[0].chapterProgress[j].chapterScore,
                "total_questions": loggedInUser.classroom[0].chapterProgress[j].totalQuestions,
                "chapter_id": loggedInUser.classroom[0].chapterProgress[j].chapterID]){ err in
                if err != nil {
                    completion(.failure)
                }
            }
            
            if j+1 == loggedInUser.classroom[0].chapterProgress.count {
                completion(.success)
            }
        }
    }
   
    
    // Getting stats for completion
    func retrieveUserbaseCompletion(completion: @escaping(DownloadStatus) -> Void){
        
        // Resetting completion count and total user arrays
        self.userCompletionCount = Array(repeating: 0, count: self.chaptersArr.count)
        self.totalUserCount = 0
        
        let db = Firestore.firestore()
        
        db.collection("Students").getDocuments() { (querySnapshotOne, err) in
            if err != nil {
                completion(.failure)
            } else {
                
                let totalDocumentCount = querySnapshotOne!.documents.count
                
                // Looping through each student
                for document in querySnapshotOne!.documents {
                    
//                    self.totalUserCount += 1
                    
                    // Accessing chapters collection for the student
                    db.collection("Students").document(document.documentID).collection("Classrooms").document("classroom_1").collection("Chapters").getDocuments() { (querySnapshot, err) in
                        if err != nil {
                            completion(.failure)
                        } else {
                            
                            // Going through each chapter and finding the status
                            var counter = 0
                            var i = 0
                            for chapterDoc in querySnapshot!.documents {
                                
                                guard let chapterStatus = chapterDoc["chapter_status"] as? String else {
                                    completion(.failure)
                                    return
                                }
                                
                                if (chapterStatus == "complete"){
                                    // Only getting status for chapters currently being used by the app
                                    if (counter < self.chaptersArr.count){
                                        self.userCompletionCount[counter] += 1
                                    }
                                }
                                counter += 1
                                i += 1
                                
                                if i == querySnapshot?.documents.count {
                                    self.totalUserCount += 1
                                    
                                    if self.totalUserCount == totalDocumentCount {
                                        completion(.success)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Function which resets all variable data
    func clearAllData(){
        didStartChapter = false
        didSelectLeaderboard  = false
        isShowingChapterDetailView = false
        isShowingAccountView = false
        chaptersArr = [Chapter]()
        isUserLoggedIn = false
        classroomCode = ""
        jumpToPlayground = false
        chaptersStatus = [String]()
        loggedInAccountType = ""
        loggedInUser = User(firstName: "",
                            lastName: "",
                            username: "",
                            email: "",
                            password: "",
                            dob : "",
                            country: "",
                            classroom: [])
        
        willStartNextChapter = false
        startChapterIntent = false
        classroomIndex = 0
        selectedChapterIndex = 0
        
    }

    
    func startUserDownload(email: String, completion: @escaping(DownloadStatus) -> Void){
        
        // 1
        downloadRemoteUserData(email: email) { statusOne in
            switch statusOne {
            case .success:
                // 2
                self.downloadUserProgress(username: self.loggedInUser.username) { statusTwo in
                    switch statusTwo {
                    case .success:
                        // 3
                        self.checkForMissingChapter { statusThree in
                            // 4
                            self.checkForRemovedChapter { statusFour in
                                if statusFour {
                                    self.organizeUserProgressViaChapterNumber {
                                        self.deleteOldChapterFromCloud { statusFive in
                                            switch statusFive {
                                            case .success:
                                                self.addNewChapterToCloud { statusSix in
                                                    switch statusSix {
                                                    case .success:
                                                        print("Success")
                                                    case .failure:
                                                        completion(.failure)
                                                    }
                                                }
                                            case .failure:
                                                completion(.failure)
                                            }
                                        }
                                    }
                                }
                                
                                if statusThree {
                                    self.organizeUserProgressViaChapterNumber {
                                        self.addNewChapterToCloud { statusSeven in
                                            switch statusSeven {
                                            case .success:
                                                print("Success")
                                            case .failure:
                                                completion(.failure)
                                            }
                                        }
                                    }
                                }
                                
                                self.checkForMissingPlayground { statusEight in
                                    self.checkForExtraPlayground { statusNine in
                                        if statusEight || statusNine {
                                            self.addNewChapterToCloud { statusTen in
                                                switch statusTen {
                                                case .success:
                                                    completion(.success)
                                                case .failure:
                                                    completion(.failure)
                                                }
                                            }
                                        }else {
                                            completion(.success)
                                        }
                                    }
                                }
                            }
                        }
                    case .failure:
                        completion(.failure)
                    }
                }
            case .failure:
                completion(.failure)
            }
        }
    }
    
    func downloadRemoteUserData(email: String, completion: @escaping(DownloadStatus) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("Students")
        
        collectionRef.whereField("email", isEqualTo: email).getDocuments { (snapshot, err) in
            if err != nil {
                completion(.failure)
            } else {
                let user = snapshot!.documents[0].data()
                
                self.loggedInAccountType = "Students"
                
                guard let firstName = user["firstname"] as? String,
                      let lastName = user["lastName"] as? String,
                      let email = user["email"] as? String,
                      let username = user["username"] as? String,
                      let country = user["country"] as? String,
                      let dateOfBirth = user["date_of_birth"] as? String else {
                          completion(.failure)
                          return
                      }
                
                self.loggedInUser.firstName = firstName
                self.loggedInUser.lastName = lastName
                self.loggedInUser.email = email
                self.loggedInUser.username = username
                self.loggedInUser.country = country
                self.loggedInUser.dob = dateOfBirth
                
                completion(.success)
            }
        }
    }
    
    func downloadUserProgress(username: String, completion: @escaping(DownloadStatus) -> Void) {
        
        let db = Firestore.firestore()
        let enrolledClasrooms = db.collection("Students").document(username).collection("Classrooms")
        
        enrolledClasrooms.getDocuments { (snapshot, err) in
            if err != nil {
                completion(.failure)
            } else {
                
                var userClassroom = UserClassroom()
                let classroomChapters = enrolledClasrooms.document("classroom_1").collection("Chapters")
                
                classroomChapters.getDocuments { (snapshot, err) in
                    if err != nil {
                        completion(.failure)
                    } else {
                        
                        var chaptersProgress = [UserChapterProgress]()
                        
                        for j in 0..<snapshot!.documents.count {
                            
                            guard let data = snapshot?.documents[j].data() else {
                                completion(.failure)
                                return
                            }
                            
                            guard let chapterStatus = data["chapter_status"] as? String,
                                  let chapterName = data["chapters_name"] as? String,
                                  let chapterNum = data["chapters_num"] as? Int,
                                  let playgroundStatus = data["playground_status"] as? String,
                                  let questionScores = data["question_scores"] as? [Int],
                                  let theoryStatus = data["theory_status"] as? String,
                                  let questionProgress = data["question_progress"] as? [String],
                                  let chapterScore = data["total_question_score"] as? Int,
                                  let totalQuestions = data["total_questions"] as? Int,
                                  let questionIds = data["question_ids"] as?  [String],
                                  let chapterID = data["chapter_id"] as? String else {
                                      completion(.failure)
                                      return
                                  }
                                  
                            var userQuestionAnswers = [UserQuestionAnswer]()
                               
                            for i in 0..<questionIds.count {
                                
                                guard let answer = data["question_\(i+1)_answer"] as? [String] else {
                                    completion(.failure)
                                    return
                                }
                                
                                let newAnswer = UserQuestionAnswer(fId: questionIds[i],answers: answer)
                                userQuestionAnswers.append(newAnswer)
                         
                            }
                            
                            self.chaptersStatus.append(chapterStatus)
                            
                            let chapter = UserChapterProgress(chapterStatus: chapterStatus, chapterName: chapterName, chapterNum: chapterNum, playgroundStatus: playgroundStatus, questionScores: questionScores, questionAnswers: userQuestionAnswers, questionProgress: questionProgress, theoryStatus: theoryStatus, chapterScore: chapterScore, totalQuestions: totalQuestions, chapterID: chapterID, questionIDS: questionIds)
                            
                            chaptersProgress.append(chapter)
                            
                            if j+1 == snapshot!.documents.count {
                                userClassroom.chapterProgress = chaptersProgress
                                self.loggedInUser.classroom.append(userClassroom)
                                completion(.success)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkForMissingChapter(completion: @escaping(Bool) -> Void){
        self.loadingInfo = "Checking for new content..."
        
        // User is missing chapters
        if (self.loggedInUser.classroom[0].chapterProgress.count < self.chaptersArr.count) {
            
            let userChapterCount = self.loggedInUser.classroom[0].chapterProgress.count
            let swiftlyChapterCount = self.chaptersArr.count
            
            let numberOfMissingChapters = swiftlyChapterCount - userChapterCount
            
            for i in 0..<numberOfMissingChapters {
                
                let missingChapter = self.chaptersArr[userChapterCount+i]
                let chapterName = missingChapter.name
                let chapterNumber = missingChapter.chapterNum
                let questionsCount = self.chaptersArr[userChapterCount+i].playgroundArr.count
                let chapterID = self.chaptersArr[userChapterCount+i].firestoreID
                var userQuestionAnswers = [UserQuestionAnswer]()
                
                var questionIDS = [String]()
                
                for j in 0..<questionsCount {
                    let qId = self.chaptersArr[userChapterCount+i].playgroundArr[j].fId
                    userQuestionAnswers.append(UserQuestionAnswer(fId: qId, answers:[]))
                    questionIDS.append(qId)
                }
                
                
                let questionsProgess = Array(repeating: "incomplete", count: questionsCount)
                let questionsScore = Array(repeating: 0, count: questionsCount)
                
                let newUserProgress = UserChapterProgress(chapterStatus: "incomplete",
                                                          chapterName: chapterName,
                                                          chapterNum: chapterNumber,
                                                          playgroundStatus: "incomplete",
                                                          questionScores: questionsScore,
                                                          questionAnswers: userQuestionAnswers,
                                                          questionProgress: questionsProgess,
                                                          theoryStatus: "incomplete",
                                                          chapterScore: 0,
                                                          totalQuestions: 0,
                                                          chapterID: chapterID,
                                                          questionIDS: questionIDS)
                
                self.loggedInUser.classroom[0].chapterProgress.append(newUserProgress)
                self.chaptersStatus.append(newUserProgress.chapterStatus)
                
                if i+1 == numberOfMissingChapters {
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
    }
    
    func checkForRemovedChapter(completion: @escaping(Bool) -> Void) {
        
        var needsUpdate = false
        
        for i in 0..<loggedInUser.classroom[0].chapterProgress.count {
            
            let id = loggedInUser.classroom[0].chapterProgress[i].chapterID
            
            // User has extra chapter
            if !chaptersArr.contains(where: { $0.firestoreID == id }) {
                loggedInUser.classroom[0].chapterProgress.remove(at: i)
                needsUpdate = true
            }
            
//            if i+1 == loggedInUser.classroom[0].chapterProgress.count {
//
//            }
        }
        completion(needsUpdate)
    }
    
    
    func checkForMissingPlayground(completion: @escaping(Bool) -> Void){
        
        var wasMissingPlayground = false
        
        for i in 0..<self.chaptersArr.count {

            let chaptPlaygrounds = self.chaptersArr[i].playgroundArr
            let userPlayground = self.loggedInUser.classroom[0].chapterProgress[i]
            
            // Check: does user have this playground
            for j in 0..<chaptPlaygrounds.count {

                // User playgrounds contains fID
                if (userPlayground.questionAnswers.contains(where: {$0.fId == chaptPlaygrounds[j].fId})) {
                    print("Has: \(chaptPlaygrounds[j].fId)")
                }

                // User playgrounds does not contain fID
                else {
                    
                    wasMissingPlayground = true

                    print("Missing: \(chaptPlaygrounds[j].fId)")

                    let id = chaptPlaygrounds[j].fId

                    // Question progress
                    self.loggedInUser.classroom[0].chapterProgress[i].questionProgress.append("incomplete")

                    // Question scores
                    self.loggedInUser.classroom[0].chapterProgress[i].questionScores.append(0)
                    self.loggedInUser.classroom[0].chapterProgress[i].questionAnswers.append(UserQuestionAnswer(fId: id,answers: []))
                    self.loggedInUser.classroom[0].chapterProgress[i].totalQuestions += 1
                    self.loggedInUser.classroom[0].chapterProgress[i].questionIDS.append(self.chaptersArr[i].playgroundArr[j].fId)
                    
                    if (self.loggedInUser.classroom[0].chapterProgress[i].playgroundStatus == "complete"){
                        self.loggedInUser.classroom[0].chapterProgress[i].playgroundStatus = "inprogress"
                    }

                    if (self.loggedInUser.classroom[0].chapterProgress[i].chapterStatus == "complete"){
                        self.loggedInUser.classroom[0].chapterProgress[i].chapterStatus = "inprogress"
                    }

                    self.chaptersStatus[i] = self.loggedInUser.classroom[0].chapterProgress[i].chapterStatus
                }
                
                if j+1 == chaptPlaygrounds.count{
                    completion(wasMissingPlayground)
                }
            }
        }
    }
    
    func checkForExtraPlayground(completion: @escaping(Bool) -> Void){
        
        var wasExtraPlayground = false
        
        for i in 0..<self.chaptersArr.count {
        
            let chaptPlaygrounds = self.chaptersArr[i].playgroundArr
            let userPlayground = self.loggedInUser.classroom[0].chapterProgress[i]
            let userPlaygroundCount = self.loggedInUser.classroom[0].chapterProgress[i].questionProgress.count
        
            for k in 0..<userPlaygroundCount {

                let playgrounds = userPlayground.questionAnswers[k]

                if (chaptPlaygrounds.contains(where: {$0.fId == playgrounds.fId})){

                    print("Chapter has: \(playgrounds.fId)")

                }else{
                    print("Chapter missing: \(playgrounds.fId)")
                    
                    wasExtraPlayground = true

                    self.loggedInUser.classroom[0].chapterProgress[i].questionAnswers.remove(at: k)
                    self.loggedInUser.classroom[0].chapterProgress[i].questionScores.remove(at: k)
                    self.loggedInUser.classroom[0].chapterProgress[i].questionProgress.remove(at: k)
                    self.loggedInUser.classroom[0].chapterProgress[i].questionIDS.remove(at: k)

                    if (self.loggedInUser.classroom[0].chapterProgress[i].questionProgress.contains(where: {$0 != "incomplete" && $0 != "inprogress"})){
                        self.loggedInUser.classroom[0].chapterProgress[i].chapterStatus = "complete"
                        self.loggedInUser.classroom[0].chapterProgress[i].playgroundStatus = "complete"
                    }
                }
                
                if k+1 == userPlaygroundCount {
                    completion(wasExtraPlayground)
                }
            }
        }
    }
}
