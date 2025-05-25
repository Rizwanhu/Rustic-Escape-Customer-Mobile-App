//supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';
import 'cabin_model.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://mdajdfbnhtgiwbutpzcj.supabase.co';
  static const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1kYWpkZmJuaHRnaXdidXRwemNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjMwMjYxMjIsImV4cCI6MjAzODYwMjEyMn0.ppDVHeYd_gksU1r6k_699mfhEJ8n2ixSJ-o-VCzTnt0';

  final SupabaseClient client = Supabase.instance.client;
  GoTrueClient get auth => client.auth;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
    print('[INIT] Supabase initialized');
  }

  // Authentication
  Future<AuthResponse> signInWithPhone(String phone, String password) async {
    print('[AUTH] Signing in with $phone');
    return await client.auth.signInWithPassword(email: phone, password: password);
  }

  Future<int> getOrCreateGuestIdForCurrentUser() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;

    if (user == null || user.email == null) {
      throw Exception('User not logged in or email is null');
    }

    // 1. Check if a guest already exists with this email
    final guest = await client
        .from('guests')
        .select('id')
        .eq('email', user.email!)
        .maybeSingle();

    if (guest != null && guest['id'] != null) {
      return guest['id'] as int;
    }

    // 2. If not, insert a new guest with the current user's email
    final insertedGuest = await client
        .from('guests')
        .insert({
      'email': user.email!,
      'created_at': DateTime.now().toIso8601String(),
    })
        .select()
        .single();

    return insertedGuest['id'] as int;
  }

  Future<AuthResponse> signUp(String email, String password, String dob) async {
    print('[AUTH] Signing up new user: $email');

    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {'dob': dob},
    );

    // If sign-up is successful, insert into guests table
    final user = response.user;
    if (user != null) {
      await client.from('guests').insert({
        'email': user.email!, // use the non-null assertion operator
        'created_at': DateTime.now().toIso8601String(),
      });
      print('[GUESTS] Guest record created for user: ${user.id}');
    }

    return response;
  }

  Future<void> signOut() async {
    print('[AUTH] Signing out');
    await client.auth.signOut();
  }

  // Cabins
  Future<List<Map<String, dynamic>>> getAllCabins() async {
    final response = await client.from('cabins').select('''
      id, created_at, name, maxCapacity, regularPrice,
      discount, description, image
    ''');
    print('[CABINS] Loaded cabins: $response');
    return response;
  }

  Future<int> getGuestIdFromUserId(String userId) async {
    final response = await client
        .from('guests')
        .select('id')
        .eq('user_id', userId)
        .single();

    if (response == null || response['id'] == null) {
      throw Exception('Guest not found for user ID $userId');
    }

    return response['id'] as int;
  }


  Future<Cabin> getCabinById(String id) async {
    final response = await client.from('cabins').select().eq('id', id).single();
    print('[CABINS] Cabin $id data: $response');
    return Cabin.fromJson({
      ...response,
      'id': int.tryParse(response['id'].toString()) ?? 0,  // Convert to int
    });
  }

  // Bookings
  Future<List<Map<String, dynamic>>> getUserBookings(String userId) async {
    final guestId = await getOrCreateGuestIdForCurrentUser(); // 👈 bigint
    final data = await client
        .from('bookings')
        .select('id, startDate, endDate, numGuests, cabinPrice, status, cabinId')
        .eq('guestId', guestId);
    return data;
  }

  //guests
  Future<List<Map<String, dynamic>>> getGuests() async {
    final response = await client.from('guests').select('''
      id, created_at, fullName, email, nationalID,
      nationality
    ''');
    print('[GUESTS] Loaded guests: $response');
    return response;
  }

  // Fetch guest info for current user
  Future<Map<String, dynamic>?> getGuestInfo() async {
    final user = client.auth.currentUser;
    if (user == null || user.email == null) return null;

    final guest = await client
        .from('guests')
        .select('id, fullName, nationalID, nationality, email')
        .eq('email', user.email!)
        .maybeSingle();

    return guest;
  }

// Update guest info for current user
  Future<void> updateGuestInfo({
    required String fullName,
    required String nationalID,
    required String nationality,
  }) async {
    final user = client.auth.currentUser;
    if (user == null || user.email == null) throw Exception('No logged in user');

    await client
        .from('guests')
        .update({
      'fullName': fullName,
      'nationalID': nationalID,
      'nationality': nationality,
    })
        .eq('email', user.email!);
  }

  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    final guestId = await getOrCreateGuestIdForCurrentUser(); // ✅ bigint
    final data = {
      ...bookingData,
      'guestId': guestId,
    };

    final response = await client.from('bookings').insert(data);
    print('[BOOKINGS] Booking created: $response');
  }

// Cancel a booking by updating its status
  Future<void> cancelBooking(String id) async {
    final response = await client
        .from('bookings')
        .update({'status': 'cancelled'})
        .eq('id', id);
    print('[BOOKINGS] Booking cancelled: $response');
  }
}
