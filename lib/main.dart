import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'Database/data_getter.dart';
import 'Database/mydatabase.dart';
import 'Database/sql.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
// Initialize FFI
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataGetter dbgetter = DataGetter();
  final HospitalDatabase db = HospitalDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Bank App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _insertdata();
              },
              child: Text('insert data'),
            ),
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () {
                _retrieveCompatibleTypes();
              },
              child: Text('Retrieve Compatible Types'),
            ),
            ElevatedButton(
              onPressed: () {
                _retrieveMedicalHistories();
              },
              child: Text('Retrieve Medical Histories'),
            ),
            ElevatedButton(
              onPressed: () {
                _retrievePatientInfos();
              },
              child: Text('Retrieve Patient Infos'),
            ),
            ElevatedButton(
              onPressed: () {
                _retrieveDonors();
              },
              child: Text('Retrieve Donors'),
            ),
            ElevatedButton(
              onPressed: () {
                _retrieveDonations();
              },
              child: Text('Retrieve Donations'),
            ),
            ElevatedButton(
              onPressed: () {
                _retrieveReceived();
              },
              child: Text('Retrieve Received'),
            ),
            ElevatedButton(
              onPressed: () {
                _retrieveDonates();
              },
              child: Text('Retrieve Donates'),
            ),
          ],
        ),
      ),
    );
  }

  void _insertdata() async {
    db.database;
    await db.insertBloodType({'Type': 'A+'});
    await db.insertBloodType({'Type': 'B+'});
    await db.insertBloodType({'Type': 'O+'});

    await db.insertPerson({
      'FirstName': 'John',
      'LastName': 'Doe',
      'Address': '123 Main St',
      'ContactNumber': '555-1234',
      'Email': 'johndoe@example.com',
      'Username': 'johndoe',
      'Password': 'password123',
    });

    await db.insertPerson({
      'FirstName': 'Jane',
      'LastName': 'Smith',
      'Address': '456 Elm St',
      'ContactNumber': '555-5678',
      'Email': 'janesmith@example.com',
      'Username': 'janesmith',
      'Password': 'password456',
    });

    await db.insertCompatibleType({'compatibleType': 'Compatible 1', 'BloodId': 1});
    await db.insertCompatibleType({'compatibleType': 'Compatible 2', 'BloodId': 2});
    await db.insertCompatibleType({'compatibleType': 'Compatible 3', 'BloodId': 3});

    await db.insertMedicalHistory({'MedicalHistory': 'History 1', 'HistoryId': 1});
    await db.insertMedicalHistory({'MedicalHistory': 'History 2', 'HistoryId': 2});
    await db.insertMedicalHistory({'MedicalHistory': 'History 3', 'HistoryId': 3});

    await db.insertPatientInfo({'PatientId': 1, 'BloodId': 1, 'HistoryId': 1});
    await db.insertPatientInfo({'PatientId': 2, 'BloodId': 2, 'HistoryId': 2});

    await db.insertDonor({
      'BirthDate': '1990-01-01',
      'Weight': 70,
      'DonerId': 1,
      'HistoryId': 1,
    });

    await db.insertDonation({
      'DonationId': 1,
      'DonationDate': DateTime.now().toIso8601String(),
      'ExpirationDate': DateTime.now().add(Duration(days: 30)).toIso8601String(),
      'Status': 'Active',
      'AdminId': 1,
      'DonerId': 1,
    });

    await db.insertReceived({
      'ReceivedAmount': 250,
      'DonationId': 1,
      'PatientId': 1,
    });

    await db.insertDonate({
      'DonateAmount': 100,
      'DonerId': 1,
      'DonatioId': 1,
    });
  }

  void _retrieveCompatibleTypes() async {
    final compatibleTypes = await dbgetter.getCompatibleTypes();
    print('Compatible Types:');
    for (final compatibleType in compatibleTypes) {
      print(compatibleType);
    }
  }

  void _retrieveMedicalHistories() async {
    final medicalHistories = await dbgetter.getMedicalHistories();
    print('Medical Histories:');
    for (final medicalHistory in medicalHistories) {
      print(medicalHistory);
    }
  }

  void _retrievePatientInfos() async {
    final patientInfos = await dbgetter.getPatientInfos();
    print('Patient Infos:');
    for (final patientInfo in patientInfos) {
      print(patientInfo);
    }
  }

  void _retrieveDonors() async {
    final donors = await dbgetter.getDonors();
    print('Donors:');
    for (final donor in donors) {
      print(donor);
    }
  }

  void _retrieveDonations() async {
    final donations = await dbgetter.getDonations();
    print('Donations:');
    for (final donation in donations) {
      print(donation);
    }
  }

  void _retrieveReceived() async {
    final received = await dbgetter.getReceived();
    print('Received:');
    for (final receivedItem in received) {
      print(receivedItem);
    }
  }

  void _retrieveDonates() async {
    final donates = await dbgetter.getDonates();
    print('Donates:');
    for (final donate in donates) {
      print(donate);
    }
  }
}
