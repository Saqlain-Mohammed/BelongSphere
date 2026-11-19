import { items } from '../src/data.ts';
import { writeFileSync } from 'node:fs';
const literal = value => "'" + String(value).replaceAll("'", "''") + "'";
const sql = '-- Optional fictional demo catalog. Run after the initial migration.\n-- Entries have no owner. They are for browsing, not contacting real people.\ninsert into public.listings (id,kind,title,details) values\n' + items.map(item=>`(${literal(item.id)},${literal(item.kind)},${literal(item.title)},${literal(JSON.stringify(item))}::jsonb)`).join(',\n') + '\non conflict (id) do nothing;\n';
writeFileSync(new URL('../supabase/seed.sql',import.meta.url),sql);
console.log('Generated supabase/seed.sql with '+items.length+' sample listings.');
