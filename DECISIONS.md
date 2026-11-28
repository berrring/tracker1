# Decisions

- Preserve the local demo as the default entry point so an account or outage does not block demonstration and USB setup.
- Use Supabase Auth for persistent sessions and verified email identity.
- Use seven-day in-app invitations. The invite operation does not send email or disclose whether the address has an account.
- Write memberships and security events in guarded database transactions. Use an invoker wrapper in the API schema and private elevated functions.
- Delay location ingestion until a separate consent, retention and access review.
