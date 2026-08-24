import { createClient } from 'npm:@supabase/supabase-js@2';

const supabaseUrl = Deno.env.get('SUPABASE_URL');
const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
const projectId = Deno.env.get('FCM_PROJECT_ID');
const clientEmail = Deno.env.get('FCM_CLIENT_EMAIL');
const privateKey = Deno.env.get('FCM_PRIVATE_KEY');

if (!supabaseUrl || !serviceRoleKey) {
  throw new Error('SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required');
}

const admin = createClient(supabaseUrl, serviceRoleKey, {
  auth: { autoRefreshToken: false, persistSession: false },
});

const encoder = new TextEncoder();

function base64Url(value: Uint8Array | string) {
  const bytes = typeof value === 'string' ? encoder.encode(value) : value;
  let binary = '';
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary).replaceAll('+', '-').replaceAll('/', '_').replace(/=+$/, '');
}

function pemToBytes(pem: string) {
  const base64 = pem
    .replace('-----BEGIN PRIVATE KEY-----', '')
    .replace('-----END PRIVATE KEY-----', '')
    .replaceAll(/\s/g, '');
  const binary = atob(base64);
  return Uint8Array.from(binary, (character) => character.charCodeAt(0));
}

async function accessToken() {
  if (!projectId || !clientEmail || !privateKey) {
    throw new Error('FCM_PROJECT_ID, FCM_CLIENT_EMAIL, and FCM_PRIVATE_KEY are required');
  }
  const issuedAt = Math.floor(Date.now() / 1000);
  const header = base64Url(JSON.stringify({ alg: 'RS256', typ: 'JWT' }));
  const claims = base64Url(JSON.stringify({
    iss: clientEmail,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    iat: issuedAt,
    exp: issuedAt + 3600,
  }));
  const unsigned = `${header}.${claims}`;
  const key = await crypto.subtle.importKey(
    'pkcs8',
    pemToBytes(privateKey.replaceAll('\\n', '\n')),
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    key,
    encoder.encode(unsigned),
  );
  const assertion = `${unsigned}.${base64Url(new Uint8Array(signature))}`;
  const response = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'content-type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion,
    }),
  });
  if (!response.ok) throw new Error(`FCM OAuth failed: ${await response.text()}`);
  const body = await response.json();
  return body.access_token as string;
}

function notificationCopy(eventType: string) {
  switch (eventType) {
    case 'space_member_joined':
      return { title: '공간 멤버 변경', body: '새 멤버가 공간에 참여했습니다.' };
    case 'space_member_role_changed':
      return { title: '관리자 권한 변경', body: '공간 멤버 권한이 변경되었습니다.' };
    case 'shopping_item_changed':
      return { title: '장보기 목록 변경', body: '공유 장보기 목록이 변경되었습니다.' };
    case 'shared_checklist_changed':
      return { title: '체크리스트 변경', body: '공유 체크리스트가 변경되었습니다.' };
    default:
      return { title: '공간 업데이트', body: '공유 데이터가 변경되었습니다.' };
  }
}

async function send(token: string, eventType: string, payload: Record<string, unknown>, bearer: string) {
  const copy = notificationCopy(eventType);
  const response = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: 'POST',
      headers: {
        authorization: `Bearer ${bearer}`,
        'content-type': 'application/json',
      },
      body: JSON.stringify({
        message: {
          token,
          notification: copy,
          data: Object.fromEntries(
            Object.entries(payload).map(([key, value]) => [key, String(value)]),
          ),
        },
      }),
    },
  );
  if (!response.ok) throw new Error(`FCM send failed: ${await response.text()}`);
}

async function main() {
  const { data: events, error } = await admin
    .from('notification_events')
    .select('id,recipient_user_id,event_type,payload')
    .is('delivered_at', null)
    .is('failed_at', null)
    .order('created_at')
    .limit(100);
  if (error) throw error;
  if (!events || events.length === 0) return;
  const bearer = await accessToken();

  for (const event of events) {
    try {
      const { data: devices, error: deviceError } = await admin
        .from('user_devices')
        .select('fcm_token')
        .eq('user_id', event.recipient_user_id)
        .eq('is_active', true);
      if (deviceError) throw deviceError;
      for (const device of devices ?? []) {
        await send(
          device.fcm_token as string,
          event.event_type as string,
          (event.payload ?? {}) as Record<string, unknown>,
          bearer,
        );
      }
      await admin
        .from('notification_events')
        .update({ delivered_at: new Date().toISOString() })
        .eq('id', event.id);
    } catch (error) {
      await admin
        .from('notification_events')
        .update({
          failed_at: new Date().toISOString(),
          error_message: String(error),
        })
        .eq('id', event.id);
    }
  }
}

try {
  await main();
  console.log(JSON.stringify({ ok: true }));
} catch (error) {
  console.error(error);
  Deno.exit(1);
}
