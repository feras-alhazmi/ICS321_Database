import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HospitalDatabase {
  static final HospitalDatabase instance = HospitalDatabase._();
  static Database? _database;

  HospitalDatabase._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    print("initDatabase  finaly  ");
    return _database!;
  }

  initDatabase() async {
    final String path = join(await getDatabasesPath(), 'feras.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE MedicalHistory (
        HistoryId INTEGER PRIMARY KEY,
        MedicalHistory TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE BloodType (
        BloodId INTEGER PRIMARY KEY,
        Type TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Person (
        Id INTEGER PRIMARY KEY,
        FirstName TEXT NOT NULL,
        LastName TEXT NOT NULL,
        Address TEXT NOT NULL,
        ContactNumber TEXT NOT NULL,
        Email TEXT NOT NULL,
        Username TEXT NOT NULL,
        Password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE compatibleType (
        compatibleType TEXT NOT NULL,
        BloodId INTEGER NOT NULL,
        FOREIGN KEY (BloodId) REFERENCES BloodType(BloodId)
      )
    ''');

    await db.execute('''
      CREATE TABLE PatientInfo (
        PatientId INTEGER PRIMARY KEY,
        BloodId INTEGER NOT NULL,
        HistoryId INTEGER NOT NULL,
        FOREIGN KEY (PatientId) REFERENCES Person(Id),
        FOREIGN KEY (BloodId) REFERENCES BloodType(BloodId),
        FOREIGN KEY (HistoryId) REFERENCES MedicalHistory(HistoryId)
      )
    ''');

    await db.execute('''
      CREATE TABLE Donor (
        BirthDate TEXT NOT NULL,
        Weight INTEGER NOT NULL,
        DonorId INTEGER PRIMARY KEY,
        HistoryId INTEGER NOT NULL,
        FOREIGN KEY (DonorId) REFERENCES Person(Id),
        FOREIGN KEY (HistoryId) REFERENCES MedicalHistory(HistoryId)
      )
    ''');

    await db.execute('''
      CREATE TABLE Donation (
        DonationId INTEGER PRIMARY KEY,
        DonationDate TEXT NOT NULL,
        ExpirationDate TEXT NOT NULL,
        Status TEXT NOT NULL,
        AdminId INTEGER NOT NULL,
        DonorId INTEGER NOT NULL,
        FOREIGN KEY (AdminId) REFERENCES Person(Id),
        FOREIGN KEY (DonorId) REFERENCES Donor(DonorId)
      )
    ''');

    await db.execute('''
      CREATE TABLE received (
        ReceivedAmount INTEGER NOT NULL,
        DonationId INTEGER NOT NULL,
        PatientId INTEGER NOT NULL,
        FOREIGN KEY (DonationId) REFERENCES Donation(DonationId),
        FOREIGN KEY (PatientId) REFERENCES PatientInfo(PatientId)
      )
    ''');

    await db.execute('''
      CREATE TABLE Donate (
        DonateAmount INTEGER NOT NULL,
        DonorId INTEGER NOT NULL,
        DonationId INTEGER NOT NULL,
        FOREIGN KEY (DonorId) REFERENCES Person(Id),
        FOREIGN KEY (DonationId) REFERENCES Donation(DonationId)
      )
    ''');
  }

  // Insert operations

  Future<int> insertBloodType(Map<String, dynamic> bloodType) async {
    final db = await instance.database;
    return await db.insert('BloodType', bloodType);
  }

  Future<int> insertPerson(Map<String, dynamic> person) async {
    final db = await instance.database;
    return await db.insert('Person', person);
  }

  Future<int> insertCompatibleType(Map<String, dynamic> compatibleType) async {
    final db = await instance.database;
    return await db.insert('compatibleType', compatibleType);
  }

  Future<int> insertMedicalHistory(Map<String, dynamic> medicalHistory) async {
    final db = await instance.database;
    return await db.insert('MedicalHistory', medicalHistory);
  }

  Future<int> insertPatientInfo(Map<String, dynamic> patientInfo) async {
    final db = await instance.database;
    return await db.insert('PatientInfo', patientInfo);
  }

  Future<int> insertDonor(Map<String, dynamic> donor) async {
    final db = await instance.database;
    return await db.insert('Donor', donor);
  }

  Future<int> insertDonation(Map<String, dynamic> donation) async {
    final db = await instance.database;
    return await db.insert('Donation', donation);
  }

  Future<int> insertReceived(Map<String, dynamic> received) async {
    final db = await instance.database;
    return await db.insert('Received', received);
  }

  Future<int> insertDonate(Map<String, dynamic> donate) async {
    final db = await instance.database;
    return await db.insert('Donate', donate);
  }

  // Add insert methods for other tables

  // Update operations

  Future<int> updateBloodType(Map<String, dynamic> bloodType) async {
    final db = await instance.database;
    final bloodId = bloodType['BloodId'];
    return await db.update('BloodType', bloodType, where: 'BloodId = ?', whereArgs: [bloodId]);
  }

  Future<int> updatePerson(Map<String, dynamic> person) async {
    final db = await instance.database;
    final id = person['Id'];
    return await db.update('Person', person, where: 'Id = ?', whereArgs: [id]);
  }

  Future<int> updateCompatibleType(Map<String, dynamic> compatibleType) async {
    final db = await instance.database;
    final bloodId = compatibleType['BloodId'];
    return await db.update('compatibleType', compatibleType, where: 'BloodId = ?', whereArgs: [bloodId]);
  }

  Future<int> updateMedicalHistory(Map<String, dynamic> medicalHistory) async {
    final db = await instance.database;
    final historyId = medicalHistory['HistoryId'];
    return await db.update('MedicalHistory', medicalHistory, where: 'HistoryId = ?', whereArgs: [historyId]);
  }

  Future<int> updatePatientInfo(Map<String, dynamic> patientInfo) async {
    final db = await instance.database;
    final patientId = patientInfo['PatientId'];
    return await db.update('PatientInfo', patientInfo, where: 'PatientId = ?', whereArgs: [patientId]);
  }

  Future<int> updateDonor(Map<String, dynamic> donor) async {
    final db = await instance.database;
    final donorId = donor['DonorId'];
    return await db.update('Donor', donor, where: 'DonorId = ?', whereArgs: [donorId]);
  }

  Future<int> updateDonation(Map<String, dynamic> donation) async {
    final db = await instance.database;
    final donationId = donation['DonationId'];
    return await db.update('Donation', donation, where: 'DonationId = ?', whereArgs: [donationId]);
  }

  // Add update methods for other tables

  // Delete operations

  Future<int> deleteBloodType(int bloodId) async {
    final db = await instance.database;
    return await db.delete('BloodType', where: 'BloodId = ?', whereArgs: [bloodId]);
  }

  Future<int> deletePerson(int id) async {
    final db = await instance.database;
    return await db.delete('Person', where: 'Id = ?', whereArgs: [id]);
  }

  Future<int> deleteCompatibleType(int bloodId) async {
    final db = await instance.database;
    return await db.delete('compatibleType', where: 'BloodId = ?', whereArgs: [bloodId]);
  }

  Future<int> deleteMedicalHistory(int historyId) async {
    final db = await instance.database;
    return await db.delete('MedicalHistory', where: 'HistoryId = ?', whereArgs: [historyId]);
  }

  Future<int> deletePatientInfo(int patientId) async {
    final db = await instance.database;
    return await db.delete('PatientInfo', where: 'PatientId = ?', whereArgs: [patientId]);
  }

  Future<int> deleteDonor(int donorId) async {
    final db = await instance.database;
    return await db.delete('Donor', where: 'DonorId = ?', whereArgs: [donorId]);
  }

  Future<int> deleteDonation(int donationId) async {
    final db = await instance.database;
    return await db.delete('Donation', where: 'DonationId = ?', whereArgs: [donationId]);
  }

  // Add delete methods for other tables
}
