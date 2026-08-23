# purge_deleted_data

Run this Edge Function daily from Supabase Cron after applying the MVP
migration. It uses `SUPABASE_SERVICE_ROLE_KEY` only inside the Edge Function;
the key must never be included in Flutter or in a public repository.

The function permanently removes spaces, floor plans, locations, and items
whose 30-day purge timestamp has passed. Item photo files are removed from the
private `item-photos` bucket before their rows are deleted. Profiles marked for
account deletion are removed through the Auth admin API after the same grace
period.
