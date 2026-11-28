# Security and privacy

The browser and native app may receive only the Supabase publishable key. Keep service-role credentials and database passwords outside client code. Restrict production authentication redirects to approved URLs.

Anonymous users have zero table and RPC access. Authenticated reads are scoped to self, active family membership, owner status, or a matching verified invitation address. Clients cannot write membership, devices, status or audit records directly. Revocation takes effect on the next database request.

The accounts feature collects account email and family names. It does not collect child location, SIM details, emergency contact numbers or USB results. Use fictional local accounts to verify policies.
