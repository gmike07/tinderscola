import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/config/constants.dart';

class User extends Equatable {
  final String id;
  final String name;
  final int age;
  final List<String> interests;
  final List<String?> imageUrls;
  final String bio;
  final List<String> genderPreference;
  final String profilePicture;
  final String coverPicture;
  final String gender;
  final String programName;
  final String programPlace;
  final bool searchesForFriends;
  final List<String> swipeLeft;
  final List<String> swipeRight;
  final List<String> matches;
  final String? currentInterest;
  final List<String>? optionalInterests;

  const User(
      {required this.id,
      required this.name,
      required this.age,
      required this.interests,
      required this.imageUrls,
      required this.genderPreference,
      required this.bio,
      required this.gender,
      required this.profilePicture,
      required this.coverPicture,
      required this.programName,
      required this.programPlace,
      required this.searchesForFriends,
      required this.matches,
      required this.swipeLeft,
      required this.swipeRight,
      this.currentInterest,
      this.optionalInterests});

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        interests,
        bio,
        imageUrls,
        profilePicture,
        coverPicture,
        gender,
        programName,
        programPlace,
        searchesForFriends,
        swipeLeft,
        swipeRight,
        matches,
        genderPreference,
        currentInterest,
        optionalInterests
      ];

  static List<String> convertList(List<dynamic> lst) {
    return lst.map((item) => (item as String)).toList();
  }

  static List<String?> convertListMaybe(List<dynamic> lst) {
    return lst.map((item) => (item as String?)).toList();
  }

  static User fromSnapshot(DocumentSnapshot snapshot) {
    User user = User(
        name: snapshot.get('name'),
        age: snapshot.get('age'),
        programName: snapshot.get('programName'),
        programPlace: snapshot.get('programPlace'),
        searchesForFriends: snapshot.get('searchesForFriends'),
        interests: convertList(snapshot.get('interests')),
        imageUrls: convertListMaybe(snapshot.get('imageUrls')),
        genderPreference: convertList(snapshot.get('genderPreference')),
        bio: snapshot.get('bio'),
        profilePicture: snapshot.get('profilePicture'),
        id: snapshot.id,
        gender: snapshot.get('gender'),
        coverPicture: snapshot.get('coverPicture'),
        matches: convertList(snapshot.get('matches')),
        swipeLeft: convertList(snapshot.get('swipeLeft')),
        optionalInterests: snapshot.get('optionalInterests') == null
            ? []
            : convertList(snapshot.get('optionalInterests')),
        swipeRight: convertList(snapshot.get('swipeRight')));
    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'interests': interests,
      'bio': bio,
      'profilePicture': profilePicture,
      'coverPicture': coverPicture,
      'gender': gender,
      'programName': programName,
      'programPlace': programPlace,
      'searchesForFriends': searchesForFriends,
      'imageUrls': imageUrls,
      'matches': matches,
      'swipeLeft': swipeLeft,
      'swipeRight': swipeRight,
      'genderPreference': genderPreference,
      'optionalInterests': optionalInterests
    };
  }

  User copyWith(
      {String? id,
      String? name,
      int? age,
      List<String>? interests,
      List<String?>? imageUrls,
      String? bio,
      String? profilePicture,
      String? coverPicture,
      String? gender,
      String? programName,
      String? programPlace,
      bool? searchesForFriends,
      List<String>? genderPreference,
      List<String>? matches,
      List<String>? swipeLeft,
      List<String>? swipeRight,
      String? currentInterest,
      List<String>? optionalInterests}) {
    User user = User(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        interests: interests ?? this.interests,
        imageUrls: imageUrls ?? this.imageUrls,
        bio: bio ?? this.bio,
        profilePicture: profilePicture ?? this.profilePicture,
        coverPicture: coverPicture ?? this.coverPicture,
        gender: gender ?? this.gender,
        programName: programName ?? this.programName,
        programPlace: programPlace ?? this.programPlace,
        searchesForFriends: searchesForFriends ?? this.searchesForFriends,
        genderPreference: genderPreference ?? this.genderPreference,
        swipeLeft: swipeLeft ?? this.swipeLeft,
        swipeRight: swipeRight ?? this.swipeRight,
        matches: matches ?? this.matches,
        currentInterest: currentInterest ?? this.currentInterest,
        optionalInterests: optionalInterests ?? this.optionalInterests);
    return user;
  }

  String getProfilePicture() {
    if (profilePicture != '') {
      return profilePicture;
    }
    List<String> images = [];
    for (String? s in imageUrls) {
      if (s != null) {
        images.add(s);
      }
    }
    return images[0];
  }

  String getCoverPicture() {
    if (coverPicture != '') {
      return coverPicture;
    }
    List<String> images = [];
    for (String? s in imageUrls) {
      if (s != null) {
        images.add(s);
      }
    }
    return images[0];
  }

  static User empty = const User(
      id: '',
      name: '',
      age: 0,
      interests: [],
      bio: '',
      imageUrls: [null, null, null, null, null, null],
      profilePicture: '',
      coverPicture: '',
      gender: '',
      programName: '',
      programPlace: '',
      searchesForFriends: false,
      swipeLeft: [],
      swipeRight: [],
      matches: [],
      genderPreference: [],
      optionalInterests: AppConstants.interests,
      currentInterest: '');

  // static List<User> users = [
  //   User(
  //       id: "1",
  //       name: "Sofia Doe",
  //       age: 24,
  //       // email: "johnDoe@gmail.com",
  //       interests: [
  //         "sports",
  //         "music",
  //         "movies",
  //         'sleeping',
  //         'video games',
  //         'yo'
  //       ],
  //       bio:
  //           "Cloud computing is a general term for anything that involves delivering hosted services over the Internet. These services are broadly divided into three categories: Infrastructure-as-a-Service (IaaS), Platform-as-a-Service (PaaS) and Software-as-a-Service (SaaS). The name cloud computing was inspired by the cloud symbol that's often used to represent the Internet in flowcharts and diagrams.",
  //       profilePicture: "",
  //       imageUrls: [
  //         "https://images.unsplash.com/photo-1503104834685-7205e8607eb9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
  //         "https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
  //         "https://images.unsplash.com/photo-1611880147493-7542bdb0f024?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YW1lcmljYW4lMjBnaXJsfGVufDB8fDB8fA%3D%3D&w=1000&q=800",
  //         "https://images.unsplash.com/photo-1496440737103-cd596325d314?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Z2lybHxlbnwwfHwwfHw%3D&w=1000&q=80",
  //       ],
  //       coverPicture: "",
  //       programPlace: "London",
  //       programName: "Software Engineer",
  //       searchesForFriends: false,
  //       genderPreference: ['female', 'male', 'transgender'],
  //       gender: 'female',
  //       swipeLeft: [],
  //       swipeRight: [],
  //       matches: []),
  //   User(
  //       id: "2",
  //       name: "Cynthia Hellen",
  //       age: 24,
  //       interests: ["sports", "music", "movies"],
  //       bio: "I am a software engineer",
  //       profilePicture: "",
  //       imageUrls: [
  //         "https://images.unsplash.com/photo-1524502397800-2eeaad7c3fe5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
  //         "https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
  //         "https://images.unsplash.com/photo-1611880147493-7542bdb0f024?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YW1lcmljYW4lMjBnaXJsfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
  //         "https://images.unsplash.com/photo-1496440737103-cd596325d314?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Z2lybHxlbnwwfHwwfHw%3D&w=1000&q=80",
  //       ],
  //       coverPicture: "",
  //       programPlace: "London",
  //       programName: "Medical Doctor",
  //       searchesForFriends: false,
  //       genderPreference: [],
  //       gender: 'female',
  //       swipeLeft: [],
  //       swipeRight: [],
  //       matches: []),
  //   User(
  //       id: "3",
  //       name: "Torrey Hinton",
  //       age: 24,
  //       interests: ["sports", "music", "movies", 'sleeping', 'video games'],
  //       bio: "I am a software engineer",
  //       profilePicture: "",
  //       imageUrls: [
  //         "https://images.unsplash.com/photo-1524502397800-2eeaad7c3fe5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
  //         "https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
  //         "https://images.unsplash.com/photo-1611880147493-7542bdb0f024?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YW1lcmljYW4lMjBnaXJsfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
  //         "https://images.unsplash.com/photo-1496440737103-cd596325d314?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Z2lybHxlbnwwfHwwfHw%3D&w=1000&q=80",
  //       ],
  //       coverPicture: "",
  //       programPlace: "United Kingdom",
  //       programName: "Data Scientist",
  //       searchesForFriends: false,
  //       genderPreference: ['female', 'male', 'transgender'],
  //       gender: 'male',
  //       swipeLeft: [],
  //       swipeRight: [],
  //       matches: []),
  //   User(
  //       id: "4",
  //       name: "Jane Murrey",
  //       age: 24,
  //       interests: ["sports", "music", "movies"],
  //       bio: "I am a software engineer",
  //       profilePicture: "",
  //       imageUrls: [
  //         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
  //         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
  //         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
  //         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
  //         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
  //       ],
  //       coverPicture: "",
  //       programPlace: "London",
  //       programName: "Software Engineer",
  //       searchesForFriends: false,
  //       genderPreference: ['female', 'male', 'transgender'],
  //       gender: 'female',
  //       swipeLeft: [],
  //       swipeRight: [],
  //       matches: []),
  //   User(
  //       id: "5",
  //       name: "Debby Clarke",
  //       age: 24,
  //       interests: ["sports", "music", "movies"],
  //       bio: "I am a software engineer",
  //       profilePicture: "",
  //       imageUrls: [
  //         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
  //         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
  //         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
  //         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
  //         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
  //       ],
  //       coverPicture: "",
  //       programPlace: "United State of America",
  //       programName: "Model",
  //       searchesForFriends: false,
  //       genderPreference: ['female', 'male', 'transgender'],
  //       gender: 'female',
  //       swipeLeft: [],
  //       swipeRight: [],
  //       matches: []),
  //   User(
  //       id: "6",
  //       name: "Andrea Smith",
  //       age: 24,
  //       interests: ["sports", "music", "movies"],
  //       bio: "I am a software engineer",
  //       profilePicture: "",
  //       imageUrls: [
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //       ],
  //       coverPicture: "",
  //       programPlace: "Chicago, IL",
  //       programName: "Photographer",
  //       searchesForFriends: false,
  //       genderPreference: ['female', 'male', 'transgender'],
  //       gender: 'female',
  //       swipeLeft: [],
  //       swipeRight: [],
  //       matches: []),
  //   User(
  //       id: "7",
  //       name: "Andrea Smith",
  //       age: 24,
  //       interests: ["sports", "music", "movies"],
  //       bio: "I am a software engineer",
  //       profilePicture: "",
  //       imageUrls: [
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //       ],
  //       coverPicture: "",
  //       programPlace: "Chicago, IL",
  //       programName: "Photographer",
  //       searchesForFriends: false,
  //       genderPreference: ['female', 'male', 'transgender'],
  //       gender: 'female',
  //       swipeLeft: [],
  //       swipeRight: [],
  //       matches: []),
  //   User(
  //       id: "8",
  //       name: "Andrea Smith",
  //       age: 24,
  //       interests: ["sports", "music", "movies"],
  //       bio: "I am a software engineer",
  //       profilePicture: "",
  //       imageUrls: const [
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //       ],
  //       coverPicture: "",
  //       programPlace: "Chicago, IL",
  //       programName: "Photographer",
  //       searchesForFriends: false,
  //       genderPreference: ['female', 'male', 'transgender'],
  //       gender: 'female',
  //       swipeLeft: [],
  //       swipeRight: [],
  //       matches: []),
  //   User(
  //       id: "10",
  //       name: "Andrea Smith",
  //       age: 24,
  //       interests: const ["sports", "music", "movies"],
  //       bio: "I am a software engineer",
  //       profilePicture: "",
  //       imageUrls: const [
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //       ],
  //       coverPicture: "",
  //       programPlace: "Chicago, IL",
  //       programName: "Photographer",
  //       searchesForFriends: false,
  //       genderPreference: ['female', 'male', 'transgender'],
  //       gender: 'female',
  //       swipeLeft: [],
  //       swipeRight: [],
  //       matches: []),
  //   User(
  //       id: "11",
  //       name: "Andrea Smith",
  //       age: 24,
  //       interests: const ["sports", "music", "movies"],
  //       bio: "I am a software engineer",
  //       profilePicture: "",
  //       imageUrls: const [
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  //       ],
  //       coverPicture: "",
  //       programPlace: "Chicago, IL",
  //       programName: "Photographer",
  //       searchesForFriends: false,
  //       genderPreference: ['female', 'male', 'transgender'],
  //       gender: 'female',
  //       swipeLeft: [],
  //       swipeRight: [],
  //       matches: []),
  // ];
}
