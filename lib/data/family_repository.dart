import 'package:supabase_flutter/supabase_flutter.dart';

typedef RecordData = Map<String, dynamic>;

abstract interface class FamilyRepository {
  Future<List<RecordData>> families();
  Future<List<RecordData>> invitations();
  Future<List<RecordData>> members(String familyId);
  Future<void> createFamily(String name);
  Future<void> invite(String familyId, String email);
  Future<void> respond(String inviteId, bool accept);
  Future<void> revoke(String familyId, String userId);
}

class SupabaseFamilyRepository implements FamilyRepository {
  SupabaseFamilyRepository(this.client);
  final SupabaseClient client;

  @override
  Future<List<RecordData>> families() => client
      .from('families')
      .select('id,name,family_memberships!inner(role)')
      .eq('family_memberships.user_id', client.auth.currentUser!.id)
      .order('name');

  @override
  Future<List<RecordData>> invitations() => client
      .from('family_invitations')
      .select('id,family_name,expires_at')
      .eq('email', client.auth.currentUser!.email!.toLowerCase())
      .eq('state', 'pending')
      .gt('expires_at', DateTime.now().toUtc().toIso8601String())
      .order('expires_at');

  @override
  Future<List<RecordData>> members(String familyId) async {
    final rows = await client
        .from('family_memberships')
        .select('user_id,role,created_at')
        .eq('family_id', familyId)
        .order('created_at');
    return [
      for (final row in rows)
        {
          ...row,
          'label': 'Member ${(row['user_id'] as String).substring(0, 8)}',
        },
    ];
  }

  @override
  Future<void> createFamily(String name) async {
    await client.rpc('st_create_family', params: {'family_name': name});
  }

  @override
  Future<void> invite(String familyId, String email) async {
    await client.rpc(
      'st_invite',
      params: {'target': familyId, 'recipient': email},
    );
  }

  @override
  Future<void> respond(String inviteId, bool accept) async {
    await client.rpc(
      'st_respond',
      params: {'invitation': inviteId, 'accept': accept},
    );
  }

  @override
  Future<void> revoke(String familyId, String userId) async {
    await client.rpc(
      'st_revoke_member',
      params: {'target': familyId, 'member_id': userId},
    );
  }
}
