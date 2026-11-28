# Architecture

The Flutter demo repository remains local. The accounts workspace uses Supabase Auth and an independent family repository. Signed-in requests carry the current user session, and PostgreSQL applies explicit grants and Row Level Security.

Auth users own profiles. Families have one active owner and may have multiple members. Invitations belong to a family and address a verified email. Devices belong to families. Pairing requests and status reference devices, and security events reference families.

SQL migrations own schema changes. Public invoker functions call private, guarded transactions for family operations. The static site uses the existing Vercel workflow.
