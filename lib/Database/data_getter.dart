import 'package:ics_321/Database/sql.dart';

class DataGetter {
  HospitalDatabase instance = HospitalDatabase.instance;
  Future<List<Map<String, dynamic>>> getCompatibleTypes() async {
    final db = await instance.database;
    return await db.query('compatibleType');
  }

  Future<List<Map<String, dynamic>>> getMedicalHistories() async {
    final db = await instance.database;
    return await db.query('MedicalHistory');
  }

  Future<List<Map<String, dynamic>>> getPatientInfos() async {
    final db = await instance.database;
    return await db.query('PatientInfo');
  }

  Future<List<Map<String, dynamic>>> getDonors() async {
    final db = await instance.database;
    return await db.query('Donor');
  }

  Future<List<Map<String, dynamic>>> getDonations() async {
    final db = await instance.database;
    return await db.query('Donation');
  }

  Future<List<Map<String, dynamic>>> getReceived() async {
    final db = await instance.database;
    return await db.query('Received');
  }

  Future<List<Map<String, dynamic>>> getDonates() async {
    final db = await instance.database;
    return await db.query('Donate');
  }

// this method List of all blood donations received in a week or a month
  Future<List<Map<String, dynamic>>> getBloodDonationsInPeriod(DateTime startDate, DateTime endDate) async {
    final db = await instance.database;
    return await db.query(
      'Donation',
      where: 'donationDate BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );
  }

// this method List the aggregated amount available for each blood type
  Future<List<Map<String, dynamic>>> getAggregatedBloodAmountByType() async {
    final db = await instance.database;
    return await db.rawQuery('''
    SELECT bloodType, SUM(amount) AS totalAmount
    FROM Donation
    GROUP BY bloodType
  ''');
  }

// this method List all Collection Drive and total blood collected during each drive
  Future<List<Map<String, dynamic>>> getCollectionDriveTotals() async {
    final db = await instance.database;
    return await db.rawQuery('''
    SELECT CollectionDrive.driveName, SUM(Donation.amount) AS totalAmount
    FROM CollectionDrive
    LEFT JOIN Donation ON CollectionDrive.driveId = Donation.driveId
    GROUP BY CollectionDrive.driveId
  ''');
  }
}
