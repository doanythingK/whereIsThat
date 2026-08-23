import { createClient } from 'npm:@supabase/supabase-js@2';

const supabaseUrl = Deno.env.get('SUPABASE_URL');
const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

if (!supabaseUrl || !serviceRoleKey) {
  throw new Error('SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required');
}

const admin = createClient(supabaseUrl, serviceRoleKey, {
  auth: { autoRefreshToken: false, persistSession: false },
});

const cutoff = new Date().toISOString();

async function purgeDeletedItems() {
  const { data: items, error } = await admin
    .from('items')
    .select('id')
    .not('delete_purge_at', 'is', null)
    .lte('delete_purge_at', cutoff);
  if (error) throw error;

  for (const item of items ?? []) {
    const { data: photos, error: photoError } = await admin
      .from('item_photos')
      .select('storage_path')
      .eq('item_id', item.id);
    if (photoError) throw photoError;
    const paths = (photos ?? []).map((photo) => photo.storage_path as string);
    if (paths.length > 0) {
      const { error: storageError } = await admin.storage
        .from('item-photos')
        .remove(paths);
      if (storageError) throw storageError;
    }
    const { error: deleteError } = await admin
      .from('items')
      .delete()
      .eq('id', item.id);
    if (deleteError) throw deleteError;
  }
}

async function purgeRows(table: string) {
  const { error } = await admin
    .from(table)
    .delete()
    .not('delete_purge_at', 'is', null)
    .lte('delete_purge_at', cutoff);
  if (error) throw error;
}

async function purgeAccounts() {
  const { data: profiles, error } = await admin
    .from('profiles')
    .select('id')
    .not('deleted_at', 'is', null)
    .lte('deleted_at', cutoff);
  if (error) throw error;
  for (const profile of profiles ?? []) {
    const { error: deleteError } = await admin.auth.admin.deleteUser(profile.id);
    if (deleteError) throw deleteError;
  }
}

try {
  await purgeDeletedItems();
  await purgeRows('locations');
  await purgeRows('floor_plans');
  await purgeRows('spaces');
  await purgeAccounts();
  console.log(JSON.stringify({ ok: true, cutoff }));
} catch (error) {
  console.error(error);
  Deno.exit(1);
}
